//
//  SH_TimeZoneManager.m
//  GameBox
//
//  Created by shin on 2018/7/29.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_TimeZoneManager.h"

@implementation SH_TimeZoneManager

+ (instancetype)sharedManager
{
    static SH_TimeZoneManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[SH_TimeZoneManager alloc] init];
        }
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.timeZone = @"GMT+08:00";
    }
    return self;
}

- (void)setTimeZone:(NSString *)timeZone
{
    _timeZone = [timeZone stringByReplacingOccurrencesOfString:@":" withString:@""];
}

- (NSString *)timeStringFrom:(NSTimeInterval)time format:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:self.timeZone]];
    [formatter setDateFormat:format];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSString *timeString = [formatter stringFromDate:date];
    return timeString;
}

@end
