//
//  SH_SaftyCenterView.m
//  GameBox
//
//  Created by jun on 2018/7/17.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_SaftyCenterView.h"
#import "SH_ModifyLoginPSDView.h"
#import "SH_ModiftSaftyPSDView.h"
#import "SH_BankCardView.h"
@interface SH_SaftyCenterView()
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *saftyBtn;
@property (weak, nonatomic) IBOutlet UIButton *bankBtn;
@property(nonatomic,strong)SH_ModifyLoginPSDView *loginView;
@property(nonatomic,strong)SH_ModiftSaftyPSDView *saftyView;
@property(nonatomic,strong)SH_BankCardView *bankView;

@end
@implementation SH_SaftyCenterView
- (void)awakeFromNib{
    [super awakeFromNib];
    [self configUI];
    self.loginView.hidden = NO;
    self.saftyView.hidden = YES;
    self.bankView.hidden = YES;
   
}
#pragma mark--
#pragma mark--lazy
- (SH_ModifyLoginPSDView *)loginView{
    if (!_loginView) {
        _loginView = [[NSBundle mainBundle]loadNibNamed:@"SH_ModifyLoginPSDView" owner:self options:nil].firstObject;
        [self addSubview:_loginView];
    }
    return _loginView;
}
- (SH_ModiftSaftyPSDView *)saftyView{
    if (!_saftyView) {
        _saftyView = [[NSBundle mainBundle]loadNibNamed:@"SH_ModiftSaftyPSDView" owner:self options:nil].firstObject;
        [self addSubview:_saftyView];
    }
    return _saftyView;
}
- (SH_BankCardView *)bankView{
    if (!_bankView) {
        _bankView = [[NSBundle mainBundle]loadNibNamed:@"SH_BankCardView" owner:self options:nil].firstObject;
        [self addSubview:_bankView];
    }
    return _bankView;
}
- (IBAction)modifyLoginBtnClick:(id)sender {
    
    [self setButton:self.loginBtn BackgroundImage:@"button-long-click"];
    [self setButton:self.saftyBtn BackgroundImage:@"button-long"];
    [self setButton:self.bankBtn BackgroundImage:@"button-long"];
    self.loginView.hidden = NO;
    self.saftyView.hidden = YES;
    self.bankView.hidden = YES;
}

- (IBAction)saftyBtnclick:(id)sender {
    [self setButton:self.loginBtn BackgroundImage:@"button-long"];
    [self setButton:self.saftyBtn BackgroundImage:@"button-long-click"];
    [self setButton:self.bankBtn BackgroundImage:@"button-long"];
    self.loginView.hidden = YES;
    self.saftyView.hidden = NO;
    self.bankView.hidden = YES;
}
- (IBAction)bankCardBtnClick:(id)sender {
    [self setButton:self.loginBtn BackgroundImage:@"button-long"];
    [self setButton:self.saftyBtn BackgroundImage:@"button-long"];
    [self setButton:self.bankBtn BackgroundImage:@"button-long-click"];
    self.loginView.hidden = YES;
    self.saftyView.hidden = YES;
    self.bankView.hidden = NO;
}
-(void)configUI{
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(145);
        make.bottom.right.equalTo(self).offset(-10);
    }];
    [self.saftyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(145);
        make.bottom.right.equalTo(self).offset(-10);
    }];
    [self.bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(145);
        make.bottom.right.equalTo(self).offset(-10);
    }];
}
-(void)setButton:(UIButton *)button BackgroundImage:(NSString *)image{
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
}
- (void)setTargetVC:(UIViewController *)targetVC{
    _targetVC = targetVC;
    self.loginView.targetVC = targetVC;
    self.saftyView.targetVC = targetVC;
}
- (void)selectedWithType:(NSString *)type{
    if ([type isEqualToString:@"bindBankcard"]) {
        [self bankCardBtnClick:nil];
    }
}
@end
