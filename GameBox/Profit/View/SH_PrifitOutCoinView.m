//
//  SH_PrifitOutCoinView.m
//  GameBox
//
//  Created by jun on 2018/7/16.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_PrifitOutCoinView.h"
#import "RH_UserInfoManager.h"
@interface SH_PrifitOutCoinView()
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *numTextField;
@property (weak, nonatomic) IBOutlet UILabel *balanceLab;
@property (weak, nonatomic) IBOutlet UILabel *feeLab;

@end
@implementation SH_PrifitOutCoinView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.balanceLab.text = [NSString stringWithFormat:@"%.2f",[RH_UserInfoManager shareUserManager].mineSettingInfo.walletBalance];
    
}
- (IBAction)bindProfitAccountNumBtnClick:(id)sender {
    
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

@end
