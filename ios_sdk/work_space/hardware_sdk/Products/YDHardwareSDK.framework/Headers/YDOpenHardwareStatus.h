//
//  YDOpenHardwareStatus.h
//  SportsBar
//
//  Created by 张旻可 on 16/7/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#ifndef YDOpenHardwareStatus_h
#define YDOpenHardwareStatus_h

typedef NS_ENUM(NSInteger, YDOpenHardwareStatus) {
    YDOpenHardwareStatusWaitDelete = -1,
    YDOpenHardwareStatusWaitUpload = 0,
    YDOpenHardwareStatusSynced = 1,
    YDOpenHardwareStatusWaitMerge = 3
    
};


#endif /* YDOpenHardwareStatus_h */
