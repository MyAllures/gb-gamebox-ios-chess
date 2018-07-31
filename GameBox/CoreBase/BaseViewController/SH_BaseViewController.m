//
//  SH_BaseViewController.m
//  GameBox
//
//  Created by shin on 2018/7/5.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_BaseViewController.h"
#import "AppDelegate.h"
#import "LineCheckViewController.h"

@interface SH_BaseViewController ()

@property (nonatomic, assign) UIInterfaceOrientationMask orientationMask;
@end

@implementation SH_BaseViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIInterfaceOrientationMask mask = [self orientation];
    if (mask == UIInterfaceOrientationMaskLandscape) {
        [self forceOrientationLandscape];
    }
    else if (mask == UIInterfaceOrientationMaskPortrait)
    {
        [self forceOrientationPortrait];
    }
    else if (mask == UIInterfaceOrientationMaskAll)
    {
        [self refreshOrientationAll];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    //如果是竖屏 则退出时强制为横屏
//    UIInterfaceOrientationMask mask = [self orientation];
//    if (mask == UIInterfaceOrientationMaskPortrait || mask == UIInterfaceOrientationMaskAll)
//    {
//        [self forceOrientationLandscape];
//    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    SH_BaseViewController *topVC = (SH_BaseViewController *)[self fetchTopLevelController];
    
    if ([topVC orientation] == UIInterfaceOrientationMaskLandscape) {
        //如果是竖屏 则退出时强制为横屏
        UIInterfaceOrientationMask mask = [self orientation];
        if (mask == UIInterfaceOrientationMaskPortrait || mask == UIInterfaceOrientationMaskAll)
        {
            [self forceOrientationLandscape];
        }

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIInterfaceOrientationMask)orientation
{
    return UIInterfaceOrientationMaskLandscape;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - supportedInterfaceOrientations M

/**
 *  强制横屏
 */
-(void)forceOrientationLandscape{
    UIInterfaceOrientation oriention = [UIApplication sharedApplication].statusBarOrientation;
    if (oriention != UIInterfaceOrientationLandscapeLeft && oriention != UIInterfaceOrientationLandscapeRight) {
        oriention = UIInterfaceOrientationLandscapeLeft;
    }

    NSNumber *orientationNumber = [NSNumber numberWithInt:oriention];
    [[UIDevice currentDevice] setValue:orientationNumber forKey:@"orientation"];

    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.forcePortrait = NO;
    appdelegate.forceLandscape = YES;
    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];

    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = oriention;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

/**
 *  强制竖屏
 */
-(void)forceOrientationPortrait{
    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.forcePortrait = YES;
    appdelegate.forceLandscape = NO;
    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];

    NSNumber *orientationNumber = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:orientationNumber forKey:@"orientation"];
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}


/**
 * 调整为全方向
 */
- (void)refreshOrientationAll
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationMaskAll;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }

    NSNumber *orientationNumber = [NSNumber numberWithInt:UIInterfaceOrientationMaskAll];
    [[UIDevice currentDevice] setValue:orientationNumber forKey:@"orientation"];

    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.forceLandscape = NO;
    appdelegate.forcePortrait = NO;
    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
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
@end
