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
#pragma mark - 获取手机验证码
+(void)fetchMobileCodeWithPhoneNumber:(NSString*)phoneNUmber complete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed;
@end
