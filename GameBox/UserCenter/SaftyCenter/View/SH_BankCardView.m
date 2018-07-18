//
//  SH_BankCardView.m
//  GameBox
//
//  Created by jun on 2018/7/17.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_BankCardView.h"
#import "SH_NetWorkService+SaftyCenter.h"
@interface SH_BankCardView()
@property (weak, nonatomic) IBOutlet UIButton *chooseBankBtn;
@property (weak, nonatomic) IBOutlet UITextField *realNameTF;
@property (weak, nonatomic) IBOutlet UITextField *bankTF;
@property (weak, nonatomic) IBOutlet UITextField *cardNumTF;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end
@implementation SH_BankCardView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.chooseBankBtn ButtonPositionStyle:ButtonPositionStyleRight spacing:5];
    if ( [RH_UserInfoManager shareUserManager].mineSettingInfo.bankcard != nil) {
         //已经绑定了银行卡
        for (UIView *TF in self.subviews) {
            if ([TF isKindOfClass:[UITextField class]]) {
                UITextField *textf = (UITextField *)TF;
                textf.enabled = NO;
            }
        }
        self.realNameTF.text = [RH_UserInfoManager shareUserManager].mineSettingInfo.bankcard.realName;
        self.bankTF.text = [RH_UserInfoManager shareUserManager].mineSettingInfo.bankcard.bankName;
        self.cardNumTF.text = [RH_UserInfoManager shareUserManager].mineSettingInfo.bankcard.bankcardNumber;
        self.addressTF.text = [RH_UserInfoManager shareUserManager].mineSettingInfo.bankcard.bankDeposit;
        self.chooseBankBtn.hidden = YES;
        self.sureBtn.hidden = YES;

    }
   
}
- (IBAction)sureBtnClick:(id)sender {
    if (self.realNameTF.text.length == 0) {
        showMessage(self, @"请输入真实姓名", nil);
    }else if (self.bankTF.text.length == 0 ){
         showMessage(self, @"请选择银行", nil);
    }else if (self.cardNumTF.text.length == 0){
        showMessage(self, @"请输入银行卡号", nil);
    }else if (self.addressTF.text.length == 0){
        showMessage(self, @"请输入开户银行", nil);
    }else{
        [SH_NetWorkService bindBankcardRealName:self.realNameTF.text BankName:self.bankTF.text CardNum:self.cardNumTF.text BankDeposit:self.addressTF.text Success:^(NSHTTPURLResponse *httpURLResponse, id response) {
            
        } Fail:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            
        }];
    }
}

- (IBAction)chooseBankBtnClick:(id)sender {
    //选择银行按钮
}
@end
