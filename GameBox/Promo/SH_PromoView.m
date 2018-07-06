//
//  SH_PromoView.m
//  GameBox
//
//  Created by sam on 2018/7/6.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_PromoView.h"
#import "View+MASAdditions.h"

@interface SH_PromoView()
@property (nonatomic,strong) UIView *leftView;
@property (nonatomic,strong) UIView *rightView;
@end

@implementation SH_PromoView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    self.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, self.frame.size.height)];
//        [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self);
//            make.top.equalTo(self).with.offset(40);
//            make.width.equalTo(@185);
//            make.height.equalTo(@538);
//        }];
    self.leftView.backgroundColor = [UIColor redColor];
    [self addSubview:self.leftView];
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.leftView addSubview:btn1];
    [btn1 setTitle:@"优惠活动" forState:UIControlStateNormal];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.leftView);
        make.top.equalTo(self.leftView).with.offset(40);
        make.width.equalTo(@185);
        make.height.equalTo(@58);
    }];
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.leftView addSubview:btn2];
    [btn2 setTitle:@"消息中心" forState:UIControlStateNormal];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.leftView);
        make.top.equalTo(self.leftView).with.offset(108);
        make.width.equalTo(@185);
        make.height.equalTo(@58);
    }];
    
}


@end
