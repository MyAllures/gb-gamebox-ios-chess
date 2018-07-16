//
//  PopTool.m
//  GameBox
//
//  Created by Paul on 2018/7/6.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "PopTool.h"
#import "AlertViewController.h"
#import  <Masonry.h>

@interface  PopTool()
@property (strong, nonatomic) UIViewController *contentViewController;
@property (strong, nonatomic)AlertViewController * alertController;
@property (nonatomic, assign) NSTimeInterval animationDuration;// 动画持续时间
@property (nonatomic, assign) AnimationDirection animationDirection;// 动画方向
@end
@implementation PopTool
+(PopTool *)sharedInstance{
    static PopTool * shareClient= nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareClient = [[PopTool  alloc] init];
    });
    return  shareClient;
}
-(instancetype)init{
    if (self = [super init]) {
        _animationDuration = 0.35;
    }
    return  self;
}
-(void)showWithPresentView:(UIView *)presentView withWidth:(CGFloat)width withHeight:(CGFloat)height subTitle:(NSString *)subTitle AnimatedType:(AnimationType)animatedType AnimationDirectionType:(AnimationDirection)animationDirectionType {
    _animationDirection = animationDirectionType;
//    self.alertController = [[AlertViewController  alloc] initAlertView:presentView viewHeight:height viewWidth:width titleImageName:@""];
//    self.alertController.subTitle = subTitle;
    /*
    __weak  typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
//        weakSelf.alertController.constraintLeading.constant = leading;
//        weakSelf.alertController.constraintTop.constant = top;
        [weakSelf.alertController.view layoutIfNeeded];
    });
    
    UIWindow * window = [UIApplication  sharedApplication].keyWindow;*/
    UIViewController * vc = [self  getCurrentVC];
    [vc.view addSubview:self.alertController.view];
    [self.alertController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(vc.view);
    }];
    /*
    [self.alertController.containerView addSubview:presentView];
    [presentView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.edges.mas_equalTo(self.alertController.containerView);
    }];*/
    switch (animatedType) {
        case AnimationTypeNone:{
            
            break;
        }
        case AnimationTypeScale:{
//            [self  scaleAnimationWithView:self.alertController.animationView];
            [self largenAnimationWithView:self.alertController.animationView];
            break;
        }
        case AnimationTypePosition:{
            [self transformationAnimationWithView:self.alertController.animationView];
            break;
            
        }
        case AnimationTypeFade:{
            [self  fadeAnimationWithView:self.alertController.animationView];
            break;
        }
        default:
            break;
    }
}
#pragma mark -- 关闭弹窗
-(void)closePopView{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.animationDirection == AnimationDirectionFromCenter) {
            [UIView animateWithDuration:0.2 animations:^{
                self.alertController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.25 animations:^{
                    self.alertController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
                } completion:^(BOOL finished) {
                    [ self.alertController.view removeFromSuperview];
                    self.alertController = nil;
                }];
            }];
        }else{
            [UIView animateWithDuration:0.5 animations:^{
                [UIView animateWithDuration:0.15 animations:^{
                    self.alertController.animationView.alpha = 0.8;
                }];
                self.alertController.animationView.layer.shouldRasterize = YES;
                self.alertController.animationView.center = CGPointMake([UIApplication  sharedApplication].keyWindow.center.x,[UIApplication  sharedApplication].keyWindow.center.y+1000);
            } completion:^(BOOL finished) {
                self.alertController.animationView.alpha = 0;
                [self.alertController.view removeFromSuperview];
                self.alertController = nil;
            }];
        }
       
        
    });
}
#pragma mark -- 缩放效果
-(void)scaleAnimationWithView:(UIView*)animationView{
    dispatch_async(dispatch_get_main_queue(), ^{
        // 将view宽高缩至无限小（点）
        self.alertController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, CGFLOAT_MIN, CGFLOAT_MIN);
        [UIView animateWithDuration:0.3 animations:^{
            // 以动画的形式将view慢慢放大至原始大小的1.2倍
            self.alertController.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                // 以动画的形式将view恢复至原始大小
                self.alertController.view.transform = CGAffineTransformIdentity;
            }];
        }];
    });
}
#pragma mark - 变大效果
- (void)largenAnimationWithView:(UIView*)animationView
{
    [self animationDirectionInitialize];
    CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[ [self largenAnimationGroup]];//[self partOfTheAnimationGroupPosition:animationView.center],
    animationGroup.duration = _animationDuration;
    [animationView.layer addAnimation:animationGroup forKey:@"groupAnimation"];
    
}
- (CABasicAnimation *)largenAnimationGroup
{
    CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.duration = _animationDuration;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    return scaleAnimation;
}
#pragma mark - 渐变效果
- (void)fadeAnimationWithView:(UIView*)animationView
{
    [self animationDirectionInitialize];
    CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[ [self fadeAnimationGroup]];//[self partOfTheAnimationGroupPosition:animationView.center],
    animationGroup.duration = _animationDuration;
    [animationView.layer addAnimation:animationGroup forKey:@"groupAnimation"];
    
}

