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

- (void)configCookieAndSid:(NSHTTPURLResponse *)httpURLResponse
{
    NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:httpURLResponse.allHeaderFields forURL:[NSURL URLWithString:httpURLResponse.URL.absoluteString]];
    for(NSHTTPCookie *cookie in cookies)
    {
        if ([cookie.name isEqualToString:@"SID"] && cookie.value.length > 20) {
            //获取到正确的Cookie和SID
            self.currentCookie = [NSString stringWithFormat:@"SID=%@; Path=/; HttpOnly",cookie.value];
            self.currentSID = cookie.value;
            break;
        }
    }
}

@end
