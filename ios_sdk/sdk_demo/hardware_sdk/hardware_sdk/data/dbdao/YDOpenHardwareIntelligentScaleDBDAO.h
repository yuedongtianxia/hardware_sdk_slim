/**
 *  MSObjcQuickDT-Objc快速开发工具
 *  version 1.0 内测版
 *  张旻可(Minster)倾情打造
 *
 *  copyright © All Rights Reserved.
 */

#import <Foundation/Foundation.h>
#import "YDFMDatabase.h"
#import "YDOpenHardwareIntelligentScale.h"



/**
 *  对应数据表：yd_open_hardware_db.open_hardware_intelligent_scale
 */
@interface YDOpenHardwareIntelligentScaleDBDAO : NSObject

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
 *  @param open_hardware_intelligent_scale	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否插入成功
 */
+ (BOOL)insertYDOpenHardwareIntelligentScale: (YDOpenHardwareIntelligentScale *)open_hardware_intelligent_scale intoDb: (YDFMDatabase *)db;

/**
 *  根据主键获取一条数据
 *
 *  @param open_hardware_intelligent_scale	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否获取成功
 */
+ (BOOL)selectYDOpenHardwareIntelligentScaleByPk: (YDOpenHardwareIntelligentScale *)open_hardware_intelligent_scale fromDb: (YDFMDatabase *)db;

/**
 *  根据主键倒序获取最新一条数据
 *
 *  @param open_hardware_intelligent_scale	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否获取成功
 */
+ (BOOL)selectNewYDOpenHardwareIntelligentScale: (YDOpenHardwareIntelligentScale *)open_hardware_intelligent_scale fromDb: (YDFMDatabase *)db;

/**
 *  根据主键倒序获取最新一条数据
 *
 *  @param open_hardware_intelligent_scale	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否获取成功
 */
+ (BOOL)selectNewYDOpenHardwareIntelligentScale: (YDOpenHardwareIntelligentScale *)open_hardware_intelligent_scale byDeviceIdentity: (NSString *)device_identity userId: (NSNumber *)user_id fromDb: (YDFMDatabase *)db;

/**
 *  根据条件获取数据
 *
 *  @param device_identity device_identity
 *  @param time_sec time_sec
 *  @param user_id user_id
 *  @param start start
 *  @param end end
 *  @param db db
 *
 *  @return 数据
 */
+ (NSMutableArray<YDOpenHardwareIntelligentScale *> *)selectIntelligentScaleByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end fromDb: (YDFMDatabase *)db;

/**
 *  根据条件获取数据
 *
 *  @param device_identity device_identity
 *  @param time_sec time_sec
 *  @param user_id user_id
 *  @param start start
 *  @param end end
 *  @param db db
 *  @param page_no page_no
 *  @param page_size page_size
 *
 *  @return 数据
 */
+ (NSMutableArray<YDOpenHardwareIntelligentScale *> *)selectIntelligentScaleByDeviceIdentity: (NSString *)device_identity timeSec: (NSDate *)time_sec userId: (NSNumber *)user_id betweenStart: (NSDate *)start end: (NSDate *)end pageNo: (NSNumber *)page_no pageSize: (NSNumber *)page_size fromDb: (YDFMDatabase *)db;

+ (NSMutableArray<NSNumber *> *)selectServerIdsByStartServerId:(NSNumber *)serverId1 endServerId:(NSNumber *)serverId2 fromDb: (YDFMDatabase *)db;

+ (BOOL)updateStatusServerIdByPk:(NSNumber *)pk status:(NSNumber *)status serverId:(NSNumber *)serverId fromDb: (YDFMDatabase *)db;

/**
 *  根据主键更新一条数据
 *
 *  @param open_hardware_intelligent_scale	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否更新成功
 */
+ (BOOL)updateYDOpenHardwareIntelligentScaleByPk: (YDOpenHardwareIntelligentScale *)open_hardware_intelligent_scale ofDb: (YDFMDatabase *)db;

/**
 *  根据主键删除一条数据
 *
 *  @param open_hardware_intelligent_scale	数据对象
 *  @param db	数据库fmdb对象
 *
 *  @return 是否删除成功
 */
+ (BOOL)deleteYDOpenHardwareIntelligentScaleByPk: (YDOpenHardwareIntelligentScale *)open_hardware_intelligent_scale ofDb: (YDFMDatabase *)db;

