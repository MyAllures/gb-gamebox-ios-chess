//
//  SH_NetWorkService+RechargeCenter.m
//  GameBox
//
//  Created by jun on 2018/7/7.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_NetWorkService+RechargeCenter.h"

@implementation SH_NetWorkService (RechargeCenter)
+(void)RechargeCenterComplete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/depositOrigin/index.html"];
    NSDictionary *header = @{@"X-Requested-With":@"XMLHttpRequest",@"User-Agent":@"app_ios, iPhone",@"Host":[NetWorkLineMangaer sharedManager].currentHost};
    [self post:url parameter:[NSDictionary dictionary] header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
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
