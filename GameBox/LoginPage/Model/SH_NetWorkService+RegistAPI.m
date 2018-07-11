//
//  SH_NetWorkService+RegistAPI.m
//  GameBox
//
//  Created by Paul on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_NetWorkService+RegistAPI.h"

@implementation SH_NetWorkService (RegistAPI)
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

+(void)fetchVerifyCode:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed{
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970] ;
    NSString *timeStr = [NSString stringWithFormat:@"%.0f",timeInterval*1000] ;
    NSDictionary * dict = [NSDictionary  dictionaryWithObjectsAndKeys:timeStr,@"_t", nil];
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/captcha/code.html"];
    NSDictionary *header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost};
    [self post:url parameter:dict header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
    
    
}
#pragma mark - 注册验证码
+(void)fetchV3RegisetCaptchaCode:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed{
    
}
+(void)fetchIsOpenCodeVerifty:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed{
    
}
#pragma mark - 用户登录是否开启验证码
@end
