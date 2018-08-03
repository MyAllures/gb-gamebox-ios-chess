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