- (CABasicAnimation *)fadeAnimationGroup
{
    CABasicAnimation * fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.toValue = [NSNumber numberWithFloat:1.0];
    fadeAnimation.fromValue = [NSNumber numberWithFloat:0];
    fadeAnimation.duration = _animationDuration;
    
    return fadeAnimation;
}
#pragma mark - 动画方向初始化
- (void)animationDirectionInitialize
{
    if (_animationDirection == AnimationDirectionFromRight) {
        self.alertController.animationView.center = CGPointMake([UIScreen mainScreen].bounds.size.width + 1000, [UIApplication sharedApplication].keyWindow.center.y);
        
    } else if (_animationDirection == AnimationDirectionFromLeft) {
        self.alertController.animationView.center = CGPointMake([UIScreen mainScreen].bounds.size.width - 1000, [UIApplication sharedApplication].keyWindow.center.y);
        
    } else if (_animationDirection == AnimationDirectionFromTop) {
        self.alertController.animationView.center = CGPointMake([UIApplication sharedApplication].keyWindow.center.x, [UIScreen mainScreen].bounds.size.height - 1000);
        
    } else if (_animationDirection == AnimationDirectionFromBottom) {
        self.alertController.animationView.center = CGPointMake([UIApplication sharedApplication].keyWindow.center.x, [UIScreen mainScreen].bounds.size.height + 1000);
        
    } else {
        self.alertController.animationView.center = [UIApplication sharedApplication].keyWindow.center;
    }
    
}

#pragma mark - 动画通用位移
- (CAKeyframeAnimation *)partOfTheAnimationGroupPosition:(CGPoint)startPosition
{
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    NSValue * startValue, * endValue;
    startValue = [NSValue valueWithCGPoint:startPosition];
    endValue = [NSValue valueWithCGPoint:[UIApplication sharedApplication].keyWindow.center];
    animation.values = @[startValue, endValue];
    animation.duration = _animationDuration;
    
    return animation;
}
#pragma mark -- 位移效果
- (void)transformationAnimationWithView:(UIView*)animationView
{
    [self animationDirectionInitialize];
    CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[[self partOfTheAnimationGroupPosition:animationView.center]];
    animationGroup.duration = _animationDuration;
    [animationView.layer addAnimation:animationGroup forKey:@"groupAnimation"];
    
}

//获取当前屏幕显示的viewcontroller
//获取当前屏幕显示的viewcontroller

- (UIViewController *)getCurrentVC

{
    
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    
    
    return currentVC;
    
}



- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC

{
    
    UIViewController *currentVC;
    
    
    
    if ([rootVC presentedViewController]) {
        
        // 视图是被presented出来的
        
        
        
        rootVC = [rootVC presentedViewController];
        
    }
    
    
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        
        // 根视图为UITabBarController
        
        
        
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
        
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        
        // 根视图为UINavigationController
        
        
        
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
        
        
    } else {
        
        // 根视图为非导航类
        
        
        
        currentVC = rootVC;
        
    }
    
    
    
    return currentVC;
    
}
#pragma  mark --- getter methed
/*
-(AlertViewController *)alertController{
    if (!_alertController) {
        __weak typeof(self) weakSelf = self;
        _alertController = [[AlertViewController alloc] init];
        _alertController.dismissBlock = ^{
            [weakSelf  closePopView];
        };
    }
    return _alertController;
}
 */
@end
