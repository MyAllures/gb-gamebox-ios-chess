//
//  IPsCacheManager.h
//  gameBoxEx
//
//  Created by shin on 2018/6/15.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPsCacheManager : NSObject

+ (instancetype)sharedManager;

//缓存的IP是否还有效
- (BOOL)isIPsValid;

//获取ip列表和域名
- (NSDictionary *)ips;

//更新ip列表和域名
- (void)updateIPsList:(NSDictionary *)ips;

//清空缓存
- (void)clearCaches;

@end
