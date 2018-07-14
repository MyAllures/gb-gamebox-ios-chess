//
//  SH_NetWorkService+RechargeCenter.h
//  GameBox
//
//  Created by jun on 2018/7/7.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_NetWorkService.h"
#import "SH_RechargeCenterPaywayModel.h"
#import "SH_RechargeCenterPlatformModel.h"
#import "SH_BitCoinSaleModel.h"
typedef void(^RechargeCenterPlatform)(NSArray *array);
typedef void(^RechargeCenterPayway)(SH_RechargeCenterPaywayModel *model);
typedef void(^NormalDepositeSale) (SH_BitCoinSaleModel *model);
@interface SH_NetWorkService (RechargeCenter)
//请求存款平台接口
+(void)RechargeCenterComplete:(RechargeCenterPlatform)complete
                       failed:(SHNetWorkFailed)failed;
//请求存款方式
+(void)RechargeCenterPayway:(NSString *)payway
                   Complete:(RechargeCenterPayway)complete
                     failed:(SHNetWorkFailed)failed;
//获取普通存款优惠接口，和比特币有点不一样
+(void)getNormalDepositeNum:(NSString *)num
                     Payway:(NSString *)payway
               PayAccountId:(NSString *)accountId
                   Complete:(NormalDepositeSale)complete
                     failed:(SHNetWorkFailed)failed;


//在线支付存款
+(void)onlineDepositeyWithRechargeAmount:(NSString *)amount
                          rechargeType:(NSString *)rechargeType
                          payAccountId:(NSString *)payAccountId
                            activityId:(NSString *)activityId
                              Complete:(SHNetWorkComplete)complete
                                failed:(SHNetWorkFailed)failed;

/**
 普通支付存款

 @param amount 存款金额
 @param rechargeType 充值类型
 @param account 存款渠道
 @param bankOrder 订单号后５位
 @param payerName 支付户名(只针对支付宝电子支付)
 @param payerBankcard 支付账号
 @param activityId 优惠id
 @param complete <#complete description#>
 @param failed <#failed description#>
 */
+(void)normalPayDepositWithRechargeAmount:(NSString *)amount
                             RechargeType:(NSString *)rechargeType
                             Account:(NSString *)account
                                BankOrder:(NSString *)bankOrder
                                PayerName:(NSString *)payerName
                            PayerBankcard:(NSString *)payerBankcard
                               ActivityId:(NSString *)activityId
                                 Complete:(SHNetWorkComplete)complete
                                   failed:(SHNetWorkFailed)failed;
@end
