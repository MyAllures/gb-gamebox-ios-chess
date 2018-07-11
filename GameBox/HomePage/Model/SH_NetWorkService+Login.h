//
//  SH_NetWorkService+Login.h
//  GameBox
//
//  Created by shin on 2018/7/4.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_NetWorkService.h"

@interface SH_NetWorkService (Login)

+ (void)fetchHttpCookie:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed;

+ (void)login:(NSString *)userName psw:(NSString *)psw verfyCode:(NSString *)verfyCode complete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed;

+ (void)fetchUserInfo:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed;

+(void)fetchCaptchaCodeInfo:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed;

/**
 获取登录验证码

 @param complete 成功的回调
 @param failed 失败的回调
 */
+(void)fetchVerifyCodexxx:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed;
@end
