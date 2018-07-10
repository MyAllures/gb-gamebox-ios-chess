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
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970] ;    NSString *timeStr = [NSString stringWithFormat:@"%.0f",timeInterval*1000] ;
//    NSDictionary * dict = [NSDictionary  dictionaryWithObjectsAndKeys:timeStr,@"_t", nil];
    
    
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/captcha/code.html"];
    NSDictionary *parameter =  @{@"_t":timeStr};
    NSDictionary *header = @{@"X-Requested-With":@"XMLHttpRequest",@"User-Agent":@"app_ios, iPhone",@"Host":[NetWorkLineMangaer sharedManager].currentHost,@"Cookie":[NetWorkLineMangaer sharedManager].currentSID};
    [self post:url parameter:parameter header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
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
