//
//  SH_NetWorkService+Promo.m
//  GameBox
//
//  Created by sam on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_NetWorkService+Promo.h"

@implementation SH_NetWorkService_Promo

+ (void)getPromoList:(NSInteger )pageNumber pageSize:(NSInteger )pageSize activityClassifyKey:(NSString *)activityClassifyKey complete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed
{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/discountsOrigin/getActivityTypeList.html"];
    NSDictionary *parameter =  @{@"paging.pageNumber":@(pageNumber),@"paging.pageSize":@(pageSize),@"search.activityClassifyKey":activityClassifyKey};
    NSDictionary *header = @{@"User-Agent":@"app_ios, iPhone",@"Host":[NetWorkLineMangaer sharedManager].currentHost,@"Cookie":[NetWorkLineMangaer sharedManager].currentSID};
    [SH_NetWorkService post:url parameter:parameter header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}

@end
