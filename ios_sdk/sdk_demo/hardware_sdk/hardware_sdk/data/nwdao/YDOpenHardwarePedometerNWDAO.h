//
//  OpenHardwareNWDAO.h
//  YDOpenHardwareCore
//
//  Created by 张旻可 on 16/7/25.
//  Copyright © 2016年 YD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDOpenHardwarePedometerNWDAO : NSObject

+ (instancetype)shared;

- (void)trySync;
- (void)tryPull;
- (void)tryPush;

- (void)saveServerData:(NSArray *)data;

@end
