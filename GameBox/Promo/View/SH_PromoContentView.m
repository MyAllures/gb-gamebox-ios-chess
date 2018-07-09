//
//  SH_PromoContentView.m
//  GameBox
//
//  Created by shin on 2018/7/9.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_PromoContentView.h"
#import "SH_PromoListView.h"
#import "SH_InfoCenterTabView.h"
#import <Masonry/Masonry.h>

@interface SH_PromoContentView ()
@property (weak, nonatomic) IBOutlet UIButton *promoBT;
@property (weak, nonatomic) IBOutlet UIButton *infoCenterBT;
@property (weak, nonatomic) IBOutlet UIView *rightContentView;

@property (nonatomic, strong) SH_PromoListView *promoListView;
@property (nonatomic, strong) SH_InfoCenterTabView *infoCenterTabView;

@end

@implementation SH_PromoContentView

- (IBAction)btClick:(id)sender {
    UIButton *bt = (UIButton *)sender;
    if (bt == self.promoBT) {
        self.promoBT.selected = YES;
        self.infoCenterBT.selected = NO;
        self.promoListView.hidden = NO;
        [self.promoListView reloadData];
        self.infoCenterTabView.hidden = YES;
    }
    else if (bt == self.infoCenterBT)
    {
        self.promoBT.selected = NO;
        self.infoCenterBT.selected = YES;
        self.promoListView.hidden = YES;
        self.infoCenterTabView.hidden = NO;
    }
}

- (SH_PromoListView *)promoListView
{
    if (_promoListView == nil) {
        _promoListView = [[[NSBundle mainBundle] loadNibNamed:@"SH_PromoListView" owner:nil options:nil] lastObject];
        [self.rightContentView addSubview:_promoListView];
        [_promoListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
    }
    return _promoListView;
}

- (SH_InfoCenterTabView *)infoCenterTabView
{
    if (_infoCenterTabView == nil) {
        _infoCenterTabView = [[[NSBundle mainBundle] loadNibNamed:@"SH_InfoCenterTabView" owner:nil options:nil] lastObject];
        [self.rightContentView addSubview:_infoCenterTabView];
        [_infoCenterTabView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
    }
    return _infoCenterTabView;
}

@end
