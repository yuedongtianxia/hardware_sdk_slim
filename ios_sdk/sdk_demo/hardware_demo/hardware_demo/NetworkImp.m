//
//  NetworkImp.m
//  hardware_demo
//
//  Created by 张旻可 on 2016/11/21.
//  Copyright © 2016年 yuedong. All rights reserved.
//

#import "NetworkImp.h"

#import <YDHardwareSDK/YDHardwareSDK.h>
#import "AFNetworking.h"

@interface NetworkImp () 

@end

@implementation NetworkImp

+ (instancetype)shared {
    static NetworkImp *imp;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!imp) {
            imp = [[NetworkImp alloc] init];
        }
    });
    return imp;
}

/**
 post form 请求
 
 @param url 请求url
 @param param 参数字典
 @param then 请求完成回调，responseObject 为返回字典， error 为错误
 */
- (void)postForm:(NSString *)url
           param:(NSDictionary *)param
            then:(void (^)(id responseObject,  NSError *error))then {
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    [manager POST:url parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        !then?:then(responseObject, nil);
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        !then?:then(nil, error);
    }];
}

@end
