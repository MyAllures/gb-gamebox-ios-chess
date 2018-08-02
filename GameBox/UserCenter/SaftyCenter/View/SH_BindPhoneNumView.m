//
//  SH_BindPhoneNumView.m
//  GameBox
//
//  Created by jun on 2018/7/23.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_BindPhoneNumView.h"
#import "SH_NetWorkService+SaftyCenter.h"
#import "SH_GamesHomeViewController.h"
@interface SH_BindPhoneNumView()
@property (weak, nonatomic) IBOutlet UILabel *oldPhoneNumLab; //旧手机号码lable
@property (weak, nonatomic) IBOutlet UITextField *oldPhoneNumTF;//旧手机号码textfield
@property (weak, nonatomic) IBOutlet UILabel *NewPhoneNumLab;//新手机号码lable
@property (weak, nonatomic) IBOutlet UITextField *NewPhoneNumTF;//新手机号码textfield
@property (weak, nonatomic) IBOutlet UIButton *VerificationBtn;//验证码按钮
@property (weak, nonatomic) IBOutlet UILabel *InputVerificationCodeLab;//验证码lable
@property (weak, nonatomic) IBOutlet UITextField *InputCodeTF;//验证码textfield
@property (weak, nonatomic) IBOutlet SH_WebPButton *sureBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *NewPhoneLabTopDistance;

@end
@implementation SH_BindPhoneNumView

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (IBAction)sureBtnClick:(id)sender {
    UIButton *btn = sender;
    if ([btn.titleLabel.text isEqualToString:@"立即绑定"]) {
        //未绑定过手机号码
        if (self.NewPhoneNumTF.text.length == 0) {
            showMessage(self, @"请输入手机号码", nil);
        }else if (self.InputCodeTF.text.length == 0){
            showMessage(self, @"请输入验证码", nil);
        }else{
            [self bindPhoneNum];
        }
        
    }else if ([btn.titleLabel.text isEqualToString:@"更换绑定号码"]){
       //更换手机号码
        [self changedBindedPhoneNum];
    }else if ([btn.titleLabel.text isEqualToString:@"确认"]){
        //更换手机号码
        if (self.NewPhoneNumTF.text.length == 0) {
            showMessage(self, @"请输入手机号码", nil);
        }else if (self.oldPhoneNumTF.text.length == 0){
            showMessage(self, @"请输入新的手机号码", nil);
        }else if (self.InputCodeTF.text.length == 0){
            showMessage(self, @"请输入验证码", nil);
        }else{
            [self bindPhoneNum];
        }
    }
    
}
-(void)selectBindPhoneNumView{
    [SH_NetWorkService getUserPhoneInfoSuccess:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary *dataDic = ConvertToClassPointer(NSDictionary, response);
        NSString *code = dataDic[@"code"];
        showMessage(self, dataDic[@"message"], @"");
        if ([code isEqualToString:@"1001"]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.targetVC dismissViewControllerAnimated:NO completion:nil];
            });
            [[RH_UserInfoManager  shareUserManager] updateIsLogin:NO];
            [[RH_UserInfoManager  shareUserManager] setMineSettingInfo:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"configUI" object:nil];
            return ;
        }
        NSString *data = [dataDic objectForKey:@"data"];
        if (data == nil || [data isEqualToString:@""]) {
            //没有绑定过手机
            [self notBindPhoneNum];

        }else
        {
         //绑定过手机
            [self bindedPhoneNumber:nil];
        }
        
    } Fail:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
}
//绑定过手机号码
-(void)bindedPhoneNumber:(NSString *)phoneNum{
    self.oldPhoneNumLab.hidden = YES;
    self.oldPhoneNumTF.hidden = YES;
    self.NewPhoneNumLab.text = @"手机号码";
    self.NewPhoneNumTF.text = phoneNum;
    self.VerificationBtn.hidden = YES;
    self.InputVerificationCodeLab.hidden = YES;
    self.InputCodeTF.hidden = YES;
    [self.sureBtn setTitle:@"更换绑定号码" forState:UIControlStateNormal];
    self.NewPhoneLabTopDistance.constant = 20;
    [self layoutIfNeeded];
}
//未绑定过手机号码
-(void)notBindPhoneNum{
    self.oldPhoneNumLab.hidden = YES;
    self.oldPhoneNumTF.hidden = YES;
    self.NewPhoneNumLab.text = @"手机号码";
    self.VerificationBtn.hidden = NO;
    self.InputVerificationCodeLab.hidden = NO;
    self.InputCodeTF.hidden = NO;
    [self.sureBtn setTitle:@"立即绑定" forState:UIControlStateNormal];
    self.NewPhoneLabTopDistance.constant = 40;
    [self layoutIfNeeded];
}
//更换手机号码
-(void)changedBindedPhoneNum{
    self.oldPhoneNumLab.hidden = NO;
    self.oldPhoneNumLab.text = @"旧手机号码";
    self.oldPhoneNumTF.hidden = NO;
    self.NewPhoneNumLab.text = @"新手机号码";
    self.VerificationBtn.hidden = NO;
    self.InputVerificationCodeLab.hidden = NO;
    self.InputCodeTF.hidden = NO;
    [self.sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    self.NewPhoneLabTopDistance.constant = 55;
    [self layoutIfNeeded];
}
- (IBAction)sendVerificationBtn:(id)sender {
    if (self.NewPhoneNumTF.text.length == 0) {
        showMessage(self, @"请输入手机号", nil);
    }else{
    [self.VerificationBtn startCountDownTime:60 withCountDownBlock:^{
        [SH_NetWorkService sendVerificationCodePhoneNum:self.NewPhoneNumTF.text Success:^(NSHTTPURLResponse *httpURLResponse, id response) {
            NSDictionary *dataDic = ConvertToClassPointer(NSDictionary, response);
            int code = [[dataDic objectForKey:@"code"] intValue];
            if (code == 0) {
                showMessage(self, @"发送成功", nil);
            }
        } Fail:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            
        }];
    }];
    }
}
//绑定手机接口
-(void)bindPhoneNum{
    __weak typeof(self) weakSelf = self;
    [SH_NetWorkService bindPhoneNum:self.NewPhoneNumTF.text OriginalPhoneNum:self.oldPhoneNumTF.text VerificationCode:self.InputCodeTF.text Success:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary *dataDic = ConvertToClassPointer(NSDictionary, response);
        NSString * code = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"code"]];
        if ([code isEqualToString:@"0"]) {
            showMessage(self, @"绑定手机成功", nil);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.targetVC dismissViewControllerAnimated:NO completion:nil];
            });
        }
    } Fail:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
}

- (void)setTargetVC:(UIViewController *)targetVC{
    _targetVC = targetVC;
}
@end
