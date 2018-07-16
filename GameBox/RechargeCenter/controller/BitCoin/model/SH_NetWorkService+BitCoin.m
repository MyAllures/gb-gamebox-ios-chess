//
//  SH_NetWorkService+BitCoin.m
//  GameBox
//
//  Created by jun on 2018/7/12.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_NetWorkService+BitCoin.h"

@implementation SH_NetWorkService (BitCoin)
+(void)getSaleWithCoinNum:(NSString *)num
                   Payway:(NSString *)payway
                     Txid:(NSString *)txid
             PayAccountId:(NSString *)accountId
                 Complete:(bitCoinSale)complete
                   failed:(SHNetWorkFailed)failed{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/depositOrigin/seachSale.html"];
    NSDictionary *header = @{@"X-Requested-With":@"XMLHttpRequest",@"User-Agent":@"app_ios, iPhone",@"Host":[NetWorkLineMangaer sharedManager].currentHost};
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:num forKey:@"result.bitAmount"];
    [param setValue:payway forKey:@"depositWay"];
    [param setValue:txid forKey:@"result.bankOrder"];
    [param setValue:accountId forKey:@"account"];
    [self post:url parameter:param header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
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
+(void)bitCoinPayWithRechargeType:(NSString *)rechargeType
                     PayAccountId:(NSString *)payAccountId
                       ActivityId:(NSString *)activityId
                       ReturnTime:(NSString *)returnTime
                          Adrress:(NSString *)adress
                       BitCoinNum:(NSString *)num
                             Txid:(NSString *)txid
                         Complete:(SHNetWorkComplete)complete
                           failed:(SHNetWorkFailed)failed{ 
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:rechargeType forKey:@"result.rechargeType"];
    [param setValue:payAccountId forKey:@"account"];
    [param setValue:activityId forKey:@"activityId"];
    [param setValue:returnTime forKey:@"result.returnTime"];
    [param setValue:adress forKey:@"result.payerBankcard"];
    [param setValue:num forKey:@"result.bitAmount"];
    [param setValue:txid forKey:@"result.bankOrder"];
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/depositOrigin/bitcoinPay.html"];
    NSDictionary *header = @{@"X-Requested-With":@"XMLHttpRequest",@"User-Agent":@"app_ios, iPhone",@"Host":[NetWorkLineMangaer sharedManager].currentHost};
    [self post:url parameter:param header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
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
