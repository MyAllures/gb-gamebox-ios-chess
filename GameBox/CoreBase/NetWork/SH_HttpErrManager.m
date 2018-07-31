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

@interface SH_HttpErrManager ()

@end

@implementation SH_HttpErrManager

+ (void)dealWithErrCode:(int)code
{
    if (code == SH_API_ERRORCODE_SESSION_EXPIRED ||
        code == SH_API_ERRORCODE_SESSION_TAKEOUT ||
        code == SH_API_ERRORCODE_USER_NERVER_LOGIN) {
        
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
        
        UIViewController *topVC = [self fetchTopLevelController];
        [topVC presentViewController:cvc animated:NO completion:nil];
    }
}

//获取顶层视图控制器
+ (UIViewController *)fetchTopLevelController
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
