//
//  SH_PromoWindowViewController.m
//  GameBox
//
//  Created by shin on 2018/7/25.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_PromoWindowViewController.h"
#import "SH_PromoListView.h"
#import "SH_MsgCenterView.h"
#import "SH_PromoDeatilViewController.h"
#import "SH_WebPButton.h"
#import "SH_MsgCenterDetailView.h"
#import "AlertViewController.h"
#import "SH_PromoActivitiesView.h"

@interface SH_PromoWindowViewController () <SH_PromoListViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet SH_WebPButton *promoTypeBt;
@property (weak, nonatomic) IBOutlet SH_WebPButton *msgTypeBt;

@property (strong, nonatomic) SH_PromoListView *promoListView;
@property (strong, nonatomic) SH_MsgCenterView *msgCenterView;
@property(nonatomic,strong)SH_PromoActivitiesView *promoActivitiseView;

@end

@implementation SH_PromoWindowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.promoTypeBt setWebpBGImage:@"title15nw" forState:UIControlStateNormal];
    [self.promoTypeBt setWebpBGImage:@"btn-activity" forState:UIControlStateSelected];
    [self.msgTypeBt setWebpBGImage:@"title16nw" forState:UIControlStateNormal];
    [self.msgTypeBt setWebpBGImage:@"btn-news" forState:UIControlStateSelected];
    self.promoTypeBt.selected = YES;
    
    [self promoTypeSelected:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (SH_PromoListView *)promoListView
{
    if (_promoListView == nil) {
        _promoListView = [[[NSBundle mainBundle] loadNibNamed:@"SH_PromoListView" owner:nil options:nil] lastObject];
        _promoListView.delegate = self;
        [self.contentView addSubview:_promoListView];
        [_promoListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _promoListView;
}

- (SH_PromoActivitiesView *)promoActivitiseView{
    if (!_promoActivitiseView) {
        _promoActivitiseView = [[NSBundle mainBundle]loadNibNamed:@"SH_PromoActivitiesView" owner:self options:nil].firstObject;
        [self.contentView addSubview:_promoActivitiseView];
        [_promoActivitiseView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _promoActivitiseView;
}

- (SH_MsgCenterView *)msgCenterView
{
    __weak typeof(self) weakSelf = self;

    if (_msgCenterView == nil) {
        _msgCenterView = [[[NSBundle mainBundle] loadNibNamed:@"SH_MsgCenterView" owner:nil options:nil] lastObject];
        [self.contentView addSubview:_msgCenterView];
        [_msgCenterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        [_msgCenterView showDetail:^(NSString *content) {
            SH_MsgCenterDetailView *view = [[[NSBundle mainBundle]loadNibNamed:@"SH_MsgCenterDetailView" owner:nil options:nil] lastObject];
            view.content = content;
            AlertViewController *acr  = [[AlertViewController alloc] initAlertView:view viewHeight:200 titleImageName:@"title03" alertViewType:AlertViewTypeShort];
            acr.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            acr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [weakSelf presentViewController:acr animated:YES completion:nil];
            [view dismiss:^{
                [acr dismissViewControllerAnimated:NO completion:nil];
                [self->_msgCenterView  fetchHttpData];
            }];
            acr.dismissBlock = ^{
                 [self->_msgCenterView  fetchHttpData];
            };
        }];
    }
    return _msgCenterView;
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)promoTypeSelected:(id)sender {
    self.promoTypeBt.selected = YES;
    self.msgTypeBt.selected = NO;
//    self.promoListView.hidden = NO;
    self.promoActivitiseView.hidden = NO;
    self.msgCenterView.hidden = YES;
//    [self.promoListView reloadData];
}

- (IBAction)msgTypeSelect:(id)sender {
    self.promoTypeBt.selected = NO;
    self.msgTypeBt.selected = YES;
//    self.promoListView.hidden = YES;
     self.promoActivitiseView.hidden = YES;
    self.msgCenterView.hidden = NO;
    [self.msgCenterView reloadData];
}

#pragma mark - SH_PromoListViewDelegate M

- (void)promoListView:(SH_PromoListView *)view didSelect:(SH_PromoListModel *)model
{
    SH_PromoDeatilViewController *vc = [[SH_PromoDeatilViewController alloc] initWithNibName:@"SH_PromoDeatilViewController" bundle:nil];
    vc.model = model;
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
}

@end
