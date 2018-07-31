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

//@property (nonatomic, assign) BOOL isShowingLoginWindow;//已经弹出登录框

@end

@implementation SH_HttpErrManager

//+ (instancetype)sharedManager
//{
//    static SH_HttpErrManager *manager = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        if (manager == nil) {
//            manager = [[SH_HttpErrManager alloc] init];
//        }
//    });
//    return manager;
//}

+ (void)dealWithErrCode:(int)code
{
    SH_LoginView *login = [SH_LoginView InstanceLoginView];
    AlertViewController * cvc = [[AlertViewController  alloc] initAlertView:login viewHeight:[UIScreen mainScreen].bounds.size.height-60 titleImageName:@"title01" alertViewType:AlertViewTypeLong];
    cvc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    cvc.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    login.targetVC = cvc;
    login.dismissBlock = ^{
        [cvc  close];
//        [self  configUI];
    };
    login.changeChannelBlock = ^(NSString *string) {
        [cvc setImageName:string];
    };
    login.loginSuccessBlock = ^{
        //登录成功后每5分钟调用一次保活接口
//        [weakSelf keepAlive];
    };
    
    UIViewController *topVC = [self fetchTopLevelController];
    [topVC presentViewController:cvc animated:NO completion:nil];
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
