//
//  SH_NetWorkService+PromoActivities.h
//  GameBox
//
//  Created by jun on 2018/8/9.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_NetWorkService.h"
#import "SH_PromoDetailModel.h"
 typedef void(^promoBlock)(NSArray *datas);
typedef void(^promoDetailBlock)(SH_PromoDetailModel *model);
@interface SH_NetWorkService (PromoActivities)
+(void)getActivityTypesSucess:(promoBlock)success
                      Failure:(SHNetWorkFailed)failure;

+(void)getPromoActivitiesDetailPromoId:(NSString *)promoId
                                Sucess:(promoDetailBlock)success
                              Failure:(SHNetWorkFailed)failure;
@end
