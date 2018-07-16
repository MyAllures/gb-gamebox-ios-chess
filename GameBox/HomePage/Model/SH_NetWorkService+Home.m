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
    [self post:url parameter:nil header:@{@"Host":[NetWorkLineMangaer sharedManager].currentHost} complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
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
    
    [self post:gameLinkUrl parameter:postDic header:@{@"Host":[NetWorkLineMangaer sharedManager].currentHost,@"Cookie":[NetWorkLineMangaer sharedManager].currentCookie} complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
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
    [self post:url parameter:nil header:@{@"Host":[NetWorkLineMangaer sharedManager].currentHost} complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
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