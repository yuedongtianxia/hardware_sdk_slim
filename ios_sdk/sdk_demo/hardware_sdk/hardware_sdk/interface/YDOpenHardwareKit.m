//
//  YDOpenHardwareKit.m
//  hardware_sdk
//
//  Created by 张旻可 on 2016/11/4.
//  Copyright © 2016年 yuedong. All rights reserved.
//

#import "YDOpenHardwareKit.h"
#import <UIKit/UIApplication.h>

#import "YDPreference.h"

#import "YDOpenHardwarePedometerNWDAO.h"

static NSString *const kPrefUserIdKey = @"user_id";
static NSString *const kPrefAccessTokenKey = @"access_token";

static NSString *const kGetAccessTokenUrlFormat = @"yd-open-api://hardware.51yund.com/accessToken?appKey=%@&scope=%@";
static NSString *const kYuedongScheme = @"yd-open-api";
static NSString *const kYuedongSchemeUrl = @"yd-open-api://";

@interface YDOpenHardwareKit ()

@property (nonatomic, strong) YDPreference *preference;

@property (nonatomic, copy) void(^authBlock)(YDOpenHardwareSDKCode code);

@end

@implementation YDOpenHardwareKit

#pragma mark - preference
- (YDPreference *)preference {
    if (!_preference) {
        _preference = [YDPreference preferenceWithSuitName:@"open.hardware" user:nil];
    }
    return _preference;
}

- (NSNumber *)pref_userId {
    return [self.preference objectForKey:kPrefUserIdKey];
}

- (void)pref_setUserId:(NSNumber *)userId {
    [self.preference setObject:userId forKey:kPrefUserIdKey];
}

- (void)pref_removeUserId {
    [self.preference removeObjectForKey:kPrefUserIdKey];
}

- (NSString *)pref_accessToken {
    return [self.preference objectForKey:kPrefAccessTokenKey];
}

- (void)pref_setAccessToken:(NSString *)accessToken {
    [self.preference setObject:accessToken forKey:kPrefAccessTokenKey];
}

- (void)pref_remoteAccessToken {
    [self.preference removeObjectForKey:kPrefAccessTokenKey];
}



+ (instancetype)shared {
    static YDOpenHardwareKit *singleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!singleton) {
            singleton = [[self alloc] init];
        }
    });
    return singleton;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        if (self.networkDelegate) {
            [self yd_init];
        }
    }
    return self;
}

- (void)setNetworkDelegate:(id<YDNetworkDelegate>)networkDelegate {
    _networkDelegate = networkDelegate;
    if (_networkDelegate) {
        [self yd_init];
    }
}

- (void)yd_init {
    
}

- (YDOpenHardwareSDKStatus)SDKStatus {
    if ([self pref_userId].integerValue > 0 && [self pref_accessToken].length > 0) {
        return YDOpenHardwareSDKStatusAuthed;
    } else {
        return YDOpenHardwareSDKStatusUnAuth;
    }
    
}
- (void)tryAuth:(void(^)(YDOpenHardwareSDKCode code))then {
    if (self.appKey.length <= 0) {
        then(YDOpenHardwareSDKCodeAppKeyInvalid);
        return;
    }
//    if (!self.networkDelegate) {
//        return;
//    }
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:kYuedongSchemeUrl]]) {
        then(YDOpenHardwareSDKCodeVersionErrorOrNotInstalled);
        return;
    }
    self.authBlock = then;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:kGetAccessTokenUrlFormat, self.appKey, @""]];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
    
}

- (BOOL)unAuth {
    [self pref_removeUserId];
    [self pref_remoteAccessToken];
    return YES;
}

- (void)trySync {
    [[YDOpenHardwarePedometerNWDAO shared] tryPush];
}


- (BOOL)handleUrl:(NSURL *)url application:(UIApplication *)application {
    if ([url.host hasPrefix:@"hardware"]) {
        if ([url.path hasPrefix:@"/accessToken"]) {
            NSDictionary *dic = [self queryDicFromUrl:url];
            BOOL success = ((NSString *)[dic objectForKey:@"success"]).boolValue;
            NSNumber *userId = @(((NSString *)[dic objectForKey:@"user_id"]).integerValue);
            NSString *token = [dic objectForKey:@"token"];
            NSString *appKey = [dic objectForKey:@"app_key"];
            NSString *scope = [dic objectForKey:@"scope"];
            NSInteger code = ((NSString *)[dic objectForKey:@"success"]).integerValue;
            if (success) {
                [self pref_setUserId:userId];
                [self pref_setAccessToken:token];
                !self.authBlock?:self.authBlock(YDOpenHardwareSDKCodeSuccess);
            }
        }
        return YES;
    }
    return NO;
}

- (NSDictionary *)queryDicFromUrl:(NSURL *)url {
    if (!url) {
        return nil;
    }
    if ([UIDevice currentDevice].systemVersion.floatValue < 8) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSString *str = [NSString stringWithFormat:@"%@",url.absoluteString];
        NSArray *arr =[str componentsSeparatedByString:@"?"];
        if (arr.count ==2) {
            NSString *str1 = arr[1];
            NSArray *arr1 =[str1 componentsSeparatedByString:@"&"];
            for (int i=0; i<arr1.count; i++) {
                NSString *str2 = arr1[i];
                NSArray *arr2 =[str2 componentsSeparatedByString:@"="];
                if (arr2.count ==2) {
                    NSString *key = arr2[0];
                    id value = arr2[1];
                    [dic setObject:value forKey:key];
                }
            }
        }
        return dic;
    } else {
        NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url
                                                    resolvingAgainstBaseURL:NO];
        NSArray *queryItems = urlComponents.queryItems;
        NSMutableDictionary *dic = @{}.mutableCopy;
        for (NSURLQueryItem *item in queryItems) {
            [dic setObject:item.value forKey:item.name];
        }
        return dic;
    }
    
}

+ (YDOpenHardwareDP *)dataProvider {
    return [YDOpenHardwareDP sharedDP];
}

- (NSNumber *)userId {
    return [self pref_userId];
}

- (NSString *)accessToken {
    return [self pref_accessToken];
}

@end
