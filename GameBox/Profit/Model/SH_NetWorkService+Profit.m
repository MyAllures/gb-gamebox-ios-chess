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
                        Complete:(feeBlock)complete
                          failed:(SHNetWorkFailed)failed{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/withdrawOrigin/withdrawFee.html"];
    NSDictionary *header = @{@"X-Requested-With":@"XMLHttpRequest",@"User-Agent":@"app_ios, iPhone",@"Host":[NetWorkLineMangaer sharedManager].currentHost};
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:num forKey:@"withdrawAmount"];
    [self post:url parameter:param header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            NSDictionary *dic = [(NSDictionary *)response objectForKey:@"data"];
            SH_FeeModel *model = [[SH_FeeModel alloc]initWithDictionary:dic error:nil];
            complete(model);

        }
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}
+(void)jiHeListSuccess:(jiHeBlock)success
                Failed:(SHNetWorkFailed)failed{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/withdrawOrigin/getAuditLog.html"];
    NSDictionary *header = @{@"X-Requested-With":@"XMLHttpRequest",@"User-Agent":@"app_ios, iPhone",@"Host":[NetWorkLineMangaer sharedManager].currentHost};
    [self post:url parameter:[NSDictionary dictionary] header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (success) {
            NSDictionary *dic = [(NSDictionary *)response objectForKey:@"data"];
            SH_JiHeModel *model = [[SH_JiHeModel alloc]initWithDictionary:dic error:nil];
            success(model);
            
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}
+(void)sureOutCoinMoney:(NSString *)money
               SaftyPWD:(NSString *)saftyPWD
                  Token:(NSString *)token
                    Way:(NSString *)way
                Success:(SHNetWorkComplete)success
                 Failed:(SHNetWorkFailed)failed{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/withdrawOrigin/submitWithdraw.html"];
    NSDictionary *header = @{@"X-Requested-With":@"XMLHttpRequest",@"User-Agent":@"app_ios, iPhone",@"Host":[NetWorkLineMangaer sharedManager].currentHost};
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:money forKey:@"withdrawAmount"];
    [param setValue:saftyPWD forKey:@"originPwd"];
    [param setValue:token forKey:@"gb.token"];
    [param setValue:way forKey:@"remittanceWay"];
    [self post:url parameter:param header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (success) {
            success(httpURLResponse,response);
          
            
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}
@end
