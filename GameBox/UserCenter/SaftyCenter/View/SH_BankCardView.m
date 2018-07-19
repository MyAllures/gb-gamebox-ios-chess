//
//  SH_BankCardView.m
//  GameBox
//
//  Created by jun on 2018/7/17.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_BankCardView.h"
#import "SH_NetWorkService+SaftyCenter.h"
#import "SH_HorizontalscreenPicker.h"
#import "SH_BankListModel.h"
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
    if ( [RH_UserInfoManager shareUserManager].mineSettingInfo.bankcard.bankcardNumber != nil) {
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
            showMessage(self, response[@"message"], nil);
            NSString *code = [NSString stringWithFormat:@"%@",response[@"code"]];
            if ([code isEqualToString:@"0"]) {
                //更新用户银行信息
                [[RH_UserInfoManager shareUserManager].mineSettingInfo.bankcard setBankcardNumber: response[@"data"][@"bankCardNumber"]];
                [[RH_UserInfoManager shareUserManager].mineSettingInfo.bankcard setBankDeposit: response[@"data"][@"bankDeposit"]];
                [[RH_UserInfoManager shareUserManager].mineSettingInfo.bankcard setBankName: response[@"data"][@"bankName"]];
                [[RH_UserInfoManager shareUserManager].mineSettingInfo.bankcard setRealName: response[@"data"][@"realName"]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.targetVC dismissViewControllerAnimated:NO completion:nil];
                });
            }
           
            
        } Fail:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            
        }];
    }
}

- (IBAction)chooseBankBtnClick:(id)sender {
    //选择银行按钮
    NSMutableArray *bankNameArray = [NSMutableArray array];
    for (int i = 0; i < [RH_UserInfoManager shareUserManager].bankList.count; i++) {
        SH_BankListModel *model = [RH_UserInfoManager shareUserManager].bankList[i];
        [bankNameArray addObject:model.bankName];
        
    }
    SH_HorizontalscreenPicker *picker = [[NSBundle mainBundle]loadNibNamed:@"SH_HorizontalscreenPicker" owner:self options:nil].firstObject;
    [picker updateWithDatas:bankNameArray];
    __weak typeof(self) weakSelf = self;
    picker.confirmBlock = ^(NSInteger selectedIndex) {
        weakSelf.bankTF.text = bankNameArray[selectedIndex];
        [weakSelf.chooseBankBtn setTitle:nil forState:UIControlStateNormal];
        [weakSelf.chooseBankBtn setImage:nil forState:UIControlStateNormal];

        
    };   
}
- (void)setTargetVC:(UIViewController *)targetVC{
    _targetVC = targetVC;
}
@end
