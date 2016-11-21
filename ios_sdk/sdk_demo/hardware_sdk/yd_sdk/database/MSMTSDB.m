//
//  MSMTSDB.m
//  SportsInternational
//
//  Created by 张旻可 on 15/11/4.
//  Copyright © 2015年 yuedong. All rights reserved.
//

#import "MSMTSDB.h"

#if FMDB_SQLITE_STANDALONE
#import <sqlite3/sqlite3.h>
#else
#import <sqlite3.h>
#endif

@implementation MSMTSDB

/**
 *  根据数据库路径和identifier初始化MSDB
 *
 *  @param path	数据库路径
 *  @param identifier	数据库identifier
 *
 *  @return MSDB对象
 */
-(instancetype)initWithPath:(NSString *)path identifier:(NSString *)identifier {
    self = [super init];
    if (self) {
        _dbPath = [path copy];
        _dbIdentifier = identifier;
    }
    return self;
}

/**
 *  初始化数据库
 *
 *  @param db	数据库对象
 */
-(void)initDb:(YDFMDatabase *)db {
}

/**
 *  打开数据库连接，如果需要并做一些数据库更新操作
 */
-(BOOL)open {
    if(_dbqMain && _dbqRead) { // && _dbqWrite
        return YES;
    }
    
    if (!_dbqMain) {
        _dbqMain = [[MSDatabaseQueue alloc] initWithPath: _dbPath flags: SQLITE_OPEN_FILEPROTECTION_NONE | SQLITE_OPEN_CREATE | SQLITE_OPEN_READWRITE | SQLITE_OPEN_WAL];
        if (!_dbqMain) {
            return NO;
        }
    }
    if (!_dbqRead) {
        _dbqRead = [[MSDatabaseQueue alloc] initWithPath: _dbPath flags: SQLITE_OPEN_READONLY | SQLITE_OPEN_FILEPROTECTION_NONE | SQLITE_OPEN_WAL];
        if (!_dbqRead) {
            return NO;
        }
    }
    //    if (!_dbqWrite) {
    //        _dbqWrite = [[YDFMDatabaseQueue alloc] initWithPath: _dbPath];
    //        if (!_dbqWrite) {
    //            return NO;
    //        }
    //    }
    
    
    NSUInteger oldVersion = [[NSUserDefaults standardUserDefaults] integerForKey: [self dbIdentifier]];
    if (oldVersion < [self versionCode]) {
        __block BOOL flag = NO;
        [_dbqMain inAsyncDatabase:^(YDFMDatabase *db) {
            flag = [self upgradeDb: db fromVersion: oldVersion toNewVersion: [self versionCode]];
        } completHandler:^{
            if (flag) {
                self.updated = YES;
                [[NSUserDefaults standardUserDefaults] setInteger:[self versionCode] forKey:[self dbIdentifier]];
            }
        }];
        
    } else {
        self.updated = YES;
    }
    
    [_dbqMain inDatabase:^(YDFMDatabase *db) {
        if (!self.inited) {
            [self initDb: db];
            self.inited = YES;
        }
        
    }];
    
    
    return YES;
}

/**
 *  清空对象引用
 */
- (void)dealloc {
    if (_dbqMain) {
        [_dbqMain close];
        _dbqMain = nil;
    }
    if (_dbqRead) {
        [_dbqRead close];
        _dbqRead = nil;
    }
    //    if (_dbqWrite) {
    //        [_dbqWrite close];
    //        _dbqWrite = nil;
    //    }
    _dbPath = nil;
    _dbIdentifier = nil;
}

/**
 *  如果数据库版本变化会调用该方法
 *
 *  @param db	数据库对象
 *  @param oldVersion	数据库老版本号
 *  @param newVersion	数据库新版本号
 */
-(BOOL)upgradeDb:(YDFMDatabase *)db fromVersion:(NSUInteger)oldVersion toNewVersion:(NSUInteger)newVersion {
    return YES;
}

/**
 *  如果数据库版本变化会调用该方法
 *
 *  @param dbq	数据库对象q
 *  @param oldVersion	数据库老版本号
 *  @param newVersion	数据库新版本号
 */
-(BOOL)upgradeDbQ:(YDFMDatabaseQueue *)dbq fromVersion:(NSUInteger)oldVersion toNewVersion:(NSUInteger)newVersion {
    return YES;
}

/**
 *  数据库当前版本号
 */
-(NSUInteger)versionCode {
    return 0;
}

- (void)inSyncMainDatabase: (void (^)(YDFMDatabase *db))block {
    [_dbqMain inDatabase: block];
}
- (void)inSyncMainTransaction: (void (^)(YDFMDatabase *db, BOOL *rollback))block {
    [_dbqMain inTransaction: block];
}
- (void)inSyncMainDeferredTransaction: (void (^)(YDFMDatabase *db, BOOL *rollback))block {
    [_dbqMain inDeferredTransaction: block];
}
- (void)inSyncReadDatabase: (void (^)(YDFMDatabase *db))block {
    if (!self.inited) {
        [_dbqMain inDatabase: block];
    } else {
        [_dbqRead inDatabase: block];
    }
}
- (void)inSyncReadTransaction: (void (^)(YDFMDatabase *db, BOOL *rollback))block {
    if (!self.inited) {
        [_dbqMain inTransaction: block];
    } else {
        [_dbqRead inTransaction: block];
    }
}
- (void)inSyncReadDeferredTransaction: (void (^)(YDFMDatabase *db, BOOL *rollback))block {
    if (!self.inited) {
        [_dbqMain inDeferredTransaction: block];
    } else {
        [_dbqRead inDeferredTransaction: block];
    }
}

