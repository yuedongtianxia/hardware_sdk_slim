//
//  AppDelegate.m
//  hardware_demo
//
//  Created by 张旻可 on 2016/10/31.
//  Copyright © 2016年 yuedong. All rights reserved.
//

#import "AppDelegate.h"
#import <YDHardwareSDK/YDHardwareSDK.h>
#import "NetworkImp.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [YDOpenHardwareKit shared].appKey = @"10016";
    [YDOpenHardwareKit shared].networkDelegate = [NetworkImp shared];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return NO;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation {
    if ([url.scheme isEqualToString:@"yd-open-api-10016"]) {
        return [[YDOpenHardwareKit shared] handleUrl:url application:application];
    }
    return NO;
}


//#if UIKIT_STRING_ENUMS
//typedef NSString * UIApplicationOpenURLOptionsKey NS_EXTENSIBLE_STRING_ENUM;
//#else
//typedef NSString * UIApplicationOpenURLOptionsKey;
//#endif

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    if ([url.scheme isEqualToString:@"yd-open-api-10016"]) {
        return [[YDOpenHardwareKit shared] handleUrl:url application:app];
    }
    return NO;
}


@end
