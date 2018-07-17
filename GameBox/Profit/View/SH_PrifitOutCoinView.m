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
@interface SH_PrifitOutCoinView()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *numTextField;
@property (weak, nonatomic) IBOutlet UILabel *feeLab;
@property (weak, nonatomic) IBOutlet UILabel *balanceLab;
@property (weak, nonatomic) IBOutlet UILabel *bankNumLab;
@property(nonatomic,strong)UIViewController *targetVC;
@property(nonatomic,strong)SH_FeeModel *feeModel;//传到下面一个页面

@end
@implementation SH_PrifitOutCoinView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.numTextField.delegate = self;
}
- (IBAction)bindProfitAccountNumBtnClick:(id)sender {
    if (self.bankNumLab.text.length > 0) {
        showMessage(self, @"您已绑定银行卡", nil);
    }else{
        
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
    if (self.numTextField.text.length == 0) {
        showMessage(self, @"请输入出币数量", nil);
    }else{
        SH_OutCoinDetailView *view = [[NSBundle mainBundle]loadNibNamed:@"SH_OutCoinDetailView" owner:self options:nil].firstObject;
        AlertViewController *acr  = [[AlertViewController  alloc] initAlertView:view viewHeight:[UIScreen mainScreen].bounds.size.height-95 titleImageName:@"outCoinDetail" alertViewType:AlertViewTypeLong];
        acr.title = @"牌局记录";
        acr.modalPresentationStyle = UIModalPresentationCurrentContext;
        acr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self.targetVC presentViewController:acr animated:YES completion:nil];
        [view updateUIWithDetailArray:@[self.bankNumLab.text,self.numTextField.text,self.feeModel.counterFee,self.feeModel.administrativeFee,self.feeModel.deductFavorable,self.feeModel.actualWithdraw] TargetVC:acr];
    }
    
}
-(void)updateUIWithBalance:(NSString *)balance
                   BankNum:(NSString *)bankNum TargetVC:(UIViewController *)targetVC{
    if (bankNum.length == 0) {
        self.bankNumLab.text = @"请绑定银行卡";
    }else{
        self.bankNumLab.text = bankNum;
    }
    self.balanceLab.text = balance;
    self.targetVC = targetVC;
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
@end
