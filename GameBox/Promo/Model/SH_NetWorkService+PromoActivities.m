//
//  SH_NetWorkService+PromoActivities.m
//  GameBox
//
//  Created by jun on 2018/8/9.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_NetWorkService+PromoActivities.h"
#import "SH_PromoModel.h"
@implementation SH_NetWorkService (PromoActivities)
+(void)getActivityTypesSucess:(promoBlock)success
                      Failure:(SHNetWorkFailed)failure{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/chess/getActivityTypes.html"];
    NSDictionary *header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost};
    [self post:url parameter:[[NSMutableDictionary alloc]init] header:header cache:NO complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary *dic = ConvertToClassPointer(NSDictionary, response);
        NSString *code = dic[@"code"];
        if ([code isEqualToString:@"0"]) {
            NSArray *array = [SH_PromoModel arrayOfModelsFromDictionaries:dic[@"data"] error:nil];
                    if (success) {
                        success(array);
                    }
        }        
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
                if (failure) {
                    failure(httpURLResponse, err);
                }
    }];
}
+(void)getPromoActivitiesDetailPromoId:(NSString *)promoId
                                Sucess:(promoDetailBlock)success
                              Failure:(SHNetWorkFailed)failure{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/chess/getActivityById.html"];
    NSDictionary *header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost};
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:promoId forKey:@"search.id"];
    [self post:url parameter:param header:header cache:NO complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary *dic = ConvertToClassPointer(NSDictionary, response);
        NSString *code = dic[@"code"];
        if ([code isEqualToString:@"0"]) {
            SH_PromoDetailModel *model = [[SH_PromoDetailModel alloc]initWithDictionary:dic[@"data"] error:nil];
            if (success) {
                success(model);
            }
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        if (failure) {
            failure(httpURLResponse, err);
        }
    }];
}
@end
