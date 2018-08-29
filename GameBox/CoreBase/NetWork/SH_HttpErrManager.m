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
#import "SH_NoAccessViewController.h"
#import "SH_BigWindowViewController.h"
#import "SH_TopLevelControllerManager.h"
#import "SH_MaintainViewController.h"
#import "SH_HomeViewController.h"
@interface SH_HttpErrManager ()

@end

@implementation SH_HttpErrManager

+ (void)dealWithErrCode:(int)code
{
    if (code == SH_API_ERRORCODE_600 ||
        code == SH_API_ERRORCODE_606 ||
        code == SH_API_ERRORCODE_1001) {
        
        id topVC = [SH_TopLevelControllerManager fetchTopLevelController];
        
        if ([topVC isMemberOfClass:[SH_BigWindowViewController class]]) {
            NSString *title = ((SH_BigWindowViewController *)topVC).titleImageName;
            if ([title isEqualToString:@"title01"] || [title isEqualToString:@"title02"]) {
                //已经展示了登录页面 则不再展示
                return;
            };
        }
        //先调用退出通知
        [[NSNotificationCenter  defaultCenter] postNotificationName:@"didLogOut" object:nil];
        
        SH_LoginView *login = [SH_LoginView InstanceLoginView];
        
        SH_BigWindowViewController *cvc = [[SH_BigWindowViewController alloc] initWithNibName:@"SH_BigWindowViewController" bundle:nil];
        cvc.titleImageName = @"title01";
        cvc.customView = login;
        cvc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        cvc.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
        login.dismissBlock = ^{
            [cvc  close:nil];
        };
        login.changeChannelBlock = ^(NSString *string) {
            cvc.titleImageName = string;
        };
        
        [topVC presentViewController:cvc animated:NO completion:nil];
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
        SH_NoAccessViewController *vc = [[SH_NoAccessViewController alloc] initWithNibName:@"SH_NoAccessViewController" bundle:nil];
        [topNavController.navigationController pushViewController:vc animated:NO];
    }
    else if (code == SH_API_ERRORCODE_607)
    {
        //ip被限制
        UINavigationController *rootViewController = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        LineCheckViewController *lineCheckViewController = (LineCheckViewController *)rootViewController.presentedViewController;
        
        //取到顶层navigation控制器
        UIViewController *topNavController = [lineCheckViewController.rootNav.viewControllers lastObject];
        SH_MaintainViewController *vc = [[SH_MaintainViewController alloc] initWithNibName:@"SH_MaintainViewController" bundle:nil];
        [topNavController.navigationController pushViewController:vc animated:NO];
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

@end
