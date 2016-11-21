//
//  YDOpenHardwareDP.m
//  YDOpenHardwareCore
//
//  Created by 张旻可 on 16/2/22.
//  Copyright © 2016年 YD. All rights reserved.
//

#import "YDOpenHardwareDP.h"

#import "YDOpenHardwareDB.h"
#import "YDOpenHardwareIntelligentScaleDBDAO.h"
#import "YDOpenHardwareHeartRateDBDAO.h"
#import "YDOpenHardwarePedometerDBDAO.h"
#import "YDOpenHardwareSleepDBDAO.h"

#import "YDOpenHardwareKit.h"


static YDOpenHardwareDP *sYDOpenHardwareDP = nil;

@implementation YDOpenHardwareDP

+ (instancetype)sharedDP {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sYDOpenHardwareDP == nil) {
            sYDOpenHardwareDP = [[YDOpenHardwareDP alloc] init];
        }
    });
    return sYDOpenHardwareDP;
}

#pragma mark 体重秤
/**
 *  插入新记录
 *
 *  @param is    数据
 *  @param block 回调，参数为是否成功
 */
- (void)insertIntelligentScale: (YDOpenHardwareIntelligentScale *)obj completion: (void(^)(BOOL success))block {
    obj.userId = [YDOpenHardwareKit shared].userId;
    
    if ([YDOpenHardwareKit shared].SDKStatus == YDOpenHardwareSDKStatusAuthed) {
        __block BOOL flag = NO;
        [[YDOpenHardwareDB sharedDb] inAsyncMainDatabase: ^(YDFMDatabase *db) {
            flag = [YDOpenHardwareIntelligentScaleDBDAO insertYDOpenHardwareIntelligentScale: obj intoDb: db];
        } completHandler: ^{
            !block?:block(flag);
        }];
    } else {
        !block?:block(NO);
    }
    
    
}

/**
 *  获取最新一条记录
 *
 *  @param device_identity 悦动圈提供的设备id
 *  @param user_id         用户id
 *  @param block 回调，参数为是否成功和数据
 */
- (void)selectNewIntelligentScaleByDeviceIdentity: (NSString *)device_identity userId: (NSNumber *)user_id completion: (void(^)(BOOL success, YDOpenHardwareIntelligentScale *is))block {
    __block BOOL flag = NO;
    __block YDOpenHardwareIntelligentScale *is_t = [[YDOpenHardwareIntelligentScale alloc] init];
    [[YDOpenHardwareDB sharedDb] inAsyncMainDatabase: ^(YDFMDatabase *db) {
        flag = [YDOpenHardwareIntelligentScaleDBDAO selectNewYDOpenHardwareIntelligentScale: is_t byDeviceIdentity: device_identity userId: user_id fromDb: db];
    } completHandler: ^{
        !block?:block(flag, is_t);
    }];
}


/**
 *  根据条件获取多条记录，
 *  为空的参数表示对该列没有约束，start和end必须同时存在，如果有time_sec就不会用start和end, start和end为前闭后开
 *
 *  @param device_identity 悦动圈提供的设备id
 *  @param time_sec        数据插入的时间
 *  @param user_id         用户id
 *  @param start           开始时间
 *  @param end             结束时间
 *  @param block           回调，参数为是否成功和数据
 */
- (void)selectIntelligentScaleByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end completion: (void(^)(BOOL success, NSArray<YDOpenHardwareIntelligentScale *> *))block {
    __block BOOL flag = NO;
    __block NSMutableArray *arr = nil;
    [[YDOpenHardwareDB sharedDb] inAsyncMainDatabase: ^(YDFMDatabase *db) {
        arr = [YDOpenHardwareIntelligentScaleDBDAO selectIntelligentScaleByDeviceIdentity: device_identity timeSec: time_sec userId: user_id betweenStart: start end: end fromDb: db];
        flag = YES;
    } completHandler: ^{
        !block?:block(flag, arr);
    }];
}

/**
 *  根据条件获取多条记录，
 *  为空的参数表示对该列没有约束，start和end必须同时存在，如果有time_sec就不会用start和end
 *
 *  @param device_identity 悦动圈提供的设备id
 *  @param time_sec        数据插入的时间
 *  @param user_id         用户id
 *  @param start           开始时间
 *  @param end             结束时间
 *  @param page_no         页码号(不能为空)
 *  @param page_size       页码大小(不能为空)
 *  @param block           回调，参数为是否成功和数据
 */
