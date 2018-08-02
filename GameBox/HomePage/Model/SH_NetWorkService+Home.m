//
//  SH_NetWorkService+Home.m
//  GameBox
//
//  Created by shin on 2018/7/12.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_NetWorkService+Home.h"

@implementation SH_NetWorkService (Home)

+ (void)fetchHomeInfo:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed
{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/chess/mainIndex.html"];
    [self post:url parameter:nil header:@{@"Host":[NetWorkLineMangaer sharedManager].currentHost} cache:YES complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}

+ (void)fetchGameLink:(NSString *)link complete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed
{
    NSArray *linkCompArr = [link componentsSeparatedByString:@"?"] ;
    NSString *gameLinkUrl = [linkCompArr objectAtIndex:0] ;
    NSArray *paraArr = [[linkCompArr objectAtIndex:1] componentsSeparatedByString:@"&"];
    NSString *temStr = [[paraArr  componentsJoinedByString:@","] stringByReplacingOccurrencesOfString:@"=" withString:@","];
    NSArray *temArr = [temStr componentsSeparatedByString:@","] ;
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary] ;
    for (int i= 0; i<temArr.count/2; i++) {
        [postDic setObject:[temArr objectAtIndex:2*i+1] forKey:[temArr objectAtIndex:i*2]];
    }
    
    [self post:gameLinkUrl parameter:postDic header:@{@"Host":[NetWorkLineMangaer sharedManager].currentHost,} cache:NO complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}

+ (void)fetchAnnouncement:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed
{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/origin/getAnnouncement.html"];
    [self post:url parameter:nil header:@{@"Host":[NetWorkLineMangaer sharedManager].currentHost} cache:NO complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}
+(void)onekeyrecoveryApiId:(NSString *)apiId
                   Success:(SHNetWorkComplete)success
                      failed:(SHNetWorkFailed)failed{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/mineOrigin/recovery.html"];
    NSDictionary *header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost,};
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:apiId forKey:@"search.apiId"];
    [self post:url parameter:param header:header cache:NO complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (success) {
            success(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}

+ (void)fetchTimeZone:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed
{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/origin/getTimeZone.html"];
    NSDictionary *header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost,};
    [self post:url parameter:nil header:header cache:NO complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}

+ (void)refreshUserSessin:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed
{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/mineOrigin/alwaysRequest.html"];
    NSDictionary *header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost,};
    [self post:url parameter:nil header:header cache:NO complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}

+ (void)getCustomerService:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed
{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/origin/getCustomerService.html"];
    NSDictionary *header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost,};
    [self post:url parameter:nil header:header cache:NO complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}

+ (void)checkVersionUpdate:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed
{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/app/update.html"];
    NSDictionary *param = @{@"code":S,
                            @"type":@"ios",
                            @"siteId":SID
                            };
    NSDictionary *header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost};
    [self post:url parameter:param header:header cache:NO complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
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
