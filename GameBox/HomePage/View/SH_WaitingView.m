//
//  SH_WaitingView.m
//  GameBox
//
//  Created by shin on 2018/7/29.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_WaitingView.h"
#import "UIImage+SH_WebPImage.h"

@interface SH_WaitingView ()

@property (weak, nonatomic) IBOutlet SH_WebPImageView *animationImg;
@property (weak, nonatomic) IBOutlet SH_WebPImageView *circleImg;

@end

@implementation SH_WaitingView

+ (void)showOn:(UIView *)view
{
    SH_WaitingView *waitingView = [[[NSBundle mainBundle] loadNibNamed:@"SH_WaitingView" owner:nil options:nil] lastObject];
    [waitingView runAnimation];
    [view addSubview:waitingView];
    
    [waitingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
}

+ (void)hide:(UIView *)view
{
    SH_WaitingView *waitingView = [self waitingViewIn:view];
    [waitingView stopAnimation];
    if (waitingView) {
        [waitingView removeFromSuperview];
    }
}

+ (SH_WaitingView *)waitingViewIn:(UIView *)view
{
    for (id subView in view.subviews) {
        if ([subView isMemberOfClass:[SH_WaitingView class]]) {
            return subView;
        }
    }
    return nil;
}

- (void)runAnimation
{
    NSArray *images=[NSArray arrayWithObjects:[UIImage imageWithWebPImageName:@"loading-1"],[UIImage imageWithWebPImageName:@"loading-2"],[UIImage imageWithWebPImageName:@"loading-3"],[UIImage imageWithWebPImageName:@"loading-4"], nil];
    self.animationImg.animationImages = images;
    self.animationImg.contentMode = UIViewContentModeScaleAspectFit;
    self.animationImg.animationDuration = 0.9;
    self.animationImg.animationRepeatCount = 0;
    [self.animationImg startAnimating];
    
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 3.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    [self.circleImg.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopAnimation
{
    [self.animationImg stopAnimating];
    [self.circleImg.layer removeAllAnimations];
}

@end
