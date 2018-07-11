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

/**
 获取登录验证码
 
 @param complete 成功的回调
 @param failed 失败的回调
 */
+(void)fetchVerifyCode:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed;

/**
 注册验证码

 @param complete <#complete description#>
 @param failed <#failed description#>
 */
+(void)fetchV3RegisetCaptchaCode:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed;

/**
 <#Description#>

 @param complete <#complete description#>
 @param failed <#failed description#>
 */
+(void)fetchIsOpenCodeVerifty:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed;
@end
