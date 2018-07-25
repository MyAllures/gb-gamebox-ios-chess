//
//  SH_NetWorkService_FindPsw.h
//  GameBox
//
//  Created by sam on 2018/7/25.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_NetWorkService.h"

@interface SH_NetWorkService_FindPsw : SH_NetWorkService
+(void)findUserPhone:(NSString *)username
            complete:(SHNetWorkComplete)complete
              failed:(SHNetWorkFailed)failed;

+(void)forgetPswSendCode:(NSString *)encryptedId
                complete:(SHNetWorkComplete)complete
                  failed:(SHNetWorkFailed)failed;
+(void)forgetPswCheckCode:(NSString *)code
                 complete:(SHNetWorkComplete)complete
                   failed:(SHNetWorkFailed)failed;
+(void)finbackLoginPsw:(NSString *)username psw:(NSString *)psw
              complete:(SHNetWorkComplete)complete
                failed:(SHNetWorkFailed)failed;
+(void)checkForgetPswStatusComplete:(SHNetWorkComplete)complete
                             failed:(SHNetWorkFailed)failed;
@end
