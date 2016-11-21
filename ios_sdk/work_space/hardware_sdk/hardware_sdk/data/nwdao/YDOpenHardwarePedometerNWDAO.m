//
//  OpenHardwareNWDAO.m
//  YDOpenHardwareCore
//
//  Created by 张旻可 on 16/7/25.
//  Copyright © 2016年 YD. All rights reserved.
//

#import "YDOpenHardwarePedometerNWDAO.h"

#import "YDPreference.h"
#import "YDOpenHardwareKit.h"
#import "YDOpenHardwareDB.h"
#import "YDOpenHardwarePedometerDBDAO.h"

#import "YDOpenHardwarePedometer.h"
#import "YDOpenHardwareStatus.h"

#import "MSJsonKit.h"

static YDOpenHardwarePedometerNWDAO *singleton;
static YDPreference *kPreference;

static NSString *const kPedometerLastUpdateTs = @"hardware_pedometer_last_update_ts";
static NSString *const kUploadUrl = @"http://api.51yund.com/hardware/report_hardware_step_by_slim_sdk";

@interface YDOpenHardwarePedometerNWDAO ()

@property (nonatomic, assign) BOOL needPull;
@property (nonatomic, assign) BOOL inPush;
@property (nonatomic, assign) BOOL inPull;

@end

@implementation YDOpenHardwarePedometerNWDAO

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
        if (!self.inPull && self.inPush) {
            self.needPull = YES;
        }
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
    NSNumber *ts = [self pref_pedometerLastUpdateTs];
    
//    [[YDOpenHardwareKit shared].networkDelegate postForm:kUploadUrl param:@{@"user_id": self.userId, @"last_update_ts": ts} then:^(id responseObject, NSError *error) {
//        if (!error) {
//            NSDictionary *res = responseObject;
//            NSArray *jsonArr = [res objectForKey:@"step_array_resp"];
//            NSArray *arr = [MSJsonKit jsonObjToObj:jsonArr asClass:[NSArray class] WithKeyClass:@{@"msroot": [OpenHardwarePedometer class]}];
//            [self savePullRes:arr];
//            NSNumber *lut = [res objectForKey:@"last_update_ts"];
//            [self pref_setPedometerLastUpdateTs:lut];
//            BOOL hasMore = ((NSNumber *)[res objectForKey:@"has_more"]).boolValue;
//            if (hasMore) {
//                [self pull];
//            } else {
//                self.inPull = NO;
//            }
//        } else {
//            self.inPull = NO;
//        }
//    }];
    self.inPull = NO;
    
    
}
- (void)push {
    __block NSArray<YDOpenHardwarePedometer *> *pushData = nil;
    [[YDOpenHardwareDB sharedDb] inAsyncMainDatabase:^(YDFMDatabase *db) {
        pushData = [YDOpenHardwarePedometerDBDAO selectYDOpenHardwarePedometerByStatus:@(YDOpenHardwareStatusWaitUpload) fromDb:db];
        
    } completHandler:^{
        if (pushData.count > 0) {
            NSString *json = [MSJsonKit objToJson:pushData withKey:nil];
            if (json) {
                NSDictionary *param = @{@"user_id": self.userId, @"token":[YDOpenHardwareKit shared].accessToken, @"app_id":[YDOpenHardwareKit shared].appKey, @"steps": json};
                [[YDOpenHardwareKit shared].networkDelegate postForm:kUploadUrl param:param then:^(id responseObject, NSError *error) {
                    if (!error) {
                        NSDictionary *res = responseObject;
                        NSNumber *code = [res objectForKey:@"code"];
//                        NSArray *jsonArr = [res objectForKey:@"step_array_resp"];
//                        NSArray *arr = [MSJsonKit jsonObjToObj:jsonArr asClass:[NSArray class] WithKeyClass:@{@"msroot": [YDOpenHardwarePedometer class]}];
                        if (code.integerValue == 0) {
                            [self savePushResp:pushData];
                            [[NSNotificationCenter defaultCenter] postNotificationName:kYDNtfOpenHardwareSyncFinished object:code];
                        } else {
                            [[NSNotificationCenter defaultCenter] postNotificationName:kYDNtfOpenHardwareSyncFinished object:@(YDOpenHardwareSDKCodeUnknowError)];
                        }
                        
                        if (self.needPull) {
                            self.needPull = NO;
                            [self tryPull];
                        }
                        self.inPush = NO;
                    } else {
                        self.inPush = NO;
                        if (self.needPull) {
                            self.needPull = NO;
                            [self tryPull];
                        }
                        [[NSNotificationCenter defaultCenter] postNotificationName:kYDNtfOpenHardwareSyncFinished object:@(YDOpenHardwareSDKCodeUnknowError)];
                    }
                }];
            } else {
                self.inPush = NO;
                if (self.needPull) {
                    self.needPull = NO;
                    [self tryPull];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:kYDNtfOpenHardwareSyncFinished object:@(YDOpenHardwareSDKCodeUnknowError)];
            }
        } else {
            self.inPush = NO;
            if (self.needPull) {
                self.needPull = NO;
                [self tryPull];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kYDNtfOpenHardwareSyncFinished object:@(YDOpenHardwareSDKCodeNoData)];
        }
    }];
}

