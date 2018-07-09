//
//  SH_NetWorkService+Login.m
//  GameBox
//
//  Created by shin on 2018/7/4.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_NetWorkService+Login.h"
#import "NetWorkLineMangaer.h"

@implementation SH_NetWorkService (Login)

+ (void)fetchHttpCookie:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed
{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/origin/getHttpCookie.html"];
    NSDictionary *header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost};
    [self get:url parameter:nil header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}

+ (void)login:(NSString *)userName psw:(NSString *)psw verfyCode:(NSString *)verfyCode complete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed
{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/passport/login.html"];
    NSDictionary *parameter = verfyCode == nil || [verfyCode isEqualToString:@""] ? @{@"username":userName,@"password":psw} : @{@"username":userName,@"password":psw,@"captcha":verfyCode};
    NSDictionary *header = @{@"X-Requested-With":@"XMLHttpRequest",@"Host":[NetWorkLineMangaer sharedManager].currentHost,@"Cookie":[NetWorkLineMangaer sharedManager].currentCookie};
    [self post:url parameter:parameter header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}

+ (void)fetchUserInfo:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed
{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/userInfoOrigin/getUserInfo.html"];
    NSDictionary *header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost,@"Cookie":[NetWorkLineMangaer sharedManager].currentCookie};
    [self post:url parameter:nil header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}
+(void)fetchCaptchaCodeInfo:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/captcha/pmregister.html"];
    NSDictionary *header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost,@"Cookie":[NetWorkLineMangaer sharedManager].currentCookie};
    [self post:url parameter:nil header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}
@end
