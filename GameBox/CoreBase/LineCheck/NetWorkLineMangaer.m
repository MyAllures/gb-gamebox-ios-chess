//
//  NetWorkLineMangaer.m
//  GameBox
//
//  Created by shin on 2018/7/4.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "NetWorkLineMangaer.h"

@implementation NetWorkLineMangaer

+ (instancetype)sharedManager
{
    static NetWorkLineMangaer *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[NetWorkLineMangaer alloc] init];
        }
    });
    return manager;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.currentIP = @"";
        self.currentHttpType = @"";
        self.currentPort = @"";
        self.currentPreUrl = @"";
        self.currentHost = @"";
        self.currentCookie = @"";
        self.currentSID = @"";
    }
    return self;
}

- (void)setCurrentCookie:(NSString *)currentCookie
{
    _currentCookie = currentCookie;
    if (_currentCookie) {
        NSArray *setCookieComp = [_currentCookie componentsSeparatedByString:@";"];
        NSString *sid = [setCookieComp[0] stringByReplacingOccurrencesOfString:@"SID=" withString:@""];
        self.currentSID = sid;
    }
}

@end
