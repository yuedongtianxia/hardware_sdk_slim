/**
 *  MSObjcQuickDT-Objc快速开发工具
 *  version 1.0 内测版
 *  张旻可(Minster)倾情打造
 *
 *  copyright © All Rights Reserved.
 */

#import <Foundation/Foundation.h>


/**
 *  对应数据表：yd_open_hardware_db.open_hardware_heart_rate
 */
@interface YDOpenHardwareHeartRate : NSObject 

@property (nonatomic, strong) NSNumber *ohhId;//对应数据库字段：ohh_id
@property (nonatomic, strong) NSString *deviceId;//对应数据库字段：device_id
@property (nonatomic, strong) NSNumber *heartRate;//对应数据库字段：heart_rate
@property (nonatomic, strong) NSDate *startTime;//对应数据库字段：start_time
@property (nonatomic, strong) NSDate *endTime;//对应数据库字段：end_time
@property (nonatomic, strong) NSNumber *userId;//对应数据库字段：user_id
@property (nonatomic, strong) NSString *extra;//对应数据库字段：extra
@property (nonatomic, strong) NSNumber *serverId;//对应数据库字段：server_id
@property (nonatomic, strong) NSNumber *status;//对应数据库字段：status


/**
 *  建立OpenHardwareHeartRate
 *
 *  @param ohh_id	对应属性：ohhId
 *  @param device_id	对应属性：deviceId
 *  @param heart_rate	对应属性：heartRate
 *  @param start_time	对应属性：startTime
 *  @param end_time	对应属性：endTime
 *  @param user_id	对应属性：userId
 *  @param extra_	对应属性：extra
 *  @param server_id	对应属性：serverId
 *  @param status_	对应属性：status
 */
- (void)constructByOhhId: (NSNumber *)ohh_id DeviceId: (NSString *)device_id HeartRate: (NSNumber *)heart_rate StartTime: (NSDate *)start_time EndTime: (NSDate *)end_time UserId: (NSNumber *)user_id Extra: (NSString *)extra_ ServerId: (NSNumber *)server_id Status: (NSNumber *)status_;

- (void)constructByModel: (id)model;

@end
