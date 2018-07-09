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
typedef void(^RechargeCenterPlatform)(NSArray *array);
typedef void(^RechargeCenterPayway)(SH_RechargeCenterPaywayModel *model);
@interface SH_NetWorkService (RechargeCenter)
//请求存款平台接口
+(void)RechargeCenterComplete:(RechargeCenterPlatform)complete
                       failed:(SHNetWorkFailed)failed;
//请求存款方式
+(void)RechargeCenterPayway:(NSString *)payway
                   Complete:(RechargeCenterPayway)complete
                     failed:(SHNetWorkFailed)failed;
@end