- (void)selectIntelligentScaleByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end pageNo: (NSNumber *)page_no pageSize: (NSNumber *)page_size completion: (void(^)(BOOL success, NSArray<YDOpenHardwareIntelligentScale *> *))block {
    __block BOOL flag = NO;
    __block NSMutableArray *arr = nil;
    [[YDOpenHardwareDB sharedDb] inAsyncMainDatabase: ^(YDFMDatabase *db) {
        arr = [YDOpenHardwareIntelligentScaleDBDAO selectIntelligentScaleByDeviceIdentity: device_identity timeSec: time_sec userId: user_id betweenStart: start end: end pageNo: page_no pageSize: page_size fromDb: db];
        flag = YES;
    } completHandler: ^{
        !block?:block(flag, arr);
    }];
}

/**
 *  插入新记录
 *
 *  @param obj    数据
 *  @param block 回调，参数为是否成功
 */
- (void)insertHeartRate: (YDOpenHardwareHeartRate *)obj completion: (void(^)(BOOL success))block {
    obj.userId = [YDOpenHardwareKit shared].userId;
    if ([YDOpenHardwareKit shared].SDKStatus == YDOpenHardwareSDKStatusAuthed) {
        __block BOOL flag = NO;
        [[YDOpenHardwareDB sharedDb] inAsyncMainDatabase: ^(YDFMDatabase *db) {
            flag = [YDOpenHardwareHeartRateDBDAO insertYDOpenHardwareHeartRate: obj intoDb: db];
        } completHandler: ^{
            !block?:block(flag);
        }];
    } else {
        !block?:block(NO);
    }
}

/**
 *  获取最新一条记录
 *
 *  @param device_identity 悦动圈提供的设备id
 *  @param user_id         用户id
 *  @param block 回调，参数为是否成功和数据
 */
- (void)selectNewHeartRateByDeviceIdentity: (NSString *)device_identity userId: (NSNumber *)user_id completion: (void(^)(BOOL success, YDOpenHardwareHeartRate *obj))block {
    __block BOOL flag = NO;
    __block YDOpenHardwareHeartRate *obj = [[YDOpenHardwareHeartRate alloc] init];
    [[YDOpenHardwareDB sharedDb] inAsyncMainDatabase: ^(YDFMDatabase *db) {
        flag = [YDOpenHardwareHeartRateDBDAO selectNewYDOpenHardwareHeartRate: obj byDeviceIdentity: device_identity userId: user_id fromDb: db];
    } completHandler: ^{
        !block?:block(flag, obj);
    }];
}

//根据条件获取多条记录
/**
 *  根据条件获取多条记录，
 *  为空的参数表示对该列没有约束，start和end必须同时存在，如果有time_sec就不会用start和end
 *
 *  @param device_identity 悦动圈提供的设备id
 *  @param time_sec        数据插入的时间
 *  @param user_id         用户id
 *  @param start           开始时间
 *  @param end             结束时间
 *  @param block           回调，参数为是否成功和数据
 */
- (void)selectHeartRateByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end completion: (void(^)(BOOL success, NSArray<YDOpenHardwareHeartRate *> *))block {
    __block BOOL flag = NO;
    __block NSMutableArray *arr = nil;
    [[YDOpenHardwareDB sharedDb] inAsyncMainDatabase: ^(YDFMDatabase *db) {
        arr = [YDOpenHardwareHeartRateDBDAO selectHeartRateByDeviceIdentity: device_identity timeSec: time_sec userId: user_id betweenStart: start end: end fromDb: db];
        flag = YES;
    } completHandler: ^{
        !block?:block(flag, arr);
    }];
}

/**
 *  根据条件获取多条记录，
 *  为空的参数表示对该列没有约束，start和end必须同时存在，如果有time_sec就不会用start和end
 *
 *  @param device_identity 悦动圈提供的设备id
 *  @param time_sec        数据插入的时间
 *  @param user_id         用户id
 *  @param start           开始时间
 *  @param end             结束时间
 *  @param page_no         页码号(不能为空)
 *  @param page_size       页码大小(不能为空)
 *  @param block           回调，参数为是否成功和数据
 */
