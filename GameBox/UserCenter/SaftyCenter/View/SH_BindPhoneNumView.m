//
//  SH_BindPhoneNumView.m
//  GameBox
//
//  Created by jun on 2018/7/23.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_BindPhoneNumView.h"
#import "SH_NetWorkService+SaftyCenter.h"
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
        
    }else if ([btn.titleLabel.text isEqualToString:@"更换绑定号码"]){
       //更换手机号码
    }else if ([btn.titleLabel.text isEqualToString:@"确认"]){
        //更换手机号码
    }
    
}
-(void)selectBindPhoneNumView{
    [SH_NetWorkService getUserPhoneInfoSuccess:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary *dataDic = ConvertToClassPointer(NSDictionary, response);
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
    self.NewPhoneNumTF.enabled = NO;
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
    //发送验证码按钮点击事件
}
@end