- (void)inAsyncMainDatabase: (void (^)(YDFMDatabase *db))block {
    [_dbqMain inAsyncDatabase: block];
}
- (void)inAsyncMainTransaction: (void (^)(YDFMDatabase *db, BOOL *rollback))block {
    [_dbqMain inAsyncTransaction: block];
}
- (void)inAsyncMainDeferredTransaction: (void (^)(YDFMDatabase *db, BOOL *rollback))block {
    [_dbqMain inAsyncDeferredTransaction: block];
}
- (void)inAsyncReadDatabase: (void (^)(YDFMDatabase *db))block {
    if (!self.inited) {
        [_dbqMain inAsyncDatabase: block];
    } else {
        [_dbqRead inAsyncDatabase: block];
    }
}
- (void)inAsyncReadTransaction: (void (^)(YDFMDatabase *db, BOOL *rollback))block {
    if (!self.inited) {
        [_dbqMain inAsyncTransaction: block];
    } else {
        [_dbqRead inAsyncTransaction: block];
    }
}
- (void)inAsyncReadDeferredTransaction: (void (^)(YDFMDatabase *db, BOOL *rollback))block {
    if (!self.inited) {
        [_dbqMain inAsyncDeferredTransaction: block];
    } else {
        [_dbqRead inAsyncDeferredTransaction: block];
    }
}
- (void)inAsyncMainDatabase: (void (^)(YDFMDatabase *db))block completHandler: (void (^)())complet_handler {
    [_dbqMain inAsyncDatabase: block completHandler: complet_handler];
}
- (void)inAsyncMainTransaction: (void (^)(YDFMDatabase *db, BOOL *rollback))block completHandler: (void (^)())complet_handler {
    [_dbqMain inAsyncTransaction: block completHandler: complet_handler];
}
- (void)inAsyncMainDeferredTransaction: (void (^)(YDFMDatabase *db, BOOL *rollback))block completHandler: (void (^)())complet_handler {
    [_dbqMain inAsyncDeferredTransaction: block completHandler: complet_handler];
}
- (void)inAsyncReadDatabase: (void (^)(YDFMDatabase *db))block completHandler: (void (^)())complet_handler {
    if (!self.inited) {
        [_dbqMain inAsyncDatabase: block completHandler: complet_handler];
    } else {
        [_dbqRead inAsyncDatabase: block completHandler: complet_handler];
    }
}
- (void)inAsyncReadTransaction: (void (^)(YDFMDatabase *db, BOOL *rollback))block completHandler: (void (^)())complet_handler {
    if (!self.inited) {
        [_dbqMain inAsyncTransaction: block completHandler: complet_handler];
    } else {
        [_dbqRead inAsyncTransaction: block completHandler: complet_handler];
    }
}
- (void)inAsyncReadDeferredTransaction: (void (^)(YDFMDatabase *db, BOOL *rollback))block completHandler: (void (^)())complet_handler {
    if (!self.inited) {
        [_dbqMain inAsyncDeferredTransaction: block completHandler: complet_handler];
    } else {
        [_dbqRead inAsyncDeferredTransaction: block completHandler: complet_handler];
    }
}
//- (void)inWriteDatabase: (void (^)(YDFMDatabase *db))block {
//    if (!self.inited || !self.updated) {
//        [_dbqMain inDatabase: block];
//    } else {
//        [_dbqWrite inDatabase: block];
//    }
//}
//- (void)inWriteTransaction: (void (^)(YDFMDatabase *db, BOOL *rollback))block {
//    if (!self.inited || !self.updated) {
//        [_dbqMain inTransaction: block];
//    } else {
//        [_dbqWrite inTransaction: block];
//    }
//}
//- (void)inWriteDeferredTransaction: (void (^)(YDFMDatabase *db, BOOL *rollback))block {
//    if (!self.inited || !self.updated) {
//        [_dbqMain inDeferredTransaction: block];
//    } else {
//        [_dbqWrite inDeferredTransaction: block];
//    }
//}

/**
 *  日期转timestamp
 *
 *  @param date 日期
 *
 *  @return timestamp （NSNumber）
 */
+ (NSNumber *)dateToTimestamp: (NSDate *)date {
    return [NSNumber numberWithDouble: ([date timeIntervalSince1970] * 1000)];
}

/**
 *  timestamp转日期
 *
 *  @param timestamp NSNumber
 *
 *  @return 日期
 */
+ (NSDate *)timestampToDate: (NSNumber *)timestamp {
    return [NSDate dateWithTimeIntervalSince1970: ([timestamp doubleValue] / 1000)];
}

/**
 *  bool转number
 *
 *  @param flag bool
 *
 *  @return number
 */
+ (NSNumber *)boolToNumber: (BOOL)flag {
    return flag ? [NSNumber numberWithInt: 1] : [NSNumber numberWithInt: 0];
}
/**
 *  number转bool
 *
 *  @param number NSNumber
 *
 *  @return bool
 */
+ (BOOL)numberToBool: (NSNumber *)number {
    return number.intValue > 0 ? YES : NO;
}




@end
