//
//  MSDatabaseQueue.m
//  SportsBar
//
//  Created by 张旻可 on 16/2/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MSDatabaseQueue.h"

@implementation MSDatabaseQueue


- (void)inAsyncDatabase:(void (^)(YDFMDatabase *db))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self inDatabase: block];
    });
}

- (void)inAsyncTransaction:(void (^)(YDFMDatabase *db, BOOL *rollback))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self inTransaction: block];
    });
}

- (void)inAsyncDeferredTransaction:(void (^)(YDFMDatabase *db, BOOL *rollback))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self inTransaction: block];
    });
}

- (void)inAsyncDatabase:(void (^)(YDFMDatabase *db))block completHandler: (void (^)())complet_handler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self inDatabase: block];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complet_handler) {
                complet_handler();
            }
        });
    });
}

- (void)inAsyncTransaction:(void (^)(YDFMDatabase *db, BOOL *rollback))block completHandler: (void (^)())complet_handler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self inTransaction: block];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complet_handler) {
                complet_handler();
            }
        });
    });
}

- (void)inAsyncDeferredTransaction:(void (^)(YDFMDatabase *db, BOOL *rollback))block completHandler: (void (^)())complet_handler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self inDeferredTransaction: block];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complet_handler) {
                complet_handler();
            }
        });
    });
}
@end
