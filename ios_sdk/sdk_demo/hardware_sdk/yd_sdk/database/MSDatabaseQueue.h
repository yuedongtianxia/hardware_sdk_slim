//
//  MSDatabaseQueue.h
//  SportsBar
//
//  Created by 张旻可 on 16/2/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YDFMDatabase.h"
#import "YDFMDatabaseQueue.h"

@interface MSDatabaseQueue : YDFMDatabaseQueue

/** Synchronously perform database operations on queue.
 
 @param block The code to be run on the queue of `YDFMDatabaseQueue`
 */

- (void)inAsyncDatabase:(void (^)(YDFMDatabase *db))block;

/** Synchronously perform database operations on queue, using transactions.
 
 @param block The code to be run on the queue of `YDFMDatabaseQueue`
 */

- (void)inAsyncTransaction:(void (^)(YDFMDatabase *db, BOOL *rollback))block;

/** Synchronously perform database operations on queue, using deferred transactions.
 
 @param block The code to be run on the queue of `YDFMDatabaseQueue`
 */

- (void)inAsyncDeferredTransaction:(void (^)(YDFMDatabase *db, BOOL *rollback))block;


//Minster add
- (void)inAsyncDatabase:(void (^)(YDFMDatabase *db))block completHandler: (void (^)())complet_handler;

/** Synchronously perform database operations on queue, using transactions.
 
 @param block The code to be run on the queue of `YDFMDatabaseQueue`
 */

- (void)inAsyncTransaction:(void (^)(YDFMDatabase *db, BOOL *rollback))block completHandler: (void (^)())complet_handler;

/** Synchronously perform database operations on queue, using deferred transactions.
 
 @param block The code to be run on the queue of `YDFMDatabaseQueue`
 */

- (void)inAsyncDeferredTransaction:(void (^)(YDFMDatabase *db, BOOL *rollback))block completHandler: (void (^)())complet_handler;

@end
