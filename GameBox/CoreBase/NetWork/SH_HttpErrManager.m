//
//  SH_HttpErrManager.m
//  GameBox
//
//  Created by shin on 2018/7/31.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_HttpErrManager.h"
#import "LineCheckViewController.h"
#import "SH_LoginView.h"
#import "AlertViewController.h"
#import "SH_NoAccessViewController.h"

@interface SH_HttpErrManager ()

@end

@implementation SH_HttpErrManager

+ (void)dealWithErrCode:(int)code
{
    if (code == SH_API_ERRORCODE_600 ||
        code == SH_API_ERRORCODE_606 ||
        code == SH_API_ERRORCODE_1001) {
        
        [self fetchTargetVC:^(UIViewController *vc) {
            id topVC = vc;
            
            if ([topVC isMemberOfClass:[AlertViewController class]]) {
                NSString *title = ((AlertViewController *)topVC).imageName;
                if ([title isEqualToString:@"title01"]) {
                    //已经展示了登录页面 则不再展示
                    return;
                };
            }
            //先调用退出通知
            [[NSNotificationCenter  defaultCenter] postNotificationName:@"didLogOut" object:nil];
            
            SH_LoginView *login = [SH_LoginView InstanceLoginView];
            AlertViewController * cvc = [[AlertViewController  alloc] initAlertView:login viewHeight:[UIScreen mainScreen].bounds.size.height-60 titleImageName:@"title01" alertViewType:AlertViewTypeLong];
            cvc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            cvc.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
            login.targetVC = cvc;
            login.dismissBlock = ^{
                [cvc  close];
            };
            login.changeChannelBlock = ^(NSString *string) {
                [cvc setImageName:string];
            };
            
            [topVC presentViewController:cvc animated:NO completion:nil];
        }];
    }
    else if (code == SH_API_ERRORCODE_403)
    {
        showErrorMessage([UIApplication sharedApplication].keyWindow, nil, @"无权限访问");
    }
    else if (code == SH_API_ERRORCODE_404)
    {
        showErrorMessage([UIApplication sharedApplication].keyWindow, nil, @"请求链接或页面找不到");
    }
    else if (code == SH_API_ERRORCODE_500)
    {
        showErrorMessage([UIApplication sharedApplication].keyWindow, nil, @"代码错误");
    }
    else if (code == SH_API_ERRORCODE_502)
    {
        showErrorMessage([UIApplication sharedApplication].keyWindow, nil, @"网络错误");
    }
    else if (code == SH_API_ERRORCODE_601)
    {
        showErrorMessage([UIApplication sharedApplication].keyWindow, nil, @"需要输入安全密码");
    }
    else if (code == SH_API_ERRORCODE_602)
    {
        showErrorMessage([UIApplication sharedApplication].keyWindow, nil, @"服务忙");
    }
    else if (code == SH_API_ERRORCODE_603)
    {
        showErrorMessage([UIApplication sharedApplication].keyWindow, nil, @"域名不存在");
    }
    else if (code == SH_API_ERRORCODE_604)
    {
        showErrorMessage([UIApplication sharedApplication].keyWindow, nil, @"临时域名过期");
    }
    else if (code == SH_API_ERRORCODE_605)
    {
        //ip被限制
        UINavigationController *rootViewController = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        LineCheckViewController *lineCheckViewController = (LineCheckViewController *)rootViewController.presentedViewController;
        
        //取到顶层navigation控制器
        UIViewController *topNavController = [lineCheckViewController.rootNav.viewControllers lastObject];
        //如果有push的VC先pop到首页控制器
        [topNavController.navigationController popToRootViewControllerAnimated:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIViewController *homeViewVC = [lineCheckViewController.rootNav.viewControllers firstObject];
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                SH_NoAccessViewController *vc = [[SH_NoAccessViewController alloc] initWithNibName:@"SH_NoAccessViewController" bundle:nil];
                [homeViewVC.navigationController pushViewController:vc animated:NO];
            });
        });
    }
    else if (code == SH_API_ERRORCODE_607)
    {
        showErrorMessage([UIApplication sharedApplication].keyWindow, nil, @"站点维护");
    }
    else if (code == SH_API_ERRORCODE_608)
    {
        showErrorMessage([UIApplication sharedApplication].keyWindow, nil, @"重复请求");
    }
    else if (code == SH_API_ERRORCODE_609)
    {
        showErrorMessage([UIApplication sharedApplication].keyWindow, nil, @"站点不存在");
    }
}

//获取顶层视图控制器
+ (void)fetchTargetVC:(SH_HttpErrManagerFetchTargetVCComplete)complete
{
    UINavigationController *rootViewController = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    LineCheckViewController *lineCheckViewController = (LineCheckViewController *)rootViewController.presentedViewController;

    //取到顶层navigation控制器
    UIViewController *topNavController = [lineCheckViewController.rootNav.viewControllers lastObject];
    //如果有push的VC先pop到首页控制器
    [topNavController.navigationController popToRootViewControllerAnimated:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //取到首页控制器
        UIViewController *homeViewVC = [lineCheckViewController.rootNav.viewControllers firstObject];
        if (homeViewVC.presentedViewController) {
            //如果顶层nav有present的控制器
            //则取顶层present控制器
            UIViewController *topPresentedViewController = [self fetchTopLevelPresentedController:homeViewVC.presentedViewController];
            if (complete) {
                complete(topPresentedViewController);
            }
        }
        else
        {
            if (complete) {
                complete(homeViewVC);
            }
        }
    });
}

//递归查找顶层present控制器
+ (UIViewController *)fetchTopLevelPresentedController:(UIViewController *)rootVC
{
    if (rootVC.presentedViewController) {
        return [self fetchTopLevelPresentedController:rootVC.presentedViewController];
    }
    else
    {
        return rootVC;
    }
}

@end
