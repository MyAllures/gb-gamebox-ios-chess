//
//  SH_PreferentialPopView.m
//  GameBox
//
//  Created by jun on 2018/7/12.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_PreferentialPopView.h"
#import "SH_PreferentialPopSubView.h"
@interface SH_PreferentialPopView()<SH_PreferentialPopSubViewDelegate>
@property(nonatomic,strong)SH_PreferentialPopSubView *popSubView;
@end
@implementation SH_PreferentialPopView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}
#pragma mark--
#pragma mark--lazy
- (SH_PreferentialPopSubView *)popSubView{
    if (!_popSubView) {
        _popSubView = [[NSBundle mainBundle]loadNibNamed:@"SH_PreferentialPopSubView" owner:self options:nil].firstObject;
        _popSubView.delegate = self;
        [self addSubview:_popSubView];
    }
    return _popSubView;
}
-(void)configUI{
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.5;
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    [self.popSubView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@300);
        make.height.equalTo(@360);
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_top);
    }];
}
-(void)popViewShow{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:1 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.popSubView.transform = CGAffineTransformMakeTranslation(0, screenSize().height/2.0+180);
    } completion:^(BOOL finished) {
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.6 animations:^{
        self.popSubView.center = CGPointMake(self.center.x, screenSize().height+200);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

}
-(void)updateUIWithSaleModel:(SH_BitCoinSaleModel *)model Money:(NSString *)money{
    [self.popSubView updateUIWithSaleModel:model moneyString:money];
}
#pragma mark--
#pragma mark--popSubView 代理
- (void)selectedActivityId:(NSString *)activityId{
    //选中某一个ID
    [self.delegate popViewSelectedActivityId:activityId];
}
@end
