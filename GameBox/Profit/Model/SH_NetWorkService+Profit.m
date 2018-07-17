//
//  SH_NetWorkService+Profit.m
//  GameBox
//
//  Created by jun on 2018/7/16.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_NetWorkService+Profit.h"

@implementation SH_NetWorkService (Profit)
+ (void)getBankInforComplete:(profitBlock)complete
                      failed:(SHNetWorkFailed)failed{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/withdrawOrigin/getWithDraw.html"];
    NSDictionary *header = @{@"X-Requested-With":@"XMLHttpRequest",@"User-Agent":@"app_ios, iPhone",@"Host":[NetWorkLineMangaer sharedManager].currentHost};

    [self post:url parameter:[NSDictionary dictionary] header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            NSDictionary *dic = [(NSDictionary *)response objectForKey:@"data"];
            SH_ProfitModel *model = [[SH_ProfitModel alloc]initWithDictionary:dic error:nil];
            complete(model);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}
+(void)caculateOutCoinFeeWithNum:(NSString *)num
                        Complete:(SHNetWorkComplete)complete
                          failed:(SHNetWorkFailed)failed{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/withdrawOrigin/withdrawFee.html"];
    NSDictionary *header = @{@"X-Requested-With":@"XMLHttpRequest",@"User-Agent":@"app_ios, iPhone",@"Host":[NetWorkLineMangaer sharedManager].currentHost};
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:num forKey:@"withdrawAmount"];
    [self post:url parameter:param header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            NSDictionary *dic = [(NSDictionary *)response objectForKey:@"data"];

        }
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}
@end
