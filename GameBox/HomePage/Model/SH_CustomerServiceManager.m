//
//  SH_CustomerServiceManager.m
//  GameBox
//
//  Created by shin on 2018/7/31.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_CustomerServiceManager.h"
#import "SH_NetWorkService+Home.h"
#import "LineCheckViewController.h"
#import "SH_CustomerServiceView.h"
#import "SH_PromoWindowViewController.h"
#import "SH_TopLevelControllerManager.h"
#import "SH_BigWindowViewController.h"

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

- (void)open
{
    __weak typeof(self) weakSelf = self;

    [self fetchCustomerService:^(NSString *url) {
        if (!weakSelf.isInlay) {
            if (!IS_EMPTY_STRING(weakSelf.customerUrl)) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:weakSelf.customerUrl]];
            }
            else
            {
                showErrorMessage([UIApplication sharedApplication].keyWindow, nil, @"获取客服链接失败");
            }
        }
        else
        {
            if (!IS_EMPTY_STRING(weakSelf.customerUrl)) {
                [weakSelf showCustomerWindow:self.customerUrl];
            }
            else
            {
                showErrorMessage([UIApplication sharedApplication].keyWindow, nil, @"获取客服链接失败");
            }
        }

    } failed:^{
        showErrorMessage([UIApplication sharedApplication].keyWindow, nil, @"获取客服链接失败");
    }];
}

- (void)fetchCustomerService:(SH_CustomerServiceFetchSuccess)success failed:(SH_CustomerServiceFetchFailed)failed
{
    [SH_NetWorkService getCustomerService:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (response && [response[@"code"] intValue] == 0) {
            self.isInlay = YES;//[response[@"data"][@"isInlay"] boolValue];
            self.customerUrl = @"http://www.baidu.com";//[response[@"data"][@"customerUrl"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            if (success) {
                success(self.customerUrl);
            }
        }
        else
        {
            if (failed) {
                failed();
            }
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        if (failed) {
            failed();
        }
    }];
}

- (void)showCustomerWindow:(NSString *)url
{
    SH_CustomerServiceView *customerServiceView = [[SH_CustomerServiceView alloc] init];
    customerServiceView.url = url;
    
    SH_BigWindowViewController *cvc = [[SH_BigWindowViewController alloc] initWithNibName:@"SH_BigWindowViewController" bundle:nil];
    cvc.titleImageName = @"title20";
    cvc.customView = customerServiceView;
    cvc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    cvc.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;

    UIViewController *topVC = [SH_TopLevelControllerManager fetchTopLevelController];
    [topVC presentViewController:cvc animated:NO completion:nil];
}

@end
