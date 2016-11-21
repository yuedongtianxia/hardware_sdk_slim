//
//  ViewController.m
//  hardware_demo
//
//  Created by 张旻可 on 2016/10/31.
//  Copyright © 2016年 yuedong. All rights reserved.
//

#import "ViewController.h"
#import <YDHardwareSDK/YDHardwareSDK.h>

@interface ViewController ()
- (IBAction)toAuth:(id)sender;
- (IBAction)toUnAuth:(id)sender;
- (IBAction)toInsertRecord:(id)sender;
- (IBAction)toSyncRecord:(id)sender;
- (IBAction)toCheckAuthStatus:(id)sender;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)toAuth:(id)sender {
    
    [[YDOpenHardwareKit shared] tryAuth:^(YDOpenHardwareSDKCode code){
        NSLog(@"auth: code: %@", @(code));
    }];
}

- (IBAction)toUnAuth:(id)sender {
    NSLog(@"unAuth: %@", @([[YDOpenHardwareKit shared] unAuth]));
}

- (IBAction)toInsertRecord:(id)sender {
    YDOpenHardwareIntelligentScale *is = [[YDOpenHardwareIntelligentScale alloc] init];
    [is constructByOhiId: nil DeviceId: @"133-test-test" TimeSec: [NSDate date] WeightG: @60000 HeightCm: @170 BodyFatPer: @0 BodyMusclePer: @0 BodyMassIndex: @0 BasalMetabolismRate: @0 BodyWaterPercentage: @0 UserId: nil Extra: @"" ServerId:@(-1) Status:@(0)];
    [[YDOpenHardwareKit dataProvider] insertIntelligentScale:is completion:^(BOOL success) {
        
    }];
    YDOpenHardwareHeartRate *hr = [[YDOpenHardwareHeartRate alloc] init];
    [hr constructByOhhId: nil DeviceId: @"133-test-test" HeartRate: @100 StartTime: [NSDate date] EndTime: [NSDate date] UserId: nil Extra: @"" ServerId:@(-1) Status:@(0)];
    [[YDOpenHardwareKit dataProvider] insertHeartRate: hr completion:^(BOOL success) {
        
    }];
    YDOpenHardwarePedometer *pedo = [[YDOpenHardwarePedometer alloc] init];
    [pedo constructByOhpId: nil DeviceId: @"133-test-test" NumberOfStep: @100 Distance:@90 Calorie: @100 StartTime: [NSDate date] EndTime: [NSDate date] UserId: nil Extra: @"" ServerId: @(-1) Status: @0];
    [[YDOpenHardwareKit dataProvider] insertPedometer:pedo completion:^(BOOL success) {
        
    }];
}

- (IBAction)toSyncRecord:(id)sender {
    [[YDOpenHardwareKit shared] trySync];
}

- (IBAction)toCheckAuthStatus:(id)sender {
    NSLog(@"status: %@", @([[YDOpenHardwareKit shared] SDKStatus]));
}
@end
