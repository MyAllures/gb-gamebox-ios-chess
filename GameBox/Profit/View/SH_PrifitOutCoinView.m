//
//  SH_PrifitOutCoinView.m
//  GameBox
//
//  Created by jun on 2018/7/16.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_PrifitOutCoinView.h"
#import "SH_NetWorkService+Profit.h"
#import "AlertViewController.h"
#import "SH_OutCoinDetailView.h"
#import "SH_FeeModel.h"
#import "SH_ProfitAlertView.h"
#import "SH_SaftyCenterView.h"
@interface SH_PrifitOutCoinView()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *numTextField;
@property (weak, nonatomic) IBOutlet UILabel *feeLab;
@property (weak, nonatomic) IBOutlet UILabel *balanceLab;
@property (weak, nonatomic) IBOutlet UILabel *bankNumLab;
@property(nonatomic,strong)UIViewController *targetVC;
@property(nonatomic,strong)SH_FeeModel *feeModel;//传到下面一个页面
@property(nonatomic,copy)NSString *token;

@end
@implementation SH_PrifitOutCoinView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.numTextField.delegate = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateBankNum) name:@"refreshBankNumer" object:nil];
}
- (IBAction)bindProfitAccountNumBtnClick:(id)sender {
    if ([self.bankNumLab.text isEqualToString:@"请绑定银行卡"]) {
        SH_SaftyCenterView *view = [[NSBundle mainBundle]loadNibNamed:@"SH_SaftyCenterView" owner:self options:nil].firstObject;
        AlertViewController *acr  = [[AlertViewController  alloc] initAlertView:view viewHeight:[UIScreen mainScreen].bounds.size.height-50 titleImageName:@"saftyTtile" alertViewType:AlertViewTypeLong];
        acr.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        acr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self.targetVC presentViewController:acr animated:YES completion:nil];
        view.targetVC = acr;
        [view selectedWithType:@"bindBankcard" From:@"profitView"];
    }else{
        showMessage(self, @"您已绑定银行卡", nil);
    }
}
- (IBAction)add50BtnClik:(id)sender {
    NSInteger num = [self.numTextField.text integerValue];
    self.numTextField.text = [NSString stringWithFormat:@"%ld",num+50];
    [self caculateWithMoney:self.numTextField.text];
}
- (IBAction)add100BtnClik:(id)sender {
    NSInteger num = [self.numTextField.text integerValue];
    self.numTextField.text = [NSString stringWithFormat:@"%ld",num+100];
    [self caculateWithMoney:self.numTextField.text];
}
- (IBAction)sureBtnClick:(id)sender {
     if ([self.bankNumLab.text isEqualToString:@"请绑定银行卡"]){
        showMessage(self, @"请绑定银行卡", nil);
    }else if (self.numTextField.text.length == 0||[self.numTextField.text floatValue] > [self.balanceLab.text floatValue]) {
        [self popAlertView];
    }else{
        SH_OutCoinDetailView *view = [[NSBundle mainBundle]loadNibNamed:@"SH_OutCoinDetailView" owner:self options:nil].firstObject;
        AlertViewController *acr  = [[AlertViewController  alloc] initAlertView:view viewHeight:[UIScreen mainScreen].bounds.size.height-95 titleImageName:@"outCoinDetail" alertViewType:AlertViewTypeLong];
        acr.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        acr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self.targetVC presentViewController:acr animated:YES completion:nil];
        [view updateUIWithDetailArray:@[self.bankNumLab.text,self.numTextField.text,self.feeModel.counterFee,self.feeModel.administrativeFee,self.feeModel.deductFavorable,self.feeModel.actualWithdraw] TargetVC:acr Token:self.token];
    }
    
}
-(void)updateUIWithBalance:(NSString *)balance
                   BankNum:(NSString *)bankNum
                  TargetVC:(UIViewController *)targetVC
                     Token:(NSString *)token{
    if (bankNum.length == 0) {
        self.bankNumLab.text = @"请绑定银行卡";
    }else{
        self.bankNumLab.text = bankNum;
    }
    self.balanceLab.text = [NSString stringWithFormat:@"%.2f",[balance floatValue]];
    self.targetVC = targetVC;
    self.token = token;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self caculateWithMoney:textField.text];
}
-(void)caculateWithMoney:(NSString *)money{
    __weak typeof(self) weakSelf = self;
    //计算手续费
    [SH_NetWorkService caculateOutCoinFeeWithNum:self.numTextField.text Complete:^(SH_FeeModel *model) {
        weakSelf.feeLab.text = [NSString stringWithFormat:@"%.2f",[model.counterFee floatValue]];
        weakSelf.feeModel = model;
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
}
-(void)popAlertView{
    SH_ProfitAlertView *view = [[NSBundle mainBundle]loadNibNamed:@"SH_ProfitAlertView" owner:self options:nil].firstObject;
    view.targetVC = self.targetVC;
    AlertViewController *acr  = [[AlertViewController  alloc] initAlertView:view viewHeight:[UIScreen mainScreen].bounds.size.height-175 titleImageName:@"title03" alertViewType:AlertViewTypeShort];
    acr.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    acr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.targetVC presentViewController:acr animated:YES completion:nil];

}
-(void)updateBankNum{
    self.bankNumLab.text = [RH_UserInfoManager shareUserManager].mineSettingInfo.bankcard.bankcardNumber;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
