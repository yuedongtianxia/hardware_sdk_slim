/**
 *  MSObjcQuickDT-Objc快速开发工具
 *  version 1.0 内测版
 *  张旻可(Minster)倾情打造
 *
 *  copyright © All Rights Reserved.
 */

#import <Foundation/Foundation.h>
#import "YDFMDatabase.h"
#import "YDOpenHardwareHeartRate.h"



/**
 *  对应数据表：yd_open_hardware_db.open_hardware_heart_rate
 */
@interface YDOpenHardwareHeartRateDBDAO : NSObject

/**
 *  创建表格
 *
 *  @param db	数据库fmdb对象
 *
 *  @return 是否创建成功
 */
+ (BOOL)createTable: (YDFMDatabase *)db;

/**
 *  插入一条数据
 *
 *  @param open_hardware_heart_rate	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否插入成功
 */
+ (BOOL)insertYDOpenHardwareHeartRate: (YDOpenHardwareHeartRate *)open_hardware_heart_rate intoDb: (YDFMDatabase *)db;

/**
 *  根据主键获取一条数据
 *
 *  @param open_hardware_heart_rate	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否获取成功
 */
+ (BOOL)selectYDOpenHardwareHeartRateByPk: (YDOpenHardwareHeartRate *)open_hardware_heart_rate fromDb: (YDFMDatabase *)db;

/**
 *  根据主键倒序获取最新一条数据
 *
 *  @param open_hardware_heart_rate	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否获取成功
 */
+ (BOOL)selectNewYDOpenHardwareHeartRate: (YDOpenHardwareHeartRate *)open_hardware_heart_rate fromDb: (YDFMDatabase *)db;

/**
 *  根据主键倒序获取最新一条数据
 *
 *  @param open_hardware_heart_rate	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否获取成功
 */
+ (BOOL)selectNewYDOpenHardwareHeartRate: (YDOpenHardwareHeartRate *)open_hardware_heart_rate byDeviceIdentity: (NSString *)device_identity userId: (NSNumber *)user_id fromDb: (YDFMDatabase *)db;

/**
 *  根据条件获取数据
 *
 *  @param device_identity
 *  @param time_sec
 *  @param user_id
 *  @param start
 *  @param end
 *  @param db
 *
 *  @return 数据
 */
+ (NSMutableArray<YDOpenHardwareHeartRate *> *)selectHeartRateByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end fromDb: (YDFMDatabase *)db;

/**
 *  根据条件获取数据
 *
 *  @param device_identity
 *  @param time_sec
 *  @param user_id
 *  @param start
 *  @param end
 *  @param db
 *  @param page_no
 *  @param page_size
 *
 *  @return 数据
 */
+ (NSMutableArray<YDOpenHardwareHeartRate *> *)selectHeartRateByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end pageNo: (NSNumber *)page_no pageSize: (NSNumber *)page_size fromDb: (YDFMDatabase *)db;

/**
 *  根据主键更新一条数据
 *
 *  @param open_hardware_heart_rate	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否更新成功
 */
+ (BOOL)updateYDOpenHardwareHeartRateByPk: (YDOpenHardwareHeartRate *)open_hardware_heart_rate ofDb: (YDFMDatabase *)db;

/**
 *  根据主键删除一条数据
 *
 *  @param open_hardware_heart_rate	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否删除成功
 */
+ (BOOL)deleteYDOpenHardwareHeartRateByPk: (YDOpenHardwareHeartRate *)open_hardware_heart_rate ofDb: (YDFMDatabase *)db;

/**
 *  获取所有数据
 *
 *  @param db	数据库fmdb对象
 *
 *  @return 数据对象数组
 */
+ (NSMutableArray *)selectAllYDOpenHardwareHeartRateFromDb: (YDFMDatabase *)db;

/**
 *  获取所有数据行数
 *
 *  @param db	数据库fmdb对象
 *
 *  @return 行数
 */
+ (NSUInteger)countYDOpenHardwareHeartRateFromDb: (YDFMDatabase *)db;

/**
 *  分页获取所有数据
 *
 *  @param page_no	页码
 *  @param page_size	页面大小
 *  @param db	数据库fmdb对象
 *
 *  @return 数据对象数组
 */
+ (NSMutableArray *)selectYDOpenHardwareHeartRatePageNo: (NSNumber *)page_no pageSize: (NSNumber *)page_size fromDb: (YDFMDatabase *)db;

/**
 *  根据deviceId获取数据
 *
 *  @param device_id	deviceId
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectYDOpenHardwareHeartRateByDeviceId: (NSString *)device_id fromDb: (YDFMDatabase *)db;

/**
 *  根据heartRate获取数据
 *
 *  @param heart_rate	heartRate
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectYDOpenHardwareHeartRateByHeartRate: (NSNumber *)heart_rate fromDb: (YDFMDatabase *)db;

/**
 *  根据startTime获取数据
 *
 *  @param start_time	startTime
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectYDOpenHardwareHeartRateByStartTime: (NSDate *)start_time fromDb: (YDFMDatabase *)db;

/**
 *  根据endTime获取数据
 *
 *  @param end_time	endTime
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectYDOpenHardwareHeartRateByEndTime: (NSDate *)end_time fromDb: (YDFMDatabase *)db;

/**
 *  根据userId获取数据
 *
 *  @param user_id	userId
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectYDOpenHardwareHeartRateByUserId: (NSNumber *)user_id fromDb: (YDFMDatabase *)db;

/**
 *  根据extra获取数据
 *
 *  @param extra_	extra
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectYDOpenHardwareHeartRateByExtra: (NSString *)extra_ fromDb: (YDFMDatabase *)db;

/**
 *  根据serverId获取数据
 *
 *  @param server_id	serverId
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectYDOpenHardwareHeartRateByServerId: (NSNumber *)server_id fromDb: (YDFMDatabase *)db;

/**
 *  根据status获取数据
 *
 *  @param status_	status
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectYDOpenHardwareHeartRateByStatus: (NSNumber *)status_ fromDb: (YDFMDatabase *)db;


@end
