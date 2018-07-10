//
//  CLNetReachability.m
//  CoreLib
//
//  Created by apple pro on 2016/11/18.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import "CLNetReachability.h"
#import <UIKit/UIKit.h>
//----------------------------------------------------------

NSString *const NT_NetReachabilityChangedNotification = @"NetReachabilityChangedNotification";

//----------------------------------------------------------

@interface CLNetReachability ()
@property(nonatomic,strong,readonly) Reachability *reachability ;
@end

@implementation CLNetReachability
{
    BOOL   _isNotifier;
}

@synthesize reachability = _reachability;

+(CLNetReachability*)shareNetReachability
{
    static CLNetReachability * shareNetReachability = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareNetReachability = [[super allocWithZone:nil] init];
    });

    return shareNetReachability;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark-
- (Reachability *)reachability
{
    if (!_reachability) {

        _reachability = [Reachability reachabilityForInternetConnection];

        //开始通知
        [_reachability startNotifier];

        //观察通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_netReachabilityStatusChangeNotification:)
                                                     name:kReachabilityChangedNotification
                                                   object:_reachability];
    }

    return _reachability;
}

- (void)_netReachabilityStatusChangeNotification:(NSNotification *)notification
{
    if ([NSThread isMainThread]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NT_NetReachabilityChangedNotification
                                                            object:nil];
    }else {
        [self performSelectorOnMainThread:@selector(_netReachabilityStatusChangeNotification:)
                               withObject:notification
                            waitUntilDone:NO];
    }
}

#pragma mark-
+ (NetworkStatus)currentNetReachabilityStatus {
    return [[self shareNetReachability].reachability currentReachabilityStatus];
}

#pragma mark-
+(int)getSignalStrength
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSString *dataNetworkItemView = nil;

    for (id subview in subviews) {
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
            dataNetworkItemView = subview;
            break;
        }
    }

    int signalStrength = [[dataNetworkItemView valueForKey:@"_wifiStrengthBars"] intValue];

    return signalStrength ;
}
@end
