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

#define screenH [UIScreen mainScreen].bounds.size.height
#define screenW [UIScreen mainScreen].bounds.size.width

@interface SH_InfoCenterTabView()
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (strong, nonatomic) SH_GameAnnouncementView *gameAnnouncementView;
@end

@implementation SH_InfoCenterTabView

-(void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithRed:0.15 green:0.19 blue:0.44 alpha:1];
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
    [self gameAnnouncementView];
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

@end