- (void)savePullRes:(NSArray<YDOpenHardwarePedometer *> *)arr {
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
        YDOpenHardwarePedometer *ohp = [arr objectAtIndex:i];
        if (i == 0) {
            minSid = ohp.serverId.integerValue;
            maxSid = ohp.serverId.integerValue;
        } else {
            minSid = ohp.serverId.integerValue < minSid ? ohp.serverId.integerValue : minSid;
            maxSid = ohp.serverId.integerValue > maxSid ? ohp.serverId.integerValue : maxSid;
        }
        ohp.userId = [[YDOpenHardwareKit shared] userId];
        ohp.status = @(YDOpenHardwareStatusSynced);
    }
    [[YDOpenHardwareDB sharedDb] inAsyncMainDatabase:^(YDFMDatabase *db) {
        NSArray<NSNumber *> *exsitSids = [YDOpenHardwarePedometerDBDAO selectServerIdsByStartServerId:@(minSid) endServerId:@(maxSid) fromDb:db];
        if (exsitSids.count < count) {
            for (NSInteger j = 0; j < count; j ++) {
                YDOpenHardwarePedometer *ohp = [arr objectAtIndex:j];
                if (![exsitSids containsObject:ohp.serverId]) {
                    [YDOpenHardwarePedometerDBDAO insertYDOpenHardwarePedometer:ohp intoDb:db];
                }
            }
        }
    } completHandler:^{
        
    }];
}

- (void)savePushResp:(NSArray<YDOpenHardwarePedometer *> *)arr {
    if (!arr) {
        return;
    }
    NSInteger count = arr.count;
    if (count == 0) {
        return;
    }
    [[YDOpenHardwareDB sharedDb] inAsyncMainDatabase:^(YDFMDatabase *db) {
        for (NSInteger i = 0; i < count; i ++) {
            YDOpenHardwarePedometer *ohp = [arr objectAtIndex:i];
            [YDOpenHardwarePedometerDBDAO updateStatusServerIdByPk:ohp.ohpId status:@(YDOpenHardwareStatusSynced) serverId:@-1 fromDb:db];
        }
    } completHandler:^{
        
    }];
}

- (void)saveServerData:(NSArray *)data {
    NSArray *arr = [MSJsonKit jsonObjToObj:data asClass:[NSArray class] WithKeyClass:@{@"msroot": [YDOpenHardwarePedometer class]}];
    [self savePullRes:arr];
}

#pragma mark --preference
- (NSNumber *)pref_pedometerLastUpdateTs {
    NSNumber *ts = [self.preference objectForKey:kPedometerLastUpdateTs];
    ts = ts ? ts : @0;
    return ts;
}
- (void)pref_setPedometerLastUpdateTs:(NSNumber *)ts {
    [self.preference setObject:ts forKey:kPedometerLastUpdateTs];
}

#pragma mark --userId
- (NSNumber *)userId {
    return [[YDOpenHardwareKit shared] userId];
}



@end
