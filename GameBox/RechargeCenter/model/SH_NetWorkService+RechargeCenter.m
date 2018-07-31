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
    NSDictionary *header = @{@"X-Requested-With":@"XMLHttpRequest",@"Host":[NetWorkLineMangaer sharedManager].currentHost};
    [self post:url parameter:[NSDictionary dictionary] header:header cache:NO complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            NSError *err;
            NSArray *platforms= [SH_RechargeCenterPlatformModel arrayOfModelsFromDictionaries:response[@"data"] error:&err];
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
    NSDictionary *header = @{@"X-Requested-With":@"XMLHttpRequest",@"Host":[NetWorkLineMangaer sharedManager].currentHost,@"Cookie":[NetWorkLineMangaer sharedManager].currentCookie};
    [self post:url parameter:[NSDictionary dictionary] header:header cache:NO complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
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
+(void)getNormalDepositeNum:(NSString *)num
                     Payway:(NSString *)payway
               PayAccountId:(NSString *)accountId
                   Complete:(NormalDepositeSale)complete
                     failed:(SHNetWorkFailed)failed{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/depositOrigin/seachSale.html"];
    NSDictionary *header = @{@"X-Requested-With":@"XMLHttpRequest",@"Host":[NetWorkLineMangaer sharedManager].currentHost};
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:num forKey:@"result.rechargeAmount"];
    [param setValue:payway forKey:@"depositWay"];
    [param setValue:accountId forKey:@"account"];
    [self post:url parameter:param header:header cache:NO complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            NSDictionary *dic = (NSDictionary *)response;
            NSError *erro;
            SH_BitCoinSaleModel *model = [[SH_BitCoinSaleModel alloc]initWithDictionary:dic[@"data"] error:&erro];
            complete(model);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
    
}
//在线支付存款
+(void)onlineDepositeyWithRechargeAmount:(NSString *)amount
                            rechargeType:(NSString *)rechargeType
                            payAccountId:(NSString *)payAccountId
                              activityId:(NSString *)activityId
                                Complete:(SHNetWorkComplete)complete
                                  failed:(SHNetWorkFailed)failed{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/depositOrigin/onlinePay.html"];
    NSDictionary *header = @{@"X-Requested-With":@"XMLHttpRequest",@"Host":[NetWorkLineMangaer sharedManager].currentHost};
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:amount forKey:@"result.rechargeAmount"];
    [param setValue:rechargeType forKey:@"result.rechargeType"];
    [param setValue:payAccountId forKey:@"account"];
    [param setValue:activityId forKey:@"activityId"];
    [self post:url parameter:param header:header cache:NO complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse,response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}

+(void)normalPayDepositWithRechargeAmount:(NSString *)amount
                             RechargeType:(NSString *)rechargeType
                                  Account:(NSString *)account
                                BankOrder:(NSString *)bankOrder
                                PayerName:(NSString *)payerName
                            PayerBankcard:(NSString *)payerBankcard
                               ActivityId:(NSString *)activityId
                                 Complete:(SHNetWorkComplete)complete
                                   failed:(SHNetWorkFailed)failed{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/depositOrigin/electronicPay.html"];
    NSDictionary *header = @{@"X-Requested-With":@"XMLHttpRequest",@"Host":[NetWorkLineMangaer sharedManager].currentHost};
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:amount forKey:@"result.rechargeAmount"];
    [param setValue:rechargeType forKey:@"result.rechargeType"];
    [param setValue:account forKey:@"account"];
    [param setValue:bankOrder forKey:@"result.bankOrder"];
    [param setValue:payerName forKey:@"result.payerName"];
    [param setValue:payerBankcard forKey:@"result.payerBankcard"];
    [param setValue:activityId forKey:@"activityId"];
    [self post:url parameter:param header:header cache:NO complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse,response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
    
}
@end
