//
//  YDOpenHardwareSDKDefine.h
//  YDOpenHardwareSDK
//
//  Created by 张旻可 on 16/2/3.
//  Copyright © 2016年 YD. All rights reserved.
//

#ifndef YDOpenHardwareDefine_h
#define YDOpenHardwareDefine_h

#pragma once

#define YD_UNAVAILABLE(x) __attribute__((unavailable(x)))

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#endif /* YDOpenHardwareDefine_h */
