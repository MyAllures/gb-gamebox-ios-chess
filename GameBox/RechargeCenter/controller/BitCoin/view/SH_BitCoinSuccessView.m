//
//  SH_BitCoinSuccessView.m
//  GameBox
//
//  Created by jun on 2018/7/12.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_BitCoinSuccessView.h"
#import "SH_BitCoinSuccessPopView.h"
@interface SH_BitCoinSuccessView()<SH_BitCoinSuccessPopViewDelegate>
@property(nonatomic,strong)SH_BitCoinSuccessPopView *popView;
@end
@implementation SH_BitCoinSuccessView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}
#pragma mark--
#pragma mark--lazy
- (SH_BitCoinSuccessPopView *)popView{
    if (!_popView) {
       _popView = [[NSBundle mainBundle]loadNibNamed:@"SH_BitCoinSuccessPopView" owner:self options:nil].firstObject;
        _popView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        _popView.delegate = self;
        [self addSubview:_popView];
    }
    return _popView;
}
-(void)configUI{
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.5;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(screenSize().width*3/5));
        make.height.equalTo(@(screenSize().width*4/5));
        make.center.equalTo(self);
    }];
}
-(void)popViewShow{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:1 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.popView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.2 animations:^{
        self.popView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}
- (void)setTargetVC:(UIViewController *)targetVC{
    _targetVC = targetVC;
}
#pragma mark--
#pragma mark-- popViewDelegate
- (void)SH_BitCoinSuccessPopViewTryAgainBtnClick{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      [self.targetVC.navigationController popViewControllerAnimated:YES];
    });
    
}
@end
