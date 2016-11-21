//
//  OpenHardwareIntelligentScaleNWDAO.h
//  SportsBar
//
//  Created by 张旻可 on 16/7/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDOpenHardwareIntelligentScaleNWDAO : NSObject

+ (instancetype)shared;

- (void)trySync;
- (void)tryPull;
- (void)tryPush;

@end
