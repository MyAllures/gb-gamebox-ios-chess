//
//  SH_PromoWindowViewController.m
//  GameBox
//
//  Created by shin on 2018/7/25.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_PromoWindowViewController.h"
#import "SH_MsgCenterView.h"
#import "SH_PromoDeatilViewController.h"
#import "SH_WebPButton.h"
#import "SH_MsgCenterDetailView.h"
#import "SH_PromoActivitiesView.h"
#import "SH_BigWindowViewController.h"
#import "SH_SmallWindowViewController.h"
@interface SH_PromoWindowViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet SH_WebPButton *promoTypeBt;
@property (weak, nonatomic) IBOutlet SH_WebPButton *msgTypeBt;

@property (strong, nonatomic) SH_MsgCenterView *msgCenterView;
@property(nonatomic,strong)SH_PromoActivitiesView *promoActivitiseView;

@end

@implementation SH_PromoWindowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.promoTypeBt setWebpBGImage:@"title15nw" forState:UIControlStateNormal];
    [self.promoTypeBt setWebpBGImage:@"btn_activity" forState:UIControlStateSelected];
    [self.msgTypeBt setWebpBGImage:@"title16nw" forState:UIControlStateNormal];
    [self.msgTypeBt setWebpBGImage:@"btn_news" forState:UIControlStateSelected];
    self.promoTypeBt.selected = YES;
    
    [self promoTypeSelected:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            SH_SmallWindowViewController * acr = [SH_SmallWindowViewController new];
            acr.customView = view;
            acr.titleImageName = @"title03";
            acr.contentHeight = 200;
            acr.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            acr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [weakSelf presentViewController:acr animated:YES completion:nil];
            [view dismiss:^{
                [acr dismissViewControllerAnimated:NO completion:nil];
                [self->_msgCenterView  fetchHttpData];
            }];
            [acr close:^{
                 [self->_msgCenterView  fetchHttpData];
            }];
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
    self.promoActivitiseView.hidden = NO;
    self.msgCenterView.hidden = YES;
}

- (IBAction)msgTypeSelect:(id)sender {
    self.promoTypeBt.selected = NO;
    self.msgTypeBt.selected = YES;
     self.promoActivitiseView.hidden = YES;
    self.msgCenterView.hidden = NO;
    [self.msgCenterView reloadData];
}


@end
