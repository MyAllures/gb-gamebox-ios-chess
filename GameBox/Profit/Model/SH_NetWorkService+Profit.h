//
//  SH_NetWorkService+Profit.h
//  GameBox
//
//  Created by jun on 2018/7/16.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_NetWorkService.h"
#import "SH_ProfitModel.h"
typedef void(^profitBlock) (SH_ProfitModel *model);
@interface SH_NetWorkService (Profit)
+(void)getBankInforComplete:(profitBlock)complete
                     failed:(SHNetWorkFailed)failed;

+(void)caculateOutCoinFeeWithNum:(NSString *)num
                        Complete:(SHNetWorkComplete)complete
                          failed:(SHNetWorkFailed)failed;
@end
