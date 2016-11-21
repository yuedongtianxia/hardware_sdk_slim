//
//  OpenHardwareIntelligentScaleNWDAO.m
//  SportsBar
//
//  Created by 张旻可 on 16/7/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "YDOpenHardwareIntelligentScaleNWDAO.h"

#import "YDPreference.h"
#import "YDOpenHardwareKit.h"
#import "YDOpenHardwareDB.h"
#import "YDOpenHardwareIntelligentScaleDBDAO.h"

#import "YDOpenHardwareIntelligentScale.h"
#import "YDOpenHardwareStatus.h"

static YDOpenHardwareIntelligentScaleNWDAO *singleton;
static YDPreference *kPreference;

static NSString *const kIntelligentScaleLastUpdateTs = @"hardware_intelligent_scale_last_update_ts";

@interface YDOpenHardwareIntelligentScaleNWDAO ()

@property (nonatomic, assign) BOOL needPull;
@property (nonatomic, assign) BOOL inPush;
@property (nonatomic, assign) BOOL inPull;

@end

@implementation YDOpenHardwareIntelligentScaleNWDAO

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!singleton) {
            singleton = [[self alloc] init];
        }
    });
    return singleton;
}

- (YDPreference *)preference {
    NSNumber *userId = self.userId;
    if (!kPreference || [kPreference.userId isEqual:userId]) {
        kPreference = [YDPreference preferenceWithSuitName:@"open.hardware" user:userId];
    }
    return kPreference;
}

- (void)trySync {
    if (self.inPull || self.inPush) {
        return;
    }
    self.needPull = YES;
    [self tryPush];
}
- (void)tryPull {
    if (self.inPull) {
        return;
    }
    self.inPull = YES;
    [self pull];
}
- (void)tryPush {
    if (self.inPush) {
        return;
    }
    self.inPush = YES;
    [self push];
}


- (void)pull {
    NSNumber *ts = [self pref_intelligentScaleLastUpdateTs];
    
    [[YDOpenHardwareKit shared].networkDelegate postForm:[YDURL GET_INTELLIGENT_SCALE] param:@{@"user_id": self.userId, @"max_weight_id": ts} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *res = responseObject;
        NSArray *jsonArr = [res objectForKey:@"weight_array_resp"];
        NSArray *arr = [MSJsonKit jsonObjToObj:jsonArr asClass:[NSArray class] WithKeyClass:@{@"msroot": [OpenHardwareIntelligentScale class]}];
        [self savePullRes:arr];
//        NSNumber *lut = [res objectForKey:@"last_update_ts"];
//        [self pref_setIntelligentScaleLastUpdateTs:lut];
        BOOL hasMore = ((NSNumber *)[res objectForKey:@"has_more"]).boolValue;
        if (hasMore) {
            [self pull];
        } else {
            self.inPull = NO;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, MSError *error) {
        self.inPull = NO;
    }];
    
}
- (void)push {
    __block NSArray<OpenHardwareIntelligentScale *> *pushData = nil;
    [[YDOpenHardwareDB sharedDb] inAsyncMainDatabase:^(FMDatabase *db) {
        pushData = [OpenHardwareIntelligentScaleDBDAO selectOpenHardwareIntelligentScaleByStatus:@(OpenHardwareStatusWaitUpload) fromDb:db];
        
    } completHandler:^{
        if (pushData.count > 0) {
            NSString *json = [MSJsonKit objToJson:pushData withKey:nil];
            json = [json stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
            json = [json stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
            if (json) {
                YDInHttpKit* http = [[YDInHttpKit alloc] init];
                
                http.shouldNotifyNetError = NO;
                http.shouldNotifyServerError = NO;
                http.shouldNotifyTokenTimeoutError = YES;
                http.shouldNotifyCancel = NO;
                
                http.useLocalCache = NO;
                
                [http postForm:[YDURL REPORT_INTELLIGENT_SCALE] param:@{@"user_id": self.userId, @"source": @"hardware_open", @"weight_array_json": json} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSDictionary *res = responseObject;
                    NSArray *jsonArr = [res objectForKey:@"weight_array_resp"];
                    NSArray *arr = [MSJsonKit jsonObjToObj:jsonArr asClass:[NSArray class] WithKeyClass:@{@"msroot": [OpenHardwareIntelligentScale class]}];
                    [self savePushResp:arr];
                    
                    if (self.needPull) {
                        self.needPull = NO;
                        [self tryPull];
                    }
                    self.inPush = NO;
                } failure:^(AFHTTPRequestOperation *operation, MSError *error) {
                    self.inPush = NO;
                }];
            } else {
                self.inPush = NO;
            }
        } else {
            self.inPush = NO;
        }
    }];
}

- (void)savePullRes:(NSArray<OpenHardwareIntelligentScale *> *)arr {
    if (!arr) {
        return;
    }
    NSInteger count = arr.count;
    if (count == 0) {
        return;
    }
    NSInteger minSid = 0;
    NSInteger maxSid = 0;
    for (NSInteger i = 0; i < count; i++) {
        OpenHardwareIntelligentScale *ois = [arr objectAtIndex:i];
        if (i == 0) {
            minSid = ois.serverId.integerValue;
            maxSid = ois.serverId.integerValue;
        } else {
            minSid = ois.serverId.integerValue < minSid ? ois.serverId.integerValue : minSid;
            maxSid = ois.serverId.integerValue > maxSid ? ois.serverId.integerValue : maxSid;
        }
        ois.status = @(OpenHardwareStatusSynced);
    }
    [self pref_setIntelligentScaleLastUpdateTs:@(maxSid)];
    [[YDOpenHardwareDB sharedDb] inAsyncMainDatabase:^(FMDatabase *db) {
        NSArray<NSNumber *> *exsitSids = [OpenHardwareIntelligentScaleDBDAO selectServerIdsByStartServerId:@(minSid) endServerId:@(maxSid) fromDb:db];
        if (exsitSids.count < count) {
            for (NSInteger j = 0; j < count; j ++) {
                OpenHardwareIntelligentScale *ois = [arr objectAtIndex:j];
                if (![exsitSids containsObject:ois.serverId]) {
                    [OpenHardwareIntelligentScaleDBDAO insertOpenHardwareIntelligentScale:ois intoDb:db];
                }
            }
        }
    } completHandler:^{
        
    }];
}

- (void)savePushResp:(NSArray<OpenHardwareIntelligentScale *> *)arr {
    if (!arr) {
        return;
    }
    NSInteger count = arr.count;
    if (count == 0) {
        return;
    }
    [[YDOpenHardwareDB sharedDb] inAsyncMainDatabase:^(FMDatabase *db) {
        for (NSInteger i = 0; i < count; i ++) {
            OpenHardwareIntelligentScale *ois = [arr objectAtIndex:i];
            [OpenHardwareIntelligentScaleDBDAO updateStatusServerIdByPk:ois.ohiId status:@(OpenHardwareStatusSynced) serverId:ois.serverId fromDb:db];
        }
    } completHandler:^{
        
    }];
}

#pragma mark --preference
- (NSNumber *)pref_intelligentScaleLastUpdateTs {
    NSNumber *ts = [self.preference objectForKey:kIntelligentScaleLastUpdateTs];
    ts = ts ? ts : @0;
    return ts;
}
- (void)pref_setIntelligentScaleLastUpdateTs:(NSNumber *)ts {
    [self.preference setObject:ts forKey:kIntelligentScaleLastUpdateTs];
}

#pragma mark --userId
- (NSNumber *)userId {
    return [YDAppInstance userId];
}

@end
