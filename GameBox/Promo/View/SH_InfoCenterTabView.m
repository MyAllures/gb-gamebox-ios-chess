//
//  SH_InfoCenterTabBView.m
//  GameBox
//
//  Created by shin on 2018/7/9.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_InfoCenterTabView.h"
#import <Masonry/Masonry.h>
#import "SH_GameAnnouncementView.h"
#import "SH_SystemNotification.h"
#import "SH_SiteMsgView.h"

#define screenH [UIScreen mainScreen].bounds.size.height
#define screenW [UIScreen mainScreen].bounds.size.width

@interface SH_InfoCenterTabView()
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (strong, nonatomic) SH_GameAnnouncementView *gameAnnouncementView;
@property (strong, nonatomic) SH_SystemNotification *systemNotification;
@property (strong, nonatomic) SH_SiteMsgView *siteMsgView;
@end

@implementation SH_InfoCenterTabView

- (IBAction)tabBtn:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 0) {
        self.btn1.selected = YES;
        self.btn2.selected = NO;
        self.btn3.selected = NO;
        self.gameAnnouncementView.hidden = NO;
        self.systemNotification.hidden = YES;
        self.siteMsgView.hidden = YES;
    } else if (btn.tag == 1) {
        self.btn1.selected = NO;
        self.btn2.selected = YES;
        self.btn3.selected = NO;
        self.gameAnnouncementView.hidden = YES;
        self.systemNotification.hidden = NO;
        self.siteMsgView.hidden = YES;
    } else if (btn.tag == 2) {
        self.btn1.selected = NO;
        self.btn2.selected = NO;
        self.btn3.selected = YES;
        self.gameAnnouncementView.hidden = YES;
        self.systemNotification.hidden = YES;
        self.siteMsgView.hidden = NO;
    }
}


-(void)awakeFromNib {
    [super awakeFromNib];
    self.gameAnnouncementView.hidden = NO;
    self.systemNotification.hidden = YES;
    self.backgroundColor = [UIColor colorWithRed:0.15 green:0.19 blue:0.44 alpha:1];
    self.bottomView.backgroundColor = [UIColor colorWithRed:0.15 green:0.19 blue:0.44 alpha:1];
    self.btn1.selected = YES;
    NSInteger width = screenW - 465;
    [self.btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo((screenW-81*3-width-135)/4);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(81);
        make.height.mas_equalTo(32);
    }];
    [self.btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btn1).with.offset((screenW-81*3-width-135)/4+81);
//        make.left.mas_equalTo((screenW-81*3)/4*2+81);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(81);
        make.height.mas_equalTo(32);
    }];
    [self.btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo((screenW-81*3)/4*3+81);
        make.left.equalTo(self.btn2).with.offset((screenW-81*3-width-135)/4+81);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(81);
        make.height.mas_equalTo(32);
    }];
}

-(SH_GameAnnouncementView *)gameAnnouncementView {
    
    if (_gameAnnouncementView == nil) {
        _gameAnnouncementView = [[[NSBundle mainBundle] loadNibNamed:@"SH_GameAnnouncementView" owner:nil options:nil] lastObject];
        [self.bottomView addSubview:_gameAnnouncementView];
        [_gameAnnouncementView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.bottom.mas_equalTo(-10);
        }];
    }
    return _gameAnnouncementView;
}

-(SH_SystemNotification *)systemNotification {
    
    if (_systemNotification == nil) {
        _systemNotification = [[[NSBundle mainBundle] loadNibNamed:@"SH_SystemNotification" owner:nil options:nil] lastObject];
        [self.bottomView addSubview:_systemNotification];
        [_systemNotification mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.bottom.mas_equalTo(-10);
        }];
    }
    return _systemNotification;
}

-(SH_SiteMsgView *)siteMsgView {
    if (_siteMsgView == nil) {
        _siteMsgView = [[[NSBundle mainBundle] loadNibNamed:@"SH_SiteMsgView" owner:nil options:nil] lastObject];
        [self.bottomView addSubview:_siteMsgView];
        [_siteMsgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.bottom.mas_equalTo(-10);
        }];
    }
    return _siteMsgView;
}
-(void)setAlertVC:(AlertViewController *)alertVC{
    _alertVC = alertVC;
    self.systemNotification.alertVC = alertVC;
    self.gameAnnouncementView.alertVC = alertVC;
}
@end
