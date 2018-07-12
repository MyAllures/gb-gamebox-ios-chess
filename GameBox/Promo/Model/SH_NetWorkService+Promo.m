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
    NSDictionary *header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost};
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

+(void)startLoadSystemNoticeStartTime:(NSString *)startTime
                              endTime:(NSString *)endTime
                           pageNumber:(NSInteger)pageNumber
                             pageSize:(NSInteger)pageSize complete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/mineOrigin/getSysNotice.html"];
    NSDictionary *parameter =  @{@"search.startTime":startTime?:@"",@"search.endTime":endTime?:@"",@"paging.pageNumber":@(pageNumber),@"paging.pageNumber":@(pageSize)};
    NSDictionary *header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost, @"Cookie":[NetWorkLineMangaer sharedManager].currentCookie?:@""};
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

+(void)startLoadGameNoticeStartTime:(NSString *)startTime
                            endTime:(NSString *)endTime
                         pageNumber:(NSInteger)pageNumber
                           pageSize:(NSInteger)pageSize
                              apiId:(NSInteger)apiId
                           complete:(SHNetWorkComplete)complete
                             failed:(SHNetWorkFailed)failed {
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/mineOrigin/getGameNotice.html"];
    NSDictionary *parameter =  @{@"search.startTime":startTime?:@"",@"search.endTime":endTime?:@"",@"paging.pageNumber":@(pageNumber),@"paging.pageNumber":@(pageSize),apiId>0?@"search.apiId":@(apiId):@""};
    NSDictionary *header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost, @"Cookie":[NetWorkLineMangaer sharedManager].currentCookie?:@""};
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
