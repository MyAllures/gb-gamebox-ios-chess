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

#define screenH [UIScreen mainScreen].bounds.size.height
#define screenW [UIScreen mainScreen].bounds.size.width

@interface SH_InfoCenterTabView()
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (strong, nonatomic) SH_GameAnnouncementView *gameAnnouncementView;
@property (strong, nonatomic) SH_SystemNotification *systemNotification;
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
    } else if (btn.tag == 1) {
        self.btn1.selected = NO;
        self.btn2.selected = YES;
        self.btn3.selected = NO;
        self.gameAnnouncementView.hidden = YES;
        self.systemNotification.hidden = NO;
    } else if (btn.tag == 2) {
        self.btn1.selected = NO;
        self.btn2.selected = NO;
        self.btn3.selected = YES;
        self.gameAnnouncementView.hidden = YES;
        self.systemNotification.hidden = YES;
    }
}


-(void)awakeFromNib {
    [super awakeFromNib];
    self.gameAnnouncementView.hidden = NO;
    self.systemNotification.hidden = YES;
    self.backgroundColor = [UIColor colorWithRed:0.15 green:0.19 blue:0.44 alpha:1];
    self.btn1.selected = YES;
    [self.btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo((self.frame.size.width-81*3)/4);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(81);
        make.height.mas_equalTo(32);
    }];
    [self.btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btn1).with.offset((self.frame.size.width-81*3)/4);
//        make.left.mas_equalTo((self.frame.size.width-81*3)/4*2+81);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(81);
        make.height.mas_equalTo(32);
    }];
    [self.btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo((self.frame.size.width-81*3)/4*3+81);
        make.left.equalTo(self.btn2).with.offset((self.frame.size.width-81*3)/4);
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
            make.top.left.right.bottom.mas_equalTo(0);
        }];
    }
    return _gameAnnouncementView;
}

-(SH_SystemNotification *)systemNotification {
    
    if (_systemNotification == nil) {
        _systemNotification = [[[NSBundle mainBundle] loadNibNamed:@"SH_SystemNotification" owner:nil options:nil] lastObject];
        [self.bottomView addSubview:_systemNotification];
        [_systemNotification mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.mas_equalTo(0);
        }];
    }
    return _systemNotification;
}

@end
