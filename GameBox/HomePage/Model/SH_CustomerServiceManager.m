//
//  SH_CustomerServiceManager.m
//  GameBox
//
//  Created by shin on 2018/7/31.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_CustomerServiceManager.h"
#import "SH_NetWorkService+Home.h"

@interface SH_CustomerServiceManager ()

@property (nonatomic, assign) BOOL isInlay;
@property (nonatomic, strong) NSString *customerUrl;

@end

@implementation SH_CustomerServiceManager

+ (instancetype)sharedManager
{
    static SH_CustomerServiceManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[SH_CustomerServiceManager alloc] init];
        }
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [SH_NetWorkService getCustomerService:^(NSHTTPURLResponse *httpURLResponse, id response) {
            if (response && [response[@"code"] intValue] == 0) {
                self.isInlay = [response[@"data"][@"isInlay"] boolValue];
                self.customerUrl = response[@"data"][@"customerUrl"];
            }
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            //
        }];
    }
    return self;
}

- (void)open
{
    if (!self.isInlay) {
        if (self.customerUrl) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.customerUrl]];
        }
        else
        {
            showErrorMessage([UIApplication sharedApplication].keyWindow, nil, @"获取客服链接失败");
        }
    }
}
@end
