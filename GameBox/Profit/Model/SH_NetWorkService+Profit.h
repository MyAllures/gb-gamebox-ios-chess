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
@end
