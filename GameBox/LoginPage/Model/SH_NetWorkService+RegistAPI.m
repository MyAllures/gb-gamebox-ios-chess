//
//  SH_NetWorkService+RegistAPI.m
//  GameBox
//
//  Created by Paul on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_NetWorkService+RegistAPI.h"
#import "SH_BankListModel.h"
#import "RH_RegisetInitModel.h"
@implementation SH_NetWorkService (RegistAPI)
+(void)fetchCaptchaCodeInfo:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/captcha/pmregister.html"];
    NSDictionary *header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost,@"Cookie":[NetWorkLineMangaer sharedManager].currentCookie?[NetWorkLineMangaer sharedManager].currentCookie:@""};
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
#pragma mark ---  登录输错密码之后获取登录验证码
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
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970] ;
    NSString *timeStr = [NSString stringWithFormat:@"%.0f",timeInterval*1000] ;
    NSDictionary * dic = [NSDictionary  dictionaryWithObjectsAndKeys:timeStr,@"_t", nil];
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/captcha/pmregister.html"];
    NSDictionary  * header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost};
    [self post:url parameter:dic header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}
#pragma mark - 用户登录是否开启验证码
+(void)fetchIsOpenCodeVerifty:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/mineOrigin/loginIsOpenVerify.html"];
    NSDictionary  * header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost};
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
#pragma mark -- 注册初始化
+(void)fetchV3RegisetInit:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/registerOrigin/getRegisterInfo.html"];
    NSDictionary  * header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost};
    [self post:url parameter:nil header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            NSDictionary  *  dic = ConvertToClassPointer(NSDictionary, response);
            RH_RegisetInitModel * model = [[RH_RegisetInitModel alloc] initWithDictionary:[dic objectForKey:@"data"] error:nil] ;
             complete(httpURLResponse, model);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}
#pragma mark --- 注册条款
+(void)fetchV3RegisetTerm:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/origin/terms.html"];
    NSDictionary  * header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost};
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
#pragma mark - 获取手机验证码
+(void)fetchMobileCodeWithPhoneNumber:(NSString*)phoneNUmber complete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed{
    NSDictionary  * dic = [NSDictionary  dictionaryWithObjectsAndKeys:phoneNUmber,@"phone", nil];
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/origin/sendPhoneCode.html"];
    NSDictionary  * header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost};
    [self post:url parameter:dic header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}
#pragma mark - 注册提交
+(void)fetchV3RegisetSubmitWithBirthday:(NSString *)birth sex:(NSString *)sex permissionPwd:(NSString *)permissionPwd defaultTimezone:(NSString *)defaultTimezone defaultLocale:(NSString *)defaultLocale phonecontactValue:(NSString *)phone realName:(NSString *)realName defaultCurrency:(NSString *)defaultCurrency password:(NSString *)password question1:(NSString *)question1 emailValue:(NSString *)email qqValue:(NSString *)qq weixinValue:(NSString *)weixinValue userName:(NSString *)userName captchaCode:(NSString *)captchaCode recommendRegisterCode:(NSString *)recommendRegisterCode editType:(NSString *)editType recommendUserInputCode:(NSString *)recommendUserInputCode confirmPassword:(NSString *)confirmPassword confirmPermissionPwd:(NSString *)confirmPermissionPwd answer1:(NSString *)answer1 termsOfService:(NSString *)termsOfService requiredJson:(NSArray<NSString *> *)requiredJson phoneCode:(NSString *)phoneCode checkPhone:(NSString *)checkPhone complete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:birth forKey:@"sysUser.birthday"];
    [dict setObject:sex forKey:@"sysUser.sex"];
    [dict setObject:permissionPwd forKey:@"sysUser.permissionPwd"];
    [dict setObject:defaultTimezone forKey:@"sysUser.defaultTimezone"];
    [dict setObject:phone forKey:@"phone.contactValue"];
    [dict setObject:realName forKey:@"sysUser.realName"];
    [dict setObject:defaultLocale forKey:@"sysUser.defaultLocale"];
    [dict setObject:defaultCurrency forKey:@"sysUser.defaultCurrency"];
    [dict setObject:password forKey:@"sysUser.password"];
    [dict setObject:question1 forKey:@"sysUserProtection.question1"];
    [dict setObject:email forKey:@"email.contactValue"];
    [dict setObject:qq forKey:@"qq.contactValue"];
    [dict setObject:weixinValue forKey:@"weixin.contactValue"];
    [dict setObject:userName forKey:@"sysUser.username"];
    [dict setObject:captchaCode forKey:@"captchaCode"];
    [dict setObject:recommendRegisterCode forKey:@"recommendRegisterCode"];
    [dict setObject:editType forKey:@"editType"];
    [dict setObject:recommendUserInputCode forKey:@"recommendUserInputCode"];
    [dict setObject:confirmPassword forKey:@"confirmPassword"];
    [dict setObject:confirmPermissionPwd forKey:@"confirmPermissionPwd"];
    [dict setObject:answer1 forKey:@"sysUserProtection.answer1"];
    [dict setObject:termsOfService forKey:@"termsOfService"];
    [dict setObject:phoneCode forKey:@"phoneCode"];
    [dict setObject:checkPhone forKey:@"checkPhone"];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization     dataWithJSONObject:requiredJson options:NSJSONWritingPrettyPrinted   error:&error];
    NSString *jsonString = [[NSString alloc]    initWithData:jsonData encoding:NSUTF8StringEncoding];
    [dict setObject:jsonString forKey:@"requiredJson"];
   
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/registerOrigin/save.html"];
    NSDictionary  * header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost};
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

#pragma mark --- 自动登录
+(void)fetchAutoLoginWithUserName:(NSString*)userName
                         Password:(NSString*)password
                         complete:(SHNetWorkComplete)complete
                           failed:(SHNetWorkFailed)failed{
    
    NSDictionary  * dic = [NSDictionary  dictionaryWithObjectsAndKeys:userName,@"username",password,@"password", nil];
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/login/autoLogin.html"];
    NSDictionary  * header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost,@"Cookie":([NetWorkLineMangaer sharedManager].currentCookie?[NetWorkLineMangaer sharedManager].currentCookie:@"")};
    [self post:url parameter:dic header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}
#pragma mark - 退出登录
+(void)fetchUserLoginOut:(SHNetWorkComplete)complete
                  failed:(SHNetWorkFailed)failed{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/mineOrigin/logout.html"];
    NSDictionary  * header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost};
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

+ (void)fetchUserInfo:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed
{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/userInfoOrigin/getUserInfo.html"];
    NSDictionary *header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost,@"Cookie":([NetWorkLineMangaer sharedManager].currentCookie?[NetWorkLineMangaer sharedManager].currentCookie:@"")};
    [self post:url parameter:nil header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
            NSError *err;
            NSArray *arr = [SH_BankListModel arrayOfModelsFromDictionaries:response[@"data"][@"bankList"] error:&err];
            [[RH_UserInfoManager shareUserManager] setBankList:arr];
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}

@end
