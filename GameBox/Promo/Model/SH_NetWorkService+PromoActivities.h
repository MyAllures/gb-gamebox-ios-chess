//
//  SH_NetWorkService+PromoActivities.h
//  GameBox
//
//  Created by jun on 2018/8/9.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_NetWorkService.h"
#import "SH_PromoDetailModel.h"
#import "SH__PromoApplyModel.h"
 typedef void(^promoBlock)(NSArray *datas);
typedef void(^promoDetailBlock)(SH_PromoDetailModel *model);
typedef void(^promoApplyBlock)(SH__PromoApplyModel *model);
@interface SH_NetWorkService (PromoActivities)
//获取优惠活动类型
+(void)getActivityTypesSucess:(promoBlock)success
                      Failure:(SHNetWorkFailed)failure;
//根据id请求活动详情
+(void)getPromoActivitiesDetailPromoId:(NSString *)promoId
                                Sucess:(promoDetailBlock)success
                              Failure:(SHNetWorkFailed)failure;
//优惠活动申请
+(void)applyPromoActivitiesPromoId:(NSString *)promoId
                            Sucess:(promoApplyBlock)success
                           Failure:(SHNetWorkFailed)failure;
@end
