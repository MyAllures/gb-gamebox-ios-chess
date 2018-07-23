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
#import "SH_NetWorkService+SaftyCenter.h"
#import "RH_UserSafetyCodeModel.h"
#import "SH_BindPhoneNumView.h"
#import "SH_ProfitExchangeView.h"
@interface SH_SaftyCenterView()
@property (weak, nonatomic) IBOutlet SH_WebPButton *loginBtn;
@property (weak, nonatomic) IBOutlet SH_WebPButton *saftyBtn;
@property (weak, nonatomic) IBOutlet SH_WebPButton *bankBtn;
@property(nonatomic,strong)SH_ModifyLoginPSDView *loginView;
@property(nonatomic,strong)SH_ModiftSaftyPSDView *saftyView;
@property(nonatomic,strong)SH_BankCardView *bankView;
@property(nonatomic,copy)NSString *from;//从绑定银行卡跳过来要通知其刷新数据
@property (weak, nonatomic) IBOutlet SH_WebPButton *profitExchangeBtn;
@property (weak, nonatomic) IBOutlet SH_WebPButton *bindPhoneBtn;
@property(nonatomic,strong)SH_BindPhoneNumView *bindPhoneView;
@property(nonatomic,strong)SH_ProfitExchangeView *profitExView;

@end
@implementation SH_SaftyCenterView
- (void)awakeFromNib{
    [super awakeFromNib];
    [self configUI];
    [self setUIWithSelecteBtn:self.loginBtn SelectedView:self.loginView];
   
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

- (SH_BindPhoneNumView *)bindPhoneView{
    if (!_bindPhoneView) {
        _bindPhoneView = [[NSBundle mainBundle]loadNibNamed:@"SH_BindPhoneNumView" owner:self options:nil].firstObject;
        [self addSubview:_bindPhoneView];
    }
    return _bindPhoneView;
}

- (SH_ProfitExchangeView *)profitExView{
    if (!_profitExView) {
        _profitExView = [[NSBundle mainBundle]loadNibNamed:@"SH_ProfitExchangeView" owner:self options:nil].firstObject;
        [self addSubview:_profitExView];
    }
    return _profitExView;
}

- (IBAction)modifyLoginBtnClick:(id)sender {
     [self setUIWithSelecteBtn:self.loginBtn SelectedView:self.loginView];
//    [self setButton:self.loginBtn BackgroundImage:@"button-long-click"];
//    [self setButton:self.saftyBtn BackgroundImage:@"button-long"];
//    [self setButton:self.bankBtn BackgroundImage:@"button-long"];
//    self.loginView.hidden = NO;
//    self.saftyView.hidden = YES;
//    self.bankView.hidden = YES;
}

- (IBAction)saftyBtnclick:(id)sender {
//    [self setButton:self.loginBtn BackgroundImage:@"button-long"];
//    [self setButton:self.saftyBtn BackgroundImage:@"button-long-click"];
//    [self setButton:self.bankBtn BackgroundImage:@"button-long"];
//    self.loginView.hidden = YES;
//    self.saftyView.hidden = NO;
//    self.bankView.hidden = YES;
     [self setUIWithSelecteBtn:self.saftyBtn SelectedView:self.saftyView];
    //这里用户要请求有没有设置过安全密码接口
      __weak typeof(self) weakSelf = self;
    [SH_NetWorkService initUserSaftyInfoSuccess:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (![response[@"data"] isKindOfClass:[NSNull class]]) {
            NSError *err;
            RH_UserSafetyCodeModel *model = [[RH_UserSafetyCodeModel alloc]initWithDictionary:response[@"data"] error:&err];
            //更新安全模块
            [[RH_UserInfoManager shareUserManager] setUserSafetyInfo:model];
            [weakSelf.saftyView updateView];
        }
    } Fail:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
}
- (IBAction)bankCardBtnClick:(id)sender {
    
//    [self setButton:self.loginBtn BackgroundImage:@"button-long"];
//    [self setButton:self.saftyBtn BackgroundImage:@"button-long"];
//    [self setButton:self.bankBtn BackgroundImage:@"button-long-click"];
//    self.loginView.hidden = YES;
//    self.saftyView.hidden = YES;
//    self.bankView.hidden = NO;
       [self setUIWithSelecteBtn:self.bankBtn SelectedView:self.bankView];
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
    
    [self.bindPhoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self);
        make.left.equalTo(self).offset(135);
    }];
    [self.profitExView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(145);
        make.bottom.right.equalTo(self).offset(-10);
    }];
    
}
-(void)setButton:(SH_WebPButton *)button BackgroundImage:(NSString *)image{
    [button setWebpBGImage:image forState:UIControlStateNormal];
}
- (void)setTargetVC:(UIViewController *)targetVC{
    _targetVC = targetVC;
    self.loginView.targetVC = targetVC;
    self.saftyView.targetVC = targetVC;
    self.bankView.targetVC = targetVC;
}
- (void)selectedWithType:(NSString *)type From:(NSString *)from{
    self.from =from;
    self.bankView.from = from;
    if ([type isEqualToString:@"bindBankcard"]) {
        [self bankCardBtnClick:nil];
    }
}
- (IBAction)bindPhoneBtnClick:(id)sender {
    [self setUIWithSelecteBtn:self.bindPhoneBtn SelectedView:self.bindPhoneView];
}

- (IBAction)profitExchangeBtnClick:(id)sender {
     [self setUIWithSelecteBtn:self.profitExchangeBtn SelectedView:self.profitExView];
}

-(void)setUIWithSelecteBtn:(SH_WebPButton *)btn SelectedView:(UIView *)selectedView{
    for (int i = 1; i < 6; i++) {
        SH_WebPButton *unseletedBtn = [self viewWithTag:i];
        [unseletedBtn setWebpBGImage:@"button-long" forState:UIControlStateNormal];
    }
    [btn setWebpBGImage:@"button-long-click" forState:UIControlStateNormal];
    
    for (int i = 11; i < 16; i++) {
        UIView *view = [self viewWithTag:i];
        view.hidden = YES;
    }
    selectedView.hidden = NO;
}
@end