- (void)selectHeartRateByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end pageNo: (NSNumber *)page_no pageSize: (NSNumber *)page_size completion: (void(^)(BOOL success, NSArray<YDOpenHardwareHeartRate *> *))block {
    __block BOOL flag = NO;
    __block NSMutableArray *arr = nil;
    [[YDOpenHardwareDB sharedDb] inAsyncMainDatabase: ^(YDFMDatabase *db) {
        arr = [YDOpenHardwareHeartRateDBDAO selectHeartRateByDeviceIdentity: device_identity timeSec: time_sec userId: user_id betweenStart: start end: end pageNo: page_no pageSize: page_size fromDb: db];
        flag = YES;
    } completHandler: ^{
        !block?:block(flag, arr);
    }];
}

#pragma mark 计步

/**
 *  插入新记录
 *
 *  @param obj    数据
 *  @param block 回调，参数为是否成功
 */
- (void)insertPedometer: (YDOpenHardwarePedometer *)obj completion: (void(^)(BOOL success))block {
    obj.userId = [YDOpenHardwareKit shared].userId;
    if ([YDOpenHardwareKit shared].SDKStatus == YDOpenHardwareSDKStatusAuthed) {
        __block BOOL flag = NO;
        [[YDOpenHardwareDB sharedDb] inAsyncMainDatabase: ^(YDFMDatabase *db) {
            flag = [YDOpenHardwarePedometerDBDAO insertYDOpenHardwarePedometer: obj intoDb: db];
        } completHandler: ^{
            !block?:block(flag);
        }];
    } else {
        !block?:block(NO);
    }
}

/**
 *  获取最新一条记录
 *
 *  @param device_identity 悦动圈提供的设备id
 *  @param user_id         用户id
 *  @param block 回调，参数为是否成功和数据
 */
- (void)selectNewPedometerByDeviceIdentity: (NSString *)device_identity userId: (NSNumber *)user_id completion: (void(^)(BOOL success, YDOpenHardwarePedometer *obj))block {
    __block BOOL flag = NO;
    __block YDOpenHardwarePedometer *obj = [[YDOpenHardwarePedometer alloc] init];
    [[YDOpenHardwareDB sharedDb] inAsyncMainDatabase: ^(YDFMDatabase *db) {
        flag = [YDOpenHardwarePedometerDBDAO selectNewYDOpenHardwarePedometer: obj byDeviceIdentity: device_identity userId: user_id fromDb: db];
    } completHandler: ^{
        !block?:block(flag, obj);
    }];
}

//根据条件获取多条记录
/**
 *  根据条件获取多条记录，
 *  为空的参数表示对该列没有约束，start和end必须同时存在，如果有time_sec就不会用start和end
 *
 *  @param device_identity 悦动圈提供的设备id
 *  @param time_sec        数据插入的时间
 *  @param user_id         用户id
 *  @param start           开始时间
 *  @param end             结束时间
 *  @param block           回调，参数为是否成功和数据
 */
- (void)selectPedometerByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end completion: (void(^)(BOOL success, NSArray<YDOpenHardwarePedometer *> *))block {
    __block BOOL flag = NO;
    __block NSMutableArray *arr = nil;
    [[YDOpenHardwareDB sharedDb] inAsyncMainDatabase: ^(YDFMDatabase *db) {
        arr = [YDOpenHardwarePedometerDBDAO selectPedometerByDeviceIdentity: device_identity timeSec: time_sec userId: user_id betweenStart: start end: end fromDb: db];
        flag = YES;
    } completHandler: ^{
        !block?:block(flag, arr);
    }];
}

/**
 *  根据条件获取多条记录，
 *  为空的参数表示对该列没有约束，start和end必须同时存在，如果有time_sec就不会用start和end
 *
 *  @param device_identity 悦动圈提供的设备id
 *  @param time_sec        数据插入的时间
 *  @param user_id         用户id
 *  @param start           开始时间
 *  @param end             结束时间
 *  @param page_no         页码号(不能为空)
 *  @param page_size       页码大小(不能为空)
 *  @param block           回调，参数为是否成功和数据
 */
- (void)selectPedometerByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end pageNo: (NSNumber *)page_no pageSize: (NSNumber *)page_size completion: (void(^)(BOOL success, NSArray<YDOpenHardwarePedometer *> *))block {
    __block BOOL flag = NO;
    __block NSMutableArray *arr = nil;
    [[YDOpenHardwareDB sharedDb] inAsyncMainDatabase: ^(YDFMDatabase *db) {
        arr = [YDOpenHardwarePedometerDBDAO selectPedometerByDeviceIdentity: device_identity timeSec: time_sec userId: user_id betweenStart: start end: end pageNo: page_no pageSize: page_size fromDb: db];
        flag = YES;
    } completHandler: ^{
        !block?:block(flag, arr);
    }];
}


