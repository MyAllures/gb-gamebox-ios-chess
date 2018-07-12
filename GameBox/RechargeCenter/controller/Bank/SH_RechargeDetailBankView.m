
//
//  SH_RechargeDetailBankView.m
//  GameBox
//
//  Created by jun on 2018/7/11.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_RechargeDetailBankView.h"
@interface SH_RechargeDetailBankView()<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *cardNumLab;
@property (weak, nonatomic) IBOutlet UILabel *personLab;
@property (weak, nonatomic) IBOutlet UILabel *bankLab;
@property (weak, nonatomic) IBOutlet UILabel *messageLab;
@property (weak, nonatomic) IBOutlet UITextField *personTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;

@end
@implementation SH_RechargeDetailBankView
- (void)awakeFromNib{
    [super awakeFromNib];
}
- (IBAction)contactCustomerServiceBtnClick:(id)sender {
}
- (IBAction)copyPersonName:(id)sender {
}
- (IBAction)copyBank:(id)sender {
}
- (IBAction)chooseDepositeType:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"其他",@"你好",@"你好", nil];
    [actionSheet showInView:self];
}

@end
