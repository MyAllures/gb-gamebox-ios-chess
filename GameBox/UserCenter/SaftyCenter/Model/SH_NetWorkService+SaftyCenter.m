//
//  SH_NetWorkService+SaftyCenter.m
//  GameBox
//
//  Created by jun on 2018/7/18.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_NetWorkService+SaftyCenter.h"

@implementation SH_NetWorkService (SaftyCenter)
+(void)updatePassword:(NSString *)password
          NewPassword:(NSString *)newPassword
     VerificationCode:(NSString *)code
              Success:(SHNetWorkComplete)success
                 Fail:(SHNetWorkFailed)fail{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/mineOrigin/updateLoginPassword.html"];
    NSDictionary *header = @{@"X-Requested-With":@"XMLHttpRequest",@"User-Agent":@"app_ios, iPhone",@"Host":[NetWorkLineMangaer sharedManager].currentHost};
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:password forKey:@"password"];
    [param setValue:newPassword forKey:@"newPassword"];
     [param setValue:code forKey:@"code"];
    [self post:url parameter:param header:header cache:NO complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (success) {
            success(httpURLResponse,response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        if (fail) {
            fail(httpURLResponse, err);
        }
    }];
}
+(void)bindBankcardRealName:(NSString *)realName
                   BankName:(NSString *)bankName
                    CardNum:(NSString *)cardNum
                BankDeposit:(NSString *)bankDeposit
                    Success:(SHNetWorkComplete)success
                       Fail:(SHNetWorkFailed)fail{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/userInfoOrigin/submitBankCard.html"];
    NSDictionary *header = @{@"User-Agent":@"app_ios, iPhone",@"Host":[NetWorkLineMangaer sharedManager].currentHost,@"Cookie":[NetWorkLineMangaer sharedManager].currentCookie};
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:realName forKey:@"result.bankcardMasterName"];
    [param setValue:bankName forKey:@"result.bankName"];
    [param setValue:cardNum forKey:@"result.bankcardNumber"];
    [param setValue:bankDeposit forKey:@"result.bankDeposit"];
    [self post:url parameter:param header:header cache:NO complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (success) {
            success(httpURLResponse,response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        if (fail) {
            fail(httpURLResponse, err);
        }
    }];
}
+(void)initUserSaftyInfoSuccess:(SHNetWorkComplete)success
                           Fail:(SHNetWorkFailed)fail{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/mineOrigin/initSafePassword.html"];
    NSDictionary *header = @{@"User-Agent":@"app_ios, iPhone",@"Host":[NetWorkLineMangaer sharedManager].currentHost,@"Cookie":[NetWorkLineMangaer sharedManager].currentCookie};
    [self post:url parameter:[NSDictionary dictionary] header:header cache:NO complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (success) {
            success(httpURLResponse,response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        if (fail) {
            fail(httpURLResponse, err);
        }
    }];
}

+(void)setSaftyPasswordRealName:(NSString *)realName
                 originPassword:(NSString *)originPwd
                    newPassword:(NSString *)pwd1
                confirmPassword:(NSString *)pwd2
                     verifyCode:(NSString *)code
                        Success:(SHNetWorkComplete)success
                           Fail:(SHNetWorkFailed)fail{
    
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/mineOrigin/updateSafePassword.html"];
    NSDictionary *header = @{@"User-Agent":@"app_ios, iPhone",@"Host":[NetWorkLineMangaer sharedManager].currentHost,@"Cookie":[NetWorkLineMangaer sharedManager].currentCookie};
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:realName forKey:@"realName"];
    [param setValue:originPwd forKey:@"originPwd"];
    [param setValue:pwd1 forKey:@"pwd1"];
    [param setValue:pwd2 forKey:@"pwd2"];
    [param setValue:code forKey:@"code"];
    [self post:url parameter:param header:header cache:NO complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (success) {
            success(httpURLResponse,response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        if (fail) {
            fail(httpURLResponse, err);
        }
    }];
    
}
+(void)getSaftyVericationCodeSuccess:(SHNetWorkComplete)success
                                Fail:(SHNetWorkFailed)fail{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/captcha/securityPwd.html"];
    NSDictionary *header = @{@"User-Agent":@"app_ios, iPhone",@"Host":[NetWorkLineMangaer sharedManager].currentHost,@"Cookie":[NetWorkLineMangaer sharedManager].currentCookie};
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970] ;
    NSString *timeStr = [NSString stringWithFormat:@"%.0f",timeInterval*1000] ;
    [self post:url parameter:@{@"_t":timeStr} header:header cache:NO complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (success) {
            success(httpURLResponse,response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        if (fail) {
            fail(httpURLResponse, err);
        }
    }];
}
+(void)getUserPhoneInfoSuccess:(SHNetWorkComplete)success
                          Fail:(SHNetWorkFailed)fail{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/mineOrigin/getUserPhone.html"];
    NSDictionary *header = @{@"User-Agent":@"app_ios, iPhone",@"Host":[NetWorkLineMangaer sharedManager].currentHost,@"Cookie":[NetWorkLineMangaer sharedManager].currentCookie};
    [self post:url parameter:[NSDictionary dictionary] header:header cache:NO complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (success) {
            success(httpURLResponse,response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        if (fail) {
            fail(httpURLResponse, err);
        }
    }];
}
+(void)sendVerificationCodePhoneNum:(NSString *)phoneNum
                    Success:(SHNetWorkComplete)success
                       Fail:(SHNetWorkFailed)fail{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/origin/sendPhoneCode.html"];
    NSDictionary *header = @{@"User-Agent":@"app_ios, iPhone",@"Host":[NetWorkLineMangaer sharedManager].currentHost,@"Cookie":[NetWorkLineMangaer sharedManager].currentCookie};
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:phoneNum forKey:@"phone"];
    [self post:url parameter:param header:header cache:NO complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (success) {
            success(httpURLResponse,response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        if (fail) {
            fail(httpURLResponse, err);
        }
    }];
}

+(void)bindPhoneNum:(NSString *)phoneNum
   OriginalPhoneNum:(NSString *)originalPhoneNum
   VerificationCode:(NSString *)code
            Success:(SHNetWorkComplete)success
               Fail:(SHNetWorkFailed)fail{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/mineOrigin/updateUserPhone.html"];
    NSDictionary *header = @{@"User-Agent":@"app_ios, iPhone",@"Host":[NetWorkLineMangaer sharedManager].currentHost,@"Cookie":[NetWorkLineMangaer sharedManager].currentCookie};
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:phoneNum forKey:@"search.contactValue"];
    [param setValue:originalPhoneNum forKey:@"oldPhone"];
    [param setValue:code forKey:@"code"];
    [self post:url parameter:param header:header cache:NO complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (success) {
            success(httpURLResponse,response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        if (fail) {
            fail(httpURLResponse, err);
        }
    }];
    
}
+(void)oneKeyRefreshSuccess:(SHNetWorkComplete)success
                       Fail:(SHNetWorkFailed)fail{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/userInfoOrigin/refresh.html"];
    NSDictionary *header = @{@"User-Agent":@"app_ios, iPhone",@"Host":[NetWorkLineMangaer sharedManager].currentHost};
    [self post:url parameter:[NSDictionary dictionary] header:header cache:NO complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (success) {
            success(httpURLResponse,response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        if (fail) {
            fail(httpURLResponse, err);
        }
    }];
}
+(void)oneKeyRecoverySearchId:(NSString *)searchId
                      Success:(SHNetWorkComplete)success
                         Fail:(SHNetWorkFailed)fail{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/mineOrigin/recovery.html"];
    NSDictionary *header = @{@"User-Agent":@"app_ios, iPhone",@"Host":[NetWorkLineMangaer sharedManager].currentHost,@"Cookie":[NetWorkLineMangaer sharedManager].currentCookie};
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:searchId forKey:@"search.apiId"];
    [self post:url parameter:param header:header cache:NO complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (success) {
            success(httpURLResponse,response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        if (fail) {
            fail(httpURLResponse, err);
        }
    }];
    
}
@end
