//
//  SH_NetWorkService+RechargeCenter.m
//  GameBox
//
//  Created by jun on 2018/7/7.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_NetWorkService+RechargeCenter.h"

@implementation SH_NetWorkService (RechargeCenter)
+(void)RechargeCenterComplete:(RechargeCenterPlatform)complete
                       failed:(SHNetWorkFailed)failed{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/depositOrigin/index.html"];
    NSDictionary *header = @{@"X-Requested-With":@"XMLHttpRequest",@"User-Agent":@"app_ios, iPhone",@"Host":[NetWorkLineMangaer sharedManager].currentHost};
    [self post:url parameter:[NSDictionary dictionary] header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            NSArray *platforms= [SH_RechargeCenterPlatformModel arrayOfModelsFromDictionaries:response[@"data"] error:nil];
            complete(platforms);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}
+(void)RechargeCenterPayway:(NSString *)payway
                   Complete:(RechargeCenterPayway)complete
                     failed:(SHNetWorkFailed)failed{
     NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:[NSString stringWithFormat:@"/mobile-api/depositOrigin/%@.html",payway]];
    NSDictionary *header = @{@"X-Requested-With":@"XMLHttpRequest",@"User-Agent":@"app_ios, iPhone",@"Host":[NetWorkLineMangaer sharedManager].currentHost,@"Cookie":[NetWorkLineMangaer sharedManager].currentCookie};
    [self post:url parameter:[NSDictionary dictionary] header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            NSDictionary *dic = [(NSDictionary *)response objectForKey:@"data"];
            NSError *err;
            SH_RechargeCenterPaywayModel *paywayModel = [[SH_RechargeCenterPaywayModel alloc]initWithDictionary:dic error:&err];
            complete(paywayModel);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
    
}
@end