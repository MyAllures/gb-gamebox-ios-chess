//
//  SH_NetWorkService+Profit.h
//  GameBox
//
//  Created by jun on 2018/7/16.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_NetWorkService.h"
#import "SH_ProfitModel.h"
#import "SH_FeeModel.h"
#import "SH_JiHeModel.h"
typedef void(^profitBlock) (SH_ProfitModel *model);
typedef void (^feeBlock)(SH_FeeModel *model);
typedef void (^jiHeBlock)(SH_JiHeModel *model);
@interface SH_NetWorkService (Profit)
+(void)getBankInforComplete:(profitBlock)complete
                     failed:(SHNetWorkFailed)failed;

+(void)caculateOutCoinFeeWithNum:(NSString *)num
                        Complete:(feeBlock)complete
                          failed:(SHNetWorkFailed)failed;
+(void)jiHeListSuccess:(jiHeBlock)success
                Failed:(SHNetWorkFailed)failed;



/**
 确认出币  也是GB的取款接口

 @param money 金额
 @param saftyPWD 安全密码
 @param token token
 @param way 选择方式
 */
+(void)sureOutCoinMoney:(NSString *)money
               SaftyPWD:(NSString *)saftyPWD
                  Token:(NSString *)token
                    Way:(NSString *)way
                Success:(SHNetWorkComplete)success
                 Failed:(SHNetWorkFailed)failed;
@end
