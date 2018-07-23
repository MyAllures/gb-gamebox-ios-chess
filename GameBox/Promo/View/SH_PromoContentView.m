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
#import "SH_WebPButton.h"

@interface SH_PromoContentView ()
@property (weak, nonatomic) IBOutlet SH_WebPButton *promoBT;
@property (weak, nonatomic) IBOutlet SH_WebPButton *infoCenterBT;
@property (weak, nonatomic) IBOutlet UIView *rightContentView;

@property (nonatomic, strong) SH_PromoListView *promoListView;
@property (nonatomic, strong) SH_InfoCenterTabView *infoCenterTabView;
@property (nonatomic, copy) SH_PromoContentViewShowDetail showBlock;

@end

@implementation SH_PromoContentView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPromoDetailView:) name:@"SH_Show_PromoDeatil" object:nil];

    self.rightContentView.backgroundColor = [UIColor colorWithRed:0.15 green:0.19 blue:0.44 alpha:1];
    [self.promoListView reloadData];
    self.promoBT.selected = YES;
    self.promoListView.hidden = NO;
    self.infoCenterTabView.hidden = YES;
}

- (void)showPromoDetail:(SH_PromoContentViewShowDetail)showBlock
{
    self.showBlock = showBlock;
}

- (IBAction)btClick:(id)sender {
    UIButton *bt = (UIButton *)sender;
    if (bt == self.promoBT) {
        self.promoBT.selected = YES;
        [self.promoBT setWebpBGImage:@"button-long-click" forState:UIControlStateNormal];
        [self.infoCenterBT setWebpBGImage:@"button-long" forState:UIControlStateNormal];
        self.infoCenterBT.selected = NO;
        self.promoListView.hidden = NO;
        self.infoCenterTabView.hidden = YES;
    }
    else if (bt == self.infoCenterBT)
    {
        self.promoBT.selected = NO;
        self.infoCenterBT.selected = YES;
        [self.promoBT setWebpBGImage:@"button-long" forState:UIControlStateNormal];
        [self.infoCenterBT setWebpBGImage:@"button-long-click" forState:UIControlStateNormal];
        self.promoListView.hidden = YES;
        self.infoCenterTabView.hidden = NO;
    }
}

- (SH_PromoListView *)promoListView
{
    if (_promoListView == nil) {
        _promoListView = [[[NSBundle mainBundle] loadNibNamed:@"SH_PromoListView" owner:nil options:nil] lastObject];
        _promoListView.backgroundColor = [UIColor clearColor];
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

- (void)showPromoDetailView:(NSNotification *)notification
{
    SH_PromoListModel *model = notification.object;

    if (self.showBlock) {
        self.showBlock(model);
    }
}

-(void)setAlertVC:(AlertViewController *)alertVC{
    _alertVC = alertVC;
    self.infoCenterTabView.alertVC = self.alertVC;
}
@end
