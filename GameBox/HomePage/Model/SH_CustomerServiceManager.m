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
#import "AlertViewController.h"
#import "SH_CustomerServiceView.h"

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
            self.isInlay = [response[@"data"][@"isInlay"] boolValue];
            self.customerUrl = response[@"data"][@"customerUrl"];
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

//获取顶层视图控制器
- (UIViewController *)fetchTopLevelController
{
    UINavigationController *rootViewController = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    LineCheckViewController *lineCheckViewController = (LineCheckViewController *)rootViewController.presentedViewController;
    //取到顶层navigation控制器
    UIViewController *topNavController = [lineCheckViewController.rootNav.viewControllers lastObject];
    if (topNavController.presentedViewController) {
        //如果顶层nav有present的控制器
        //则取顶层present控制器
        UIViewController *topPresentedViewController = [self fetchTopLevelPresentedController:topNavController.presentedViewController];
        return topPresentedViewController;
    }
    else
    {
        return topNavController;
    }
}

//递归查找顶层present控制器
- (UIViewController *)fetchTopLevelPresentedController:(UIViewController *)rootVC
{
    if (rootVC.presentedViewController) {
        return [self fetchTopLevelPresentedController:rootVC.presentedViewController];
    }
    else
    {
        return rootVC;
    }
}

- (void)showCustomerWindow:(NSString *)url
{
    SH_CustomerServiceView *customerServiceView = [[SH_CustomerServiceView alloc] init];
    customerServiceView.url = url;
    AlertViewController * cvc = [[AlertViewController  alloc] initAlertView:customerServiceView viewHeight:[UIScreen mainScreen].bounds.size.height-60 titleImageName:@"title20" alertViewType:AlertViewTypeLong];
    cvc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    cvc.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    
    UIViewController *topVC = [self fetchTopLevelController];
    [topVC presentViewController:cvc animated:NO completion:nil];
}

@end
