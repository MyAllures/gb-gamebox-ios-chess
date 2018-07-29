//
//  SH_TimeZoneManager.h
//  GameBox
//
//  Created by shin on 2018/7/29.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SH_TimeZoneManager : NSObject

+ (instancetype)sharedManager;

/**
 将时间戳转换为格式时间

 @param time iOS支持时的间戳 外部传入需/1000.0
 @param format 格式 比如yyyy-MM-dd
 @return 格式时间
 */
- (NSString *)timeStringFrom:(NSTimeInterval)time format:(NSString *)format;

@property (nonatomic, strong) NSString *timeZone;

@end
