//
//  CLNetReachability.h
//  CoreLib
//
//  Created by apple pro on 2016/11/18.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"


//----------------------------------------------------------

extern NSString *const NT_NetReachabilityChangedNotification;

//----------------------------------------------------------

#pragma mark-网络状态相关宏定义

//当前网络状态
#define CurrentNetStatus()     [CLNetReachability currentNetReachabilityStatus]

//无网络
#define NetNotReachability()        (CurrentNetStatus() == NotReachable)

//网络可用
#define NetworkAvailable()          (CurrentNetStatus() != NotReachable)

//手机 网络
#define NetReachableViaWWAN()       (CurrentNetStatus() == ReachableViaWiFi)

//wifi 网络
#define NetReachableViaWiFi()       (CurrentNetStatus() == ReachableViaWiFi)

//当前网络强度
#define CurrentSignalStrength   [CLNetReachability getSignalStrength]

/**
 * 网络可达性监听
 */
@interface CLNetReachability : NSObject

/**
 * 返回当前网络状态
 */
+ (NetworkStatus)currentNetReachabilityStatus;

/**
 * 返回当前网络强度
 */
#pragma mark-
+(int)getSignalStrength ;
@end
