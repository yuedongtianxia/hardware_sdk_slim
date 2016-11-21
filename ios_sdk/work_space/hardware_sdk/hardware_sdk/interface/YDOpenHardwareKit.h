//
//  YDOpenHardwareKit.h
//  hardware_sdk
//
//  Created by 张旻可 on 2016/11/4.
//  Copyright © 2016年 yuedong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YDNetworkDelegate.h"
#import "YDOpenHardwareDP.h"

typedef NS_ENUM(NSInteger, YDOpenHardwareSDKStatus) {
    YDOpenHardwareSDKStatusUnAuth = 0, //未授权
    YDOpenHardwareSDKStatusAuthed, //已授权
    YDOpenHardwareSDKStatusAuthExpired, //授权已过期
};

typedef NS_ENUM(NSInteger, YDOpenHardwareSDKCode) {
    YDOpenHardwareSDKCodeSuccess = 0, //操作成功
    YDOpenHardwareSDKCodeVersionErrorOrNotInstalled = 1, //悦动圈版本不对或者没有安装
    YDOpenHardwareSDKCodeAppKeyInvalid = 404, //appkey非法
    YDOpenHardwareSDKCodeUnknowError = 909, //未知错误服务器或者网络异常
    YDOpenHardwareSDKCodeNoData = 1001, //没有数据可以同步
};


static NSString *const kYDNtfOpenHardwareSyncFinished = @"yd_ntf_open_hardware_sync_finished"; //数据同步完成通知 通知object是一个NSNumber 值对应YDOpenHardwareSDKCode

@interface YDOpenHardwareKit : NSObject

@property (nonatomic, copy) NSString *appKey;

@property (nonatomic, weak) id<YDNetworkDelegate> networkDelegate; //第三方实现网络请求方法供sdk调用（必须实现）

+ (instancetype)shared;


/**
 获取授权情况

 @return 授权情况
 */
- (YDOpenHardwareSDKStatus)SDKStatus;
/**
 尝试授权，如果安装了悦动圈，并且版本正确，就会调起悦动圈授权
 如果版本不正确，会返回版本不正确
 如果没有安装会跳转appstore
 */
/**
 尝试授权，如果安装了悦动圈，并且版本正确，就会调起悦动圈授权
 如果版本不正确，会返回版本不正确
 如果没有安装会跳转appstore

 @param then 回调
 */
- (void)tryAuth:(void(^)(YDOpenHardwareSDKCode code))then;

/**
 解除授权，如果悦动圈账号发生了改变，用户可能需要解除授权，重新授权
 */
- (BOOL)unAuth;

/**
 同步数据到服务器
 */
- (void)trySync;

/**
 处理openurl

 @param url open url
 @param application application
 @return 是否处理成功
 */
- (BOOL)handleUrl:(NSURL *)url application:(UIApplication *)application;

+ (YDOpenHardwareDP *)dataProvider;

- (NSNumber *)userId;
- (NSString *)accessToken;

@end
