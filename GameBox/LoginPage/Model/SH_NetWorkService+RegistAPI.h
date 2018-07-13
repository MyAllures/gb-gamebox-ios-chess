//
//  SH_NetWorkService+RegistAPI.h
//  GameBox
//
//  Created by Paul on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_NetWorkService.h"

@interface SH_NetWorkService (RegistAPI)
+(void)fetchCaptchaCodeInfo:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed;

#pragma mark ---  登录输错密码之后获取登录验证码
+(void)fetchVerifyCode:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed;
#pragma mark ---  注册验证码
+(void)fetchV3RegisetCaptchaCode:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed;
#pragma mark ---  用户登录是否开启验证码
+(void)fetchIsOpenCodeVerifty:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed;
#pragma mark --- 注册初始化
+(void)fetchV3RegisetInit:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed;
#pragma mark --- 注册条款 
+(void)fetchV3RegisetTerm:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed;
#pragma mark --- 获取手机验证码
+(void)fetchMobileCodeWithPhoneNumber:(NSString*)phoneNUmber complete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed;
#pragma mark --- 注册提交
/**
 注册提交
 
 @param birth 生日
 @param sex 性别
 @param permissionPwd  安全码
 @param defaultTimezone 时区
 @param defaultLocale 默认语言
 @param phone 手机号
 @param realName 真实姓名
 @param defaultCurrency   货币
 @param password 密码
 @param question1 问题
 @param email 邮箱
 @param qq qq
 @param weixinValue 微信
 @param userName 用户名
 @param captchaCode 验证码
 */
+(void)fetchV3RegisetSubmitWithBirthday:(NSString *)birth
                                    sex:(NSString *)sex
                          permissionPwd:(NSString *)permissionPwd
                        defaultTimezone:(NSString *)defaultTimezone
                          defaultLocale:(NSString *)defaultLocale
                      phonecontactValue:(NSString *)phone
                               realName:(NSString *)realName
                        defaultCurrency:(NSString *)defaultCurrency
                               password:(NSString *)password
                              question1:(NSString *)question1
                             emailValue:(NSString *)email
                                qqValue:(NSString *)qq
                            weixinValue:(NSString *)weixinValue
                               userName:(NSString *)userName
                            captchaCode:(NSString *)captchaCode
                  recommendRegisterCode:(NSString *)recommendRegisterCode
                               editType:(NSString *)editType
                 recommendUserInputCode:(NSString *)recommendUserInputCode
                        confirmPassword:(NSString *)confirmPassword
                   confirmPermissionPwd:(NSString *)confirmPermissionPwd
                                answer1:(NSString *)answer1
                         termsOfService:(NSString *)termsOfService
                           requiredJson:(NSArray<NSString *> *)requiredJson
                              phoneCode:(NSString *)phoneCode
                             checkPhone:(NSString *)checkPhone
                               complete:(SHNetWorkComplete)complete
                                 failed:(SHNetWorkFailed)failed;
@end
