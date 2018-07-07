//
//  SH_NetWorkService+RechargeCenter.h
//  GameBox
//
//  Created by jun on 2018/7/7.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_NetWorkService.h"

@interface SH_NetWorkService (RechargeCenter)
+(void)RechargeCenterComplete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed;
@end
