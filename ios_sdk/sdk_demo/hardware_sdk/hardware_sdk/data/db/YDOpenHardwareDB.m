/**
 *  MSObjcQuickDT-Objc快速开发工具
 *  version 1.0 内测版
 *  张旻可(Minster)倾情打造
 *
 *  copyright © All Rights Reserved.
 */

#import "YDOpenHardwareDB.h"

#import "YDOpenHardwareHeartRateDBDAO.h"
#import "YDOpenHardwarePedometerDBDAO.h"
#import "YDOpenHardwareSleepDBDAO.h"
#import "YDOpenHardwareIntelligentScaleDBDAO.h"

//#import "YDConstant.h"

static YDOpenHardwareDB *sYDOpenHardwareDB;

static NSString *const sYDHardwareDBName = @"yd_hardware_db.db";
static NSString *const sYDHardwareDBDir = @"yd_hardware_db";
static NSString *const sYDHardwareDBIdentifier = @"yd_hardware_db_id";

@implementation YDOpenHardwareDB

/**
 *  初始化数据库
 *
 *  @param db	数据库对象
 */
-(void)initDb: (YDFMDatabase *)db {
	[super initDb: db];
	[YDOpenHardwareHeartRateDBDAO createTable: db];
	[YDOpenHardwarePedometerDBDAO createTable: db];
	[YDOpenHardwareSleepDBDAO createTable: db];
    [YDOpenHardwareIntelligentScaleDBDAO createTable: db];
}

+ (YDOpenHardwareDB *)sharedDb {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sYDOpenHardwareDB == nil) {
            NSArray * arr = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
            NSString * path = [arr objectAtIndex: 0];
            path = [path stringByAppendingPathComponent:sYDHardwareDBDir];
            if (![[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil]) {
                [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
            }
            path = [path stringByAppendingPathComponent:sYDHardwareDBName];
            
            sYDOpenHardwareDB = [[YDOpenHardwareDB alloc] initWithPath:path identifier:sYDHardwareDBIdentifier];
            [sYDOpenHardwareDB open];
        }
    });
    return sYDOpenHardwareDB;
}

- (BOOL)upgradeDb:(YDFMDatabase *)db fromVersion:(NSUInteger)oldVersion toNewVersion:(NSUInteger)newVersion {
    return [super upgradeDb:db fromVersion:oldVersion toNewVersion:newVersion];
}

- (NSUInteger)versionCode {
    return 1;
}

@end
