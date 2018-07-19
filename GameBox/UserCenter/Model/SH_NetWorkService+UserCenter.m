//
//  SH_NetWorkService+UserCenter.m
//  GameBox
//
//  Created by Paul on 2018/7/17.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_NetWorkService+UserCenter.h"
#import "SH_WelfareInfoModel.h"
@implementation SH_NetWorkService (UserCenter)
#pragma  mark --- 搜索条件
+(void)fetchDepositPulldownListComplete:(SHNetWorkComplete)complete
                                 failed:(SHNetWorkFailed)failed{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/mineOrigin/getTransactionType.html"];
    NSDictionary *header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost,@"Cookie":([NetWorkLineMangaer sharedManager].currentCookie?[NetWorkLineMangaer sharedManager].currentCookie:@"")};
    [self post:url parameter:nil header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
              complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}
#pragma mark -- 资金记录
+(void)fetchDepositList:(NSString*)startDate
                EndDate:(NSString*)endDate
             SearchType:(NSString*)type
             PageNumber:(NSInteger)pageNumber
               PageSize:(NSInteger)pageSize
               complete:(SHNetWorkComplete)complete
                 failed:(SHNetWorkFailed)failed{
    NSMutableDictionary *dictTmp = [[NSMutableDictionary alloc] init] ;
    [dictTmp setValue:startDate?:@"" forKey:@"search.beginCreateTime"] ;
    [dictTmp setValue:endDate?:@"" forKey:@"search.endCreateTime"] ;
    [dictTmp setValue:@(pageNumber) forKey:@"paging.pageNumber"] ;
    [dictTmp setValue:@(pageSize) forKey:@"paging.pageSize"] ;
    [dictTmp setValue:type forKey:@"search.transactionType"] ;
    
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/mineOrigin/getFundRecord.html"];
    NSDictionary *header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost,@"Cookie":([NetWorkLineMangaer sharedManager].currentCookie?[NetWorkLineMangaer sharedManager].currentCookie:@"")};
    [self post:url parameter:dictTmp header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
           /* NSDictionary * result = ConvertToClassPointer(NSDictionary, response);
            if ([result boolValueForKey:@"success"]) {
                NSError * errer;
                SH_WelfareInfoModel * model = [[SH_WelfareInfoModel  alloc]initWithDictionary:result[@"data"] error:&errer];
                complete(httpURLResponse, model.fundListApps);
            }*/
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}
#pragma  mark --- 福利记录
+(void)fetchDepositListDetail:(NSString*)Id
                     complete:(SHNetWorkComplete)complete
                       failed:(SHNetWorkFailed)failed{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:Id forKey:@"searchId"];
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/mineOrigin/getFundRecordDetails.html"];
    NSDictionary *header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost,@"Cookie":([NetWorkLineMangaer sharedManager].currentCookie?[NetWorkLineMangaer sharedManager].currentCookie:@"")};
    [self post:url parameter:dict header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}
#pragma mark -牌局记录
+(void)fetchBettingList:(NSString*)startDate EndDate:(NSString*)endDate
             PageNumber:(NSInteger)pageNumber
               PageSize:(NSInteger)pageSize
       withIsStatistics:(BOOL)isShowStatistics
               complete:(SHNetWorkComplete)complete
                 failed:(SHNetWorkFailed)failed{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:startDate forKey:@"search.beginBetTime"];
    [dict setValue:endDate forKey:@"search.endBetTim"];
    [dict setValue:[NSString  stringWithFormat:@"%ld",pageNumber] forKey:@"paging.pageNumber"];
    [dict setValue:[NSString stringWithFormat:@"%ld",pageSize] forKey:@"paging.pageSize"];
    [dict setValue:[NSString  stringWithFormat:@"%@",@(isShowStatistics)] forKey:@"isShowStatistics"];
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/mineOrigin/getBettingList.html"];
    NSDictionary *header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost,@"Cookie":([NetWorkLineMangaer sharedManager].currentCookie?[NetWorkLineMangaer sharedManager].currentCookie:@"")};
    [self post:url parameter:dict header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}
#pragma mark --投注记录详情
+(void)fetchBettingDetails:(NSInteger)listId
                  complete:(SHNetWorkComplete)complete
                    failed:(SHNetWorkFailed)failed{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init] ;
    [dict setValue:@(listId) forKey:@"id"] ;
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/mineOrigin/getBettingDetails.html"];
    NSDictionary *header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost,@"Cookie":([NetWorkLineMangaer sharedManager].currentCookie?[NetWorkLineMangaer sharedManager].currentCookie:@"")};
    [self post:url parameter:dict header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}
#pragma mark --- 分享二维码
+(void)fetchShareQRCodeComplete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/chess/getShareQRCode.htmll"];
    NSDictionary *header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost,@"Cookie":([NetWorkLineMangaer sharedManager].currentCookie?[NetWorkLineMangaer sharedManager].currentCookie:@"")};
    [self post:url parameter:nil header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}
@end
