//
//  SH_BaseViewController.m
//  GameBox
//
//  Created by shin on 2018/7/5.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_BaseViewController.h"
#import "AppDelegate.h"

@interface SH_BaseViewController ()

@property (nonatomic, assign) UIInterfaceOrientationMask orientationMask;
@end

@implementation SH_BaseViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    UIInterfaceOrientationMask mask = [self orientation];
//    if (mask == UIInterfaceOrientationMaskLandscape) {
//        [self forceOrientationLandscape];
//    }
//    else if (mask == UIInterfaceOrientationMaskPortrait)
//    {
//        [self forceOrientationPortrait];
//    }
//    else if (mask == UIInterfaceOrientationMaskAll)
//    {
//        [self refreshOrientationAll];
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
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
    //这种方法，只能旋转屏幕不能达到强制横屏的效果
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationLandscapeLeft;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    //加上代理类里的方法，旋转屏幕可以达到强制横屏的效果
    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.forceLandscape=YES;
    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
    
}
/**
 *  强制竖屏
 */
-(void)forceOrientationPortrait{
    //加上代理类里的方法，旋转屏幕可以达到强制竖屏的效果
    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.forcePortrait=YES;
    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
}


/**
 * 调整为全方向
 */
- (void)refreshOrientationAll
{
    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.forceLandscape = NO;
    appdelegate.forcePortrait = NO;
    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
    //退出界面前恢复竖屏
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationMaskAll;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (void)refreshOrientationPortrait
{
    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.forceLandscape = NO;
    appdelegate.forcePortrait=NO;
    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
    //退出界面前恢复竖屏
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

@end
