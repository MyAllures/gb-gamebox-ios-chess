//
//  SH_RechargeDetailMainSubmitView.m
//  GameBox
//
//  Created by jun on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_RechargeDetailMainSubmitView.h"
@interface SH_RechargeDetailMainSubmitView()
@property (weak, nonatomic) IBOutlet UIView *topLineView;
@property (weak, nonatomic) IBOutlet UILabel *realNameLab;
@property (weak, nonatomic) IBOutlet UILabel *accountTypeLab;
@property (weak, nonatomic) IBOutlet UITextField *realNameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *accountNum;
@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UITextField *orderTextfield;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDistance;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineTopDistance;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *realNameTopDistance;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accoutTypeTopDistance;
@property(nonatomic,strong)SH_RechargeCenterChannelModel *channelModel;

@end
@implementation SH_RechargeDetailMainSubmitView
- (void)awakeFromNib{
    [super awakeFromNib];
}
-(void)updateWithChannelModel:(SH_RechargeCenterChannelModel *)channelModel{
    self.channelModel = channelModel;
    NSString *type;
    NSString *tipType;
    if ([channelModel.bankCode isEqualToString:@"alipay"]) {
        //
        type =  @"您的支付宝账号";
        tipType = @"请填写支付宝账号";
    }else{
        self.topLineView.hidden = YES;
        self.realNameLab.hidden = YES;
        self.realNameTextfield.hidden = YES;
        self.lineTopDistance.constant = 0;
        self.realNameTopDistance.constant = 0;
        if ([channelModel.bankCode isEqualToString:@"onecodepay"]) {
            self.lineView.hidden = YES;
            self.accountTypeLab.hidden = YES;
            self.accountNum.hidden = YES;
            self.accoutTypeTopDistance.constant = 0;
        }else{
            if ([channelModel.bankCode isEqualToString:@"qqwallet"]) {
                type = @"您的QQ钱包账";
                tipType = @"请填写QQ号码";
            }
            else if ([channelModel.bankCode isEqualToString:@"bdwallet"]) {
                type = @"您的百度账号";
                tipType = @"请填写百度账号";
            }
            else if ([channelModel.bankCode isEqualToString:@"other"]) {
                type = @"您的其他方式账号";
                tipType = @"请填写其他方式账号";
            }
            else if ([channelModel.bankCode isEqualToString:@"jdwallet"]) {
                type = @"您的京东账号";
                tipType = @"请填写京东账号";
            }
            else if ([channelModel.bankCode isEqualToString:@"wechatpay"]) {
                type = @"您的微信昵称";
                tipType = @"如：陈XX";
            }
        }
    }
    self.accountTypeLab.text = type;
    self.accountNum.placeholder = tipType;
}
- (IBAction)submitBtnClick:(id)sender {
   
    if ([self.channelModel.bankCode isEqualToString:@"alipay"]) {
         if (self.realNameTextfield.text.length == 0) {
               showMessage(self.superview.superview, @"请填写支付宝用户名", nil);
         }else if (self.accountNum.text.length == 0){
             showMessage(self.superview.superview, @"请填写支付宝账号", nil);
         }else{
             [self.delegate submitRealName:self.realNameTextfield.text AccountNum:self.accountNum.text OrderNum:self.orderTextfield.text];
         }
    }else{
        if (self.accountNum.text.length == 0 ){
            NSString *tipString;
            if ([self.channelModel.bankCode isEqualToString:@"qqwallet"]) {
                tipString = @"请填写QQ号";
            }else if ([self.channelModel.bankCode isEqualToString:@"bdwallet"]) {
                tipString = @"请填写百度账号";
            }else if ([self.channelModel.bankCode isEqualToString:@"other"]) {
                tipString = @"请填写其他方式的账号";
            }else if ([self.channelModel.bankCode isEqualToString:@"jdwallet"]) {
                tipString = @"请填写京东账号";
            }else if ([self.channelModel.bankCode isEqualToString:@"wechatpay"]) {
                tipString = @"请填写微信昵称";
            }
            showMessage(self.superview.superview, tipString, nil);
        }else{
            //
            [self.delegate submitRealName:self.realNameTextfield.text AccountNum:self.accountNum.text OrderNum:self.orderTextfield.text];
        }
    }
  
}

@end
