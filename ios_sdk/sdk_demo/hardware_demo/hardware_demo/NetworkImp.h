//
//  NetworkImp.h
//  hardware_demo
//
//  Created by 张旻可 on 2016/11/21.
//  Copyright © 2016年 yuedong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YDHardwareSDK/YDHardwareSDK.h>

@interface NetworkImp : NSObject <YDNetworkDelegate>

+ (instancetype)shared;

@end
