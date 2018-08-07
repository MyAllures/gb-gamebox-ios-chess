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
@property (weak, nonatomic) IBOutlet UIView *olbPhone_view;
@property (weak, nonatomic) IBOutlet UILabel *oldPhoneNumLab; //旧手机号码lable
@property (weak, nonatomic) IBOutlet UITextField *oldPhoneNumTF;//旧手机号码textfield
@property (weak, nonatomic) IBOutlet UILabel *NewPhoneNumLab;//新手机号码lable
@property (weak, nonatomic) IBOutlet UITextField *NewPhoneNumTF;//新手机号码textfield
@property (weak, nonatomic) IBOutlet UIView *NewPhone_view;
@property (weak, nonatomic) IBOutlet UIButton *VerificationBtn;//验证码按钮
@property (weak, nonatomic) IBOutlet UILabel *InputVerificationCodeLab;//验证码lable
@property (weak, nonatomic) IBOutlet UITextField *InputCodeTF;//验证码textfield
@property (weak, nonatomic) IBOutlet SH_WebPButton *sureBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *NewPhoneLabTopDistance;
@property (strong, nonatomic) NSString *phoneNum;

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
            if ([self.oldPhoneNumTF.text isEqualToString: self.NewPhoneNumTF.text]) {
                showMessage(self, @"新手机号码与原手机号码相同", @"");
                return;
            }
            [self bindPhoneNum];
        }
    }
    
}
-(void)selectBindPhoneNumView{
    [SH_NetWorkService getUserPhoneInfoSuccess:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary *dataDic = ConvertToClassPointer(NSDictionary, response);
        NSString *code = dataDic[@"code"];
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
        if (data.length > 0) {
            //绑定过手机
            self.phoneNum = data;
            [self bindedPhoneNumber:data];
        }else
        {
            //没有绑定过手机
            [self notBindPhoneNum];
        }
        
    } Fail:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
}
//绑定过手机号码
-(void)bindedPhoneNumber:(NSString *)phoneNum{
    self.oldPhoneNumLab.hidden = YES;
    self.oldPhoneNumTF.hidden = YES;
    self.olbPhone_view.hidden = YES;
    self.NewPhoneNumLab.text = @"手机号码";
    self.NewPhoneNumTF.text = phoneNum;
    self.NewPhoneNumTF.userInteractionEnabled = NO;
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
    self.olbPhone_view.hidden = YES;
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
    self.olbPhone_view.hidden = NO;
    self.oldPhoneNumTF.hidden = NO;
    self.NewPhoneNumLab.text = @"新手机号码";
    self.VerificationBtn.hidden = NO;
    self.InputVerificationCodeLab.hidden = NO;
    self.NewPhoneNumTF.text = @"";
    self.oldPhoneNumTF.text = @"";
    self.NewPhoneNumTF.userInteractionEnabled = YES;
    self.InputCodeTF.hidden = NO;
    [self.sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    self.NewPhoneLabTopDistance.constant = 64;
    [self layoutIfNeeded];
}
- (IBAction)sendVerificationBtn:(id)sender {
    
    BOOL bo = [self valiMobile: self.NewPhoneNumTF.text];
    if (self.NewPhoneNumTF.text.length == 0) {
        showMessage(self, @"请输入手机号", nil);
    }else if (bo == NO){
        showMessage(self, @"手机号格式错误", nil);
        return;
    } else if ([self.oldPhoneNumTF.text isEqualToString:self.NewPhoneNumTF.text]){
        showMessage(self, @"新手机号码与原手机号码相同", nil);
        return;
    } else {
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

- (BOOL)valiMobile:(NSString *)mobile
{
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
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
        } else {
            showMessage(self, dataDic[@"message"], nil);
        }
    } Fail:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
}

- (void)setTargetVC:(UIViewController *)targetVC{
    _targetVC = targetVC;
}
@end
