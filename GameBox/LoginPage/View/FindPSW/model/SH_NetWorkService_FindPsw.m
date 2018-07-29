//
//  SH_NetWorkService_FindPsw.m
//  GameBox
//
//  Created by sam on 2018/7/25.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_NetWorkService_FindPsw.h"

@implementation SH_NetWorkService_FindPsw
//查询用户是否绑定了手机号
+(void)findUserPhone:(NSString *)username
             complete:(SHNetWorkComplete)complete
               failed:(SHNetWorkFailed)failed {
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/findPasswordOrigin/findUserPhone.html"];
    NSDictionary *parameter =  @{@"username":username};
    NSDictionary *header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost, @"Cookie":[NetWorkLineMangaer sharedManager].currentCookie?:@""};
    [SH_NetWorkService post:url parameter:parameter header:header cache:NO complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}
//找回密码发送验证码
+(void)forgetPswSendCode:(NSString *)encryptedId
                complete:(SHNetWorkComplete)complete
                  failed:(SHNetWorkFailed)failed {
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/origin/sendFindPasswordPhone.html"];
    NSDictionary *parameter =  @{@"encryptedId":encryptedId};
    NSDictionary *header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost, @"Cookie":[NetWorkLineMangaer sharedManager].currentCookie?:@""};
    [SH_NetWorkService post:url parameter:parameter header:header cache:NO complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}
//找回密码验证验证码
+(void)forgetPswCheckCode:(NSString *)code
                 complete:(SHNetWorkComplete)complete
                   failed:(SHNetWorkFailed)failed {
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/findPasswordOrigin/checkPhoneCode.html"];
    NSDictionary *parameter =  @{@"code":code};
    NSDictionary *header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost, @"Cookie":[NetWorkLineMangaer sharedManager].currentCookie?:@""};
    [SH_NetWorkService post:url parameter:parameter header:header cache:NO complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}
//设置新密码
+(void)finbackLoginPsw:(NSString *)username
                   psw:(NSString *)psw
              complete:(SHNetWorkComplete)complete
                failed:(SHNetWorkFailed)failed {
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/findPasswordOrigin/findLoginPassword.html"];
    NSDictionary *parameter =  @{@"username":username, @"newPassword":psw};
    NSDictionary *header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost, @"Cookie":[NetWorkLineMangaer sharedManager].currentCookie?:@""};
    [SH_NetWorkService post:url parameter:parameter header:header cache:NO complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}
//检查该功能是否开启
+(void)checkForgetPswStatusComplete:(SHNetWorkComplete)complete
                             failed:(SHNetWorkFailed)failed {
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/findPasswordOrigin/openFindByPhone.html"];
    NSDictionary *parameter =  @{};
    NSDictionary *header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost, @"Cookie":[NetWorkLineMangaer sharedManager].currentCookie?:@""};
    [SH_NetWorkService post:url parameter:parameter header:header cache:NO complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}
@end
