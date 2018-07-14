//
//  SH_NetWorkService+Bank.m
//  GameBox
//
//  Created by jun on 2018/7/13.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_NetWorkService+Bank.h"

@implementation SH_NetWorkService (Bank)
+(void)bankDepositeyWithRechargeAmount:(NSString *)amount
                          rechargeType:(NSString *)rechargeType
                          payAccountId:(NSString *)payAccountId
                             payerName:(NSString *)payerName
                       rechargeAddress:(NSString *)rechargeAddress
                            activityId:(NSString *)activityId
                              Complete:(SHNetWorkComplete)complete
                                failed:(SHNetWorkFailed)failed{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/depositOrigin/companyPay.html"];
    NSDictionary *header = @{@"X-Requested-With":@"XMLHttpRequest",@"User-Agent":@"app_ios, iPhone",@"Host":[NetWorkLineMangaer sharedManager].currentHost};
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:amount forKey:@"result.rechargeAmount"];
    [param setValue:rechargeType forKey:@"result.rechargeType"];
    [param setValue:payAccountId forKey:@"account"];
    [param setValue:payerName forKey:@"result.payerName"];
    [param setValue:activityId forKey:@"activityId"];
    if (rechargeAddress) {
        //柜员机是有地址的   网银是没有的
        [param setValue:rechargeAddress forKey:@"result.rechargeAddress"];
    }
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
