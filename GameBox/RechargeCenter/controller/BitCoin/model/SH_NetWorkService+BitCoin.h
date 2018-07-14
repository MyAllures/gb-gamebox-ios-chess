//
//  SH_NetWorkService+BitCoin.h
//  GameBox
//
//  Created by jun on 2018/7/12.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_NetWorkService.h"
#import "SH_BitCoinSaleModel.h"
typedef void(^bitCoinSale) (SH_BitCoinSaleModel *model);
@interface SH_NetWorkService (BitCoin)

/**
 请求存款优惠接口

 @param num 比特币的数量
 @param payway 
 @param txid <#txid description#>
 @param accountId <#accountId description#>
 */
+(void)getSaleWithCoinNum:(NSString *)num
                   Payway:(NSString *)payway
                     Txid:(NSString *)txid
             PayAccountId:(NSString *)accountId
                 Complete:(bitCoinSale)complete
                   failed:(SHNetWorkFailed)failed;


/**
 请求比特币存款接口

 @param rechargeType <#rechargeType description#>
 @param payAccountId <#payAccountId description#>
 @param activityId <#activityId description#>
 @param returnTime <#returnTime description#>
 @param adress <#adress description#>
 @param num <#num description#>
 @param txid <#txid description#>
 @param complete <#complete description#>
 */
+(void)bitCoinPayWithRechargeType:(NSString *)rechargeType
                            PayAccountId:(NSString *)payAccountId
                              ActivityId:(NSString *)activityId
                              ReturnTime:(NSString *)returnTime
                           Adrress:(NSString *)adress
                               BitCoinNum:(NSString *)num
                             Txid:(NSString *)txid
                         Complete:(SHNetWorkComplete)complete
                           failed:(SHNetWorkFailed)failed;
@end
