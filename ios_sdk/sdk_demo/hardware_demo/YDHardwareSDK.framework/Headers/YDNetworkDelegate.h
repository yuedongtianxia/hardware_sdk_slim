//
//  YDNetworkDelegate.h
//  hardware_sdk
//
//  Created by 张旻可 on 2016/11/4.
//  Copyright © 2016年 yuedong. All rights reserved.
//  必须实现该delegate
//

#import <Foundation/Foundation.h>

@protocol YDNetworkDelegate <NSObject>

@required

/**
 post form 请求
 
 @param url 请求url
 @param param 参数字典
 @param then 请求完成回调，responseObject 为返回字典， error 为错误
 */
- (void)postForm:(NSString *)url
           param:(NSDictionary *)param
            then:(void (^)(id responseObject,  NSError *error))then;

@optional

/**
 get form 请求

 @param url 请求url
 @param param 参数字典
 @param then 请求完成回调，responseObject 为返回字典， error 为错误
 */
- (void)getForm:(NSString *)url
          param:(NSDictionary *)param
           then:(void (^)(id responseObject, NSError *error))then;

/**
 get json 请求

 @param url 请求url
 @param param 参数字典
 @param then 请求完成回调，responseObject 为返回字典， error 为错误
 */
- (void)getJson:(NSString *)url
          param:(NSDictionary *)param
           then:(void (^)(id responseObject,  NSError *error))then;



/**
 post json 请求
 
 @param url 请求url
 @param param 参数字典
 @param then 请求完成回调，responseObject 为返回字典， error 为错误
 */
- (void)postJson:(NSString *)url
           param:(NSDictionary *)param
            then:(void (^)(id responseObject,  NSError *error))then;

@end
