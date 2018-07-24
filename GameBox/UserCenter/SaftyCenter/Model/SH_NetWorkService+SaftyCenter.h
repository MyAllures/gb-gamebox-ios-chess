//
//  SH_NetWorkService+SaftyCenter.h
//  GameBox
//
//  Created by jun on 2018/7/18.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_NetWorkService.h"

@interface SH_NetWorkService (SaftyCenter)
+(void)updatePassword:(NSString *)password
          NewPassword:(NSString *)newPassword
     VerificationCode:(NSString *)code
              Success:(SHNetWorkComplete)success
                 Fail:(SHNetWorkFailed)fail;

/**
 绑定银行卡

 @param realName 真实姓名
 @param bankName 银行名称
 @param cardNum 卡号
 @param bankDeposit 开户行
 */
+(void)bindBankcardRealName:(NSString *)realName
                   BankName:(NSString *)bankName
                    CardNum:(NSString *)cardNum
                BankDeposit:(NSString *)bankDeposit
                    Success:(SHNetWorkComplete)success
                       Fail:(SHNetWorkFailed)fail;

+(void)initUserSaftyInfoSuccess:(SHNetWorkComplete)success
                           Fail:(SHNetWorkFailed)fail;

/**
 设置安全密码

 @param realName 真实姓名
 @param originPwd 原始密码
 @param pwd1 新密码
 @param pwd2 新密码
 @param code 验证吗
 @param success <#success description#>
 @param fail <#fail description#>
 */
+(void)setSaftyPasswordRealName:(NSString *)realName
                 originPassword:(NSString *)originPwd
                    newPassword:(NSString *)pwd1
                confirmPassword:(NSString *)pwd2
                     verifyCode:(NSString *)code
                        Success:(SHNetWorkComplete)success
                           Fail:(SHNetWorkFailed)fail;
//获取安全密码验证码接口
+(void)getSaftyVericationCodeSuccess:(SHNetWorkComplete)success
                                Fail:(SHNetWorkFailed)fail;

//获取用户手机号状态，是否绑定过手机号码
+(void)getUserPhoneInfoSuccess:(SHNetWorkComplete)success
                          Fail:(SHNetWorkFailed)fail;

@end
