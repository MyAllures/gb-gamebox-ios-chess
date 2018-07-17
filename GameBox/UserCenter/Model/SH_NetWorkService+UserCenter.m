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

+(void)fetchDepositPulldownListComplete:(SHNetWorkComplete)complete
                                 failed:(SHNetWorkFailed)failed{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/mineOrigin/getTransactionType.html"];
    NSDictionary *header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost,@"Cookie":([NetWorkLineMangaer sharedManager].currentCookie?[NetWorkLineMangaer sharedManager].currentCookie:@"")};
    [self post:url parameter:nil header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            NSDictionary * result = ConvertToClassPointer(NSDictionary, response);
            if ([result boolValueForKey:@"success"]) {
                complete(httpURLResponse, result);
            }
            
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
            NSDictionary * result = ConvertToClassPointer(NSDictionary, response);
            if ([result boolValueForKey:@"success"]) {
                NSError * errer;
                SH_WelfareInfoModel * model = [[SH_WelfareInfoModel  alloc]initWithDictionary:result[@"data"] error:&errer];
                complete(httpURLResponse, model.fundListApps);
            }
           
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}
+(void)fetchDepositListDetail:(NSString*)Id
                     complete:(SHNetWorkComplete)complete
                       failed:(SHNetWorkFailed)failed{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:Id forKey:@"searchId"];
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/mineOrigin/getFundRecordDetails.html"];
    NSDictionary *header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost,@"Cookie":([NetWorkLineMangaer sharedManager].currentCookie?[NetWorkLineMangaer sharedManager].currentCookie:@"")};
    [self post:url parameter:dict header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            NSDictionary * result = ConvertToClassPointer(NSDictionary, response);
            if ([result boolValueForKey:@"success"]) {

               
            }
            
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}
@end
