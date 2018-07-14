//
//  SH_NetWorkService+Bank.h
//  GameBox
//
//  Created by jun on 2018/7/13.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_NetWorkService.h"

@interface SH_NetWorkService (Bank)
//柜员机和网银存款
+(void)bankDepositeyWithRechargeAmount:(NSString *)amount
                                          rechargeType:(NSString *)rechargeType
                                          payAccountId:(NSString *)payAccountId
                                             payerName:(NSString *)payerName
                                       rechargeAddress:(NSString *)rechargeAddress
                                            activityId:(NSString *)activityId
                                              Complete:(SHNetWorkComplete)complete
                                              failed:(SHNetWorkFailed)failed;
@end
