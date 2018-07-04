//
//  IPsCacheManager.m
//  gameBoxEx
//
//  Created by shin on 2018/6/15.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "IPsCacheManager.h"
#import "NetWorkLineMangaer.h"

#define GB_IPS_VALID_CACHE_TIME 1*24*60*60 //有效期一天

@implementation IPsCacheManager

+ (instancetype)sharedManager
{
    static IPsCacheManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[IPsCacheManager alloc] init];
        }
    });
    return manager;
}

- (BOOL)isIPsValid
{
    NSDictionary *ips = [self ips];
    if (ips != nil) {
        NSTimeInterval cachingTime = [[ips objectForKey:@"cachingTime"] doubleValue];
        NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
        
        NSString *code = [ips objectForKey:@"code"];
        if ([code isEqualToString:CODE] && currentTime-cachingTime <= GB_IPS_VALID_CACHE_TIME) {
            //依然有效
            return YES;
        }
        else
        {
            //过期了
            return NO;
        }
    }
    
    //没有值 所以默认无效
    return NO;
}

- (NSDictionary *)ips
{
    NSDictionary *ipsCacheDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"GB_IPS_CACHE_DATA"];
    return ipsCacheDic;
}

- (void)updateIPsList:(NSDictionary *)ips
{
    if (ips != nil) {
        //记录当前时间戳
        NSTimeInterval cachingTime =  [[NSDate date] timeIntervalSince1970];
        NSDictionary *ipsCacheDic = @{
                                      @"ips":ips,
                                      @"cachingTime":@(cachingTime),
                                      @"code":CODE
                                      };
        [[NSUserDefaults standardUserDefaults] setObject:ipsCacheDic forKey:@"GB_IPS_CACHE_DATA"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)clearCaches
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"GB_IPS_CACHE_DATA"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