/**
 *  获取所有数据
 *
 *  @param db	数据库fmdb对象
 *
 *  @return 数据对象数组
 */
+ (NSMutableArray *)selectAllYDOpenHardwareIntelligentScaleFromDb: (YDFMDatabase *)db;

/**
 *  获取所有数据行数
 *
 *  @param db	数据库fmdb对象
 *
 *  @return 行数
 */
+ (NSUInteger)countYDOpenHardwareIntelligentScaleFromDb: (YDFMDatabase *)db;

/**
 *  分页获取所有数据
 *
 *  @param page_no	页码
 *  @param page_size	页面大小
 *  @param db	数据库fmdb对象
 *
 *  @return 数据对象数组
 */
+ (NSMutableArray *)selectYDOpenHardwareIntelligentScalePageNo: (NSNumber *)page_no pageSize: (NSNumber *)page_size fromDb: (YDFMDatabase *)db;

/**
 *  根据deviceId获取数据
 *
 *  @param device_id	deviceId
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectYDOpenHardwareIntelligentScaleByDeviceId: (NSString *)device_id fromDb: (YDFMDatabase *)db;

/**
 *  根据timeSec获取数据
 *
 *  @param time_sec	timeSec
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectYDOpenHardwareIntelligentScaleByTimeSec: (NSDate *)time_sec fromDb: (YDFMDatabase *)db;

/**
 *  根据weightG获取数据
 *
 *  @param weight_g	weightG
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectYDOpenHardwareIntelligentScaleByWeightG: (NSNumber *)weight_g fromDb: (YDFMDatabase *)db;

/**
 *  根据heightCm获取数据
 *
 *  @param height_cm	heightCm
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectYDOpenHardwareIntelligentScaleByHeightCm: (NSNumber *)height_cm fromDb: (YDFMDatabase *)db;

/**
 *  根据bodyFatPer获取数据
 *
 *  @param body_fat_per	bodyFatPer
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectYDOpenHardwareIntelligentScaleByBodyFatPer: (NSNumber *)body_fat_per fromDb: (YDFMDatabase *)db;

/**
 *  根据bodyMusclePer获取数据
 *
 *  @param body_muscle_per	bodyMusclePer
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectYDOpenHardwareIntelligentScaleByBodyMusclePer: (NSNumber *)body_muscle_per fromDb: (YDFMDatabase *)db;

/**
 *  根据bodyMassIndex获取数据
 *
 *  @param body_mass_index	bodyMassIndex
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectYDOpenHardwareIntelligentScaleByBodyMassIndex: (NSNumber *)body_mass_index fromDb: (YDFMDatabase *)db;

/**
 *  根据basalMetabolismRate获取数据
 *
 *  @param basal_metabolism_rate	basalMetabolismRate
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectYDOpenHardwareIntelligentScaleByBasalMetabolismRate: (NSNumber *)basal_metabolism_rate fromDb: (YDFMDatabase *)db;

/**
 *  根据bodyWaterPercentage获取数据
 *
 *  @param body_water_percentage	bodyWaterPercentage
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectYDOpenHardwareIntelligentScaleByBodyWaterPercentage: (NSNumber *)body_water_percentage fromDb: (YDFMDatabase *)db;

/**
 *  根据userId获取数据
 *
 *  @param user_id	userId
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectYDOpenHardwareIntelligentScaleByUserId: (NSNumber *)user_id fromDb: (YDFMDatabase *)db;

/**
 *  根据extra获取数据
 *
 *  @param extra_	extra
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectYDOpenHardwareIntelligentScaleByExtra: (NSString *)extra_ fromDb: (YDFMDatabase *)db;

/**
 *  根据serverId获取数据
 *
 *  @param server_id	serverId
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectYDOpenHardwareIntelligentScaleByServerId: (NSNumber *)server_id fromDb: (YDFMDatabase *)db;

/**
 *  根据status获取数据
 *
 *  @param status_	status
 *  @param db	数据库fmdb对象
 *
 *  @return	数据数组
 */
+ (NSMutableArray *)selectYDOpenHardwareIntelligentScaleByStatus: (NSNumber *)status_ fromDb: (YDFMDatabase *)db;


@end
