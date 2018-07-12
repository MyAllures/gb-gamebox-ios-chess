//
//  SH_BitCoinTextView.m
//  GameBox
//
//  Created by jun on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_BitCoinTextView.h"
@interface SH_BitCoinTextView()
@property (weak, nonatomic) IBOutlet UITextField *bitCoinAdressTexField;
@property (weak, nonatomic) IBOutlet UITextField *txidTextfield;
@property (weak, nonatomic) IBOutlet UITextField *numTextfield;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;

@end
@implementation SH_BitCoinTextView

- (void)awakeFromNib{
    [super awakeFromNib];
}
- (IBAction)chooseDateBtnClick:(id)sender {
    [self.delegate SH_BitCoinTextViewChooseDateBtnClick];
}
- (IBAction)submitBtnClick:(id)sender {
    if (self.bitCoinAdressTexField.text.length <26||self.bitCoinAdressTexField.text.length <34) {
        showMessage(self.superview.superview, @"请输入26位~34位比特币地址", nil);
    }else if (self.txidTextfield.text.length==0||self.txidTextfield.text.length>64){
        showMessage(self.superview.superview, @"请输入小于64位交易产生的txid", nil);
    }else if (self.numTextfield.text.length == 0||self.numTextfield.text.length > 8){
        showMessage(self.superview.superview,nil,@"请输入整数少于8位，小数少于8位的比特币数量");
    }else if (![self.dateLab.text containsString:@":"]){
         showMessage(self.superview.superview, @"请输入交易时间", nil);
    }else{
        [self.delegate SH_BitCoinTextViewSubmitBtnClickWithAdress:self.bitCoinAdressTexField.text Txid:self.txidTextfield.text BitCoinNum:self.numTextfield.text date:self.dateLab.text];
    }
}
-(void)updateDateLabWithDataString:(NSString *)dateStr{
    self.dateLab.text = dateStr;
}
@end
