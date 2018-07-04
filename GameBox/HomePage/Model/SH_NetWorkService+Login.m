//
//  SH_NetWorkService+Login.m
//  GameBox
//
//  Created by shin on 2018/7/4.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_NetWorkService+Login.h"
#import "NetWorkLineMangaer.h"

@implementation SH_NetWorkService (Login)

+ (void)login:(NSString *)userName psw:(NSString *)psw verfyCode:(NSString *)verfyCode complete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed
{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/passport/login.html"];
    NSDictionary *parameter = verfyCode == nil || [verfyCode isEqualToString:@""] ? @{@"username":userName,@"password":psw} : @{@"username":userName,@"password":psw,@"captcha":verfyCode};
    NSDictionary *header = @{@"X-Requested-With":@"XMLHttpRequest",@"Host":[NetWorkLineMangaer sharedManager].currentHost};
    [self post:url parameter:parameter header:header complete:^(id response) {
        if (complete) {
            complete(response);
        }
    } failed:^(NSString *err) {
        if (failed) {
            failed(err);
        }
    }];
}

@end
