//
//  SH_PrifitOutCoinView.m
//  GameBox
//
//  Created by jun on 2018/7/16.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_PrifitOutCoinView.h"
#import "SH_NetWorkService+Profit.h"
@interface SH_PrifitOutCoinView()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *numTextField;
@property (weak, nonatomic) IBOutlet UILabel *feeLab;
@property (weak, nonatomic) IBOutlet UILabel *balanceLab;
@property (weak, nonatomic) IBOutlet UILabel *bankNumLab;

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
}
- (IBAction)add100BtnClik:(id)sender {
    NSInteger num = [self.numTextField.text integerValue];
    self.numTextField.text = [NSString stringWithFormat:@"%ld",num+100];
}
- (IBAction)sureBtnClick:(id)sender {
}
-(void)updateUIWithBalance:(NSString *)balance
                   BankNum:(NSString *)bankNum{
    if (bankNum.length == 0) {
        self.balanceLab.text = @"请绑定银行卡";
    }else{
        self.bankNumLab.text = bankNum;
    }
    self.balanceLab.text = balance;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    //计算手续费
    [SH_NetWorkService caculateOutCoinFeeWithNum:self.numTextField.text Complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
}
@end