#pragma mark 睡眠

/**
 *  插入新记录
 *
 *  @param obj    数据
 *  @param block 回调，参数为是否成功
 */
- (void)insertSleep: (YDOpenHardwareSleep *)obj completion: (void(^)(BOOL success))block {
    obj.userId = [YDOpenHardwareKit shared].userId;
    if ([YDOpenHardwareKit shared].SDKStatus == YDOpenHardwareSDKStatusAuthed) {
        __block BOOL flag = NO;
        [[YDOpenHardwareDB sharedDb] inAsyncMainDatabase: ^(YDFMDatabase *db) {
            flag = [YDOpenHardwareSleepDBDAO insertYDOpenHardwareSleep: obj intoDb: db];
        } completHandler: ^{
            !block?:block(flag);
        }];
    } else {
        !block?:block(NO);
    }
}

/**
 *  获取最新一条记录
 *
 *  @param device_identity 悦动圈提供的设备id
 *  @param user_id         用户id
 *  @param block 回调，参数为是否成功和数据
 */
- (void)selectNewSleepByDeviceIdentity: (NSString *)device_identity userId: (NSNumber *)user_id completion: (void(^)(BOOL success, YDOpenHardwareSleep *obj))block {
    __block BOOL flag = NO;
    __block YDOpenHardwareSleep *obj = [[YDOpenHardwareSleep alloc] init];
    [[YDOpenHardwareDB sharedDb] inAsyncMainDatabase: ^(YDFMDatabase *db) {
        flag = [YDOpenHardwareSleepDBDAO selectNewYDOpenHardwareSleep: obj byDeviceIdentity: device_identity userId: user_id fromDb: db];
    } completHandler: ^{
        !block?:block(flag, obj);
    }];
}

//根据条件获取多条记录
/**
 *  根据条件获取多条记录，
 *  为空的参数表示对该列没有约束，start和end必须同时存在，如果有time_sec就不会用start和end
 *
 *  @param device_identity 悦动圈提供的设备id
 *  @param time_sec        数据插入的时间
 *  @param user_id         用户id
 *  @param start           开始时间
 *  @param end             结束时间
 *  @param block           回调，参数为是否成功和数据
 */
- (void)selectSleepByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end completion: (void(^)(BOOL success, NSArray<YDOpenHardwareSleep *> *))block {
    __block BOOL flag = NO;
    __block NSMutableArray *arr = nil;
    [[YDOpenHardwareDB sharedDb] inAsyncMainDatabase: ^(YDFMDatabase *db) {
        arr = [YDOpenHardwareSleepDBDAO selectSleepByDeviceIdentity: device_identity timeSec: time_sec userId: user_id betweenStart: start end: end fromDb: db];
        flag = YES;
    } completHandler: ^{
        !block?:block(flag, arr);
    }];
}

/**
 *  根据条件获取多条记录，
 *  为空的参数表示对该列没有约束，start和end必须同时存在，如果有time_sec就不会用start和end
 *
 *  @param device_identity 悦动圈提供的设备id
 *  @param time_sec        数据插入的时间
 *  @param user_id         用户id
 *  @param start           开始时间
 *  @param end             结束时间
 *  @param page_no         页码号(不能为空)
 *  @param page_size       页码大小(不能为空)
 *  @param block           回调，参数为是否成功和数据
 */
- (void)selectSleepByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end pageNo: (NSNumber *)page_no pageSize: (NSNumber *)page_size completion: (void(^)(BOOL success, NSArray<YDOpenHardwareSleep *> *))block {
    __block BOOL flag = NO;
    __block NSMutableArray *arr = nil;
    [[YDOpenHardwareDB sharedDb] inAsyncMainDatabase: ^(YDFMDatabase *db) {
        arr = [YDOpenHardwareSleepDBDAO selectSleepByDeviceIdentity: device_identity timeSec: time_sec userId: user_id betweenStart: start end: end pageNo: page_no pageSize: page_size fromDb: db];
        flag = YES;
    } completHandler: ^{
        !block?:block(flag, arr);
    }];
}

@end
