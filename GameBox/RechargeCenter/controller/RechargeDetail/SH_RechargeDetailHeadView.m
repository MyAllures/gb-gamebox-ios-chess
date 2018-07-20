//
//  SH_RechargeDetailHeadView.m
//  GameBox
//
//  Created by jun on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_RechargeDetailHeadView.h"
#import "SavePhotoTool.h"
@interface SH_RechargeDetailHeadView()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saveBtnCenterX;
@property (weak, nonatomic) IBOutlet UIButton *openBtn;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *bankLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIImageView *qrImageView;
@property(nonatomic,strong)SH_RechargeCenterChannelModel *channelModel;

@end
@implementation SH_RechargeDetailHeadView

- (void)awakeFromNib{
    [super awakeFromNib];
}
- (void)updateWithChannelModel:(SH_RechargeCenterChannelModel *)channelModel{
    self.channelModel = channelModel;
    [self.iconImageView setImageWithType:1 ImageName:channelModel.imgUrl];
    self.bankLab.text = [NSString stringWithFormat:@"%@  %@",channelModel.aliasName,channelModel.customBankName];
    self.numLab.text = channelModel.account;
    self.nameLab.text = channelModel.fullName;
    [self.qrImageView setImageWithType:1 ImageName:channelModel.qrCodeUrl];
    if ([channelModel.bankCode isEqualToString:@"qqwallet"]) {
        [self.openBtn setTitle:@"启动QQ支付" forState:UIControlStateNormal];
    }
    else if ([channelModel.bankCode isEqualToString:@"bdwallet"]) {
        [self.openBtn setTitle:@"启动百度支付" forState:UIControlStateNormal];
    }
    else if ([channelModel.bankCode isEqualToString:@"other"]) {
        [self.openBtn setTitle:@"启动其他方式支付" forState:UIControlStateNormal];
        self.openBtn.hidden = YES;
        self.saveBtnCenterX.constant = 0;
    }
    else if ([channelModel.bankCode isEqualToString:@"alipay"]) {
        [self.openBtn setTitle:@"启动支付宝支付" forState:UIControlStateNormal];
    }
    else if ([channelModel.bankCode isEqualToString:@"wechatpay"]) {
        [self.openBtn setTitle:@"启动微信支付" forState:UIControlStateNormal];
    }
    else if ([channelModel.bankCode isEqualToString:@"onecodepay"]) {
        [self.openBtn setTitle:@"启动一码付支付" forState:UIControlStateNormal];
        self.openBtn.hidden = YES;
        self.saveBtnCenterX.constant = 0;
    }
    else if ([channelModel.bankCode isEqualToString:@"jdwallet"]) {
        [self.openBtn setTitle:@"启动京东支付" forState:UIControlStateNormal];
    }
}
- (IBAction)openAppBtnClick:(id)sender {
    NSString *urlSchemes = @"";
    NSString *appName = @"";
    if ([self.channelModel.bankCode isEqualToString:@"qqwallet"]) {
        urlSchemes = @"mqq://";
        appName = @"QQ";
    }
    else if ([self.channelModel.bankCode isEqualToString:@"bdwallet"]) {
        urlSchemes = @"bdwallet://";
        appName = @"百度钱包";
    }
    else if ([self.channelModel.bankCode isEqualToString:@"alipay"]) {
        urlSchemes = @"alipay://";
        appName = @"支付宝";
    }
    else if ([self.channelModel.bankCode isEqualToString:@"wechatpay"]) {
        urlSchemes = @"weixin://";
        appName = @"微信";
    }
    else if ([self.channelModel.bankCode isEqualToString:@"jdwallet"]) {
        urlSchemes = @"jdpay://";
        appName = @"京东钱包";
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlSchemes]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlSchemes]];
    }
    else
    {
        showMessage(self.superview.superview, [NSString stringWithFormat:@"请先安装%@",appName], nil);
    }
}
- (IBAction)saveToPhoneBtnClick:(id)sender {
    if (self.qrImageView.image) {
        [[SavePhotoTool shared]saveImageToPhoneImage:self.qrImageView.image];
    }else{
        showMessage(self.superview, @"没有需要保存的图片", nil);
    }
    
}
- (IBAction)copyBankBtnClick:(id)sender {
    [self copyWithString:self.bankLab.text];
}
- (IBAction)copyNumBtnClick:(id)sender {
      [self copyWithString:self.numLab.text];
}
- (IBAction)copyPersonNameBtnClick:(id)sender {
      [self copyWithString:self.nameLab.text];
}
-(void)copyWithString:(NSString *)string{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    [pboard setString:string];
    showMessage(self.superview.superview, @"复制成功",nil);
}
@end
