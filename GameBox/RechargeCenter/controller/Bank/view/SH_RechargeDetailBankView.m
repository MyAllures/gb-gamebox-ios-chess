
//
//  SH_RechargeDetailBankView.m
//  GameBox
//
//  Created by jun on 2018/7/11.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_RechargeDetailBankView.h"
#import "SH_RechargeCenterAccountModel.h"
@interface SH_RechargeDetailBankView()<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *cardNumLab;
@property (weak, nonatomic) IBOutlet UILabel *personLab;
@property (weak, nonatomic) IBOutlet UILabel *bankLab;
@property (weak, nonatomic) IBOutlet UILabel *messageLab;
@property (weak, nonatomic) IBOutlet UITextField *personTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UILabel *adressLab;
@property (weak, nonatomic) IBOutlet UIButton *chooseDepositeBtn;
@property (weak, nonatomic) IBOutlet UILabel *depositeLab;
@property(nonatomic,strong)NSMutableArray *depositeTypeArray;
@property(nonatomic,strong)SH_RechargeCenterChannelModel *channelModel;
@property(nonatomic,strong)SH_RechargeCenterPlatformModel *platformModel;
@property(nonatomic,copy)NSString *depositWay;//因为网银存款和柜员机不同所以要记录下来
@property(nonatomic,strong)NSArray *accountModelArray;
@property (nonatomic, strong) SH_RechargeCenterPaywayModel *paywayModel;
@end
@implementation SH_RechargeDetailBankView
- (void)awakeFromNib{
    [super awakeFromNib];
    self.depositeTypeArray = [NSMutableArray array];
}
- (IBAction)copyBankNum:(id)sender {
    //复制银行账户或代码code
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];

    if ([self.paywayModel.hide isEqualToString:@"0"]) {
        pboard.string = self.channelModel.account;
    }else{
        pboard.string = self.channelModel.code;
    }
    showMessage(self, @"复制成功",nil);
}
- (IBAction)copyPersonName:(id)sender {
    //复制开户名
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.channelModel.fullName;
    showMessage(self, @"复制成功",nil);
}
- (IBAction)copyBank:(id)sender {
    //复制开户行
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.channelModel.openAcountName;
    showMessage(self, @"复制成功",nil);
}
- (IBAction)chooseDepositeType:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    for (NSString *title in self.depositeTypeArray) {
        [actionSheet addButtonWithTitle:title];
    }
    [actionSheet showInView:self];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    self.depositeLab.text = self.depositeTypeArray[buttonIndex];
    SH_RechargeCenterAccountModel *dpmodel  = self.accountModelArray[buttonIndex];
    self.depositWay = dpmodel.code;
}
-(void)updateWithChannelModel:(SH_RechargeCenterChannelModel *)channelModel
                  PaywayModel:(SH_RechargeCenterPaywayModel *)paywayModel
                PlatformModel:(SH_RechargeCenterPlatformModel *)paltformModel{
    self.channelModel = channelModel;
    self.platformModel = paltformModel;
    self.paywayModel = paywayModel;
    if ([paywayModel.hide isEqualToString:@"0"]) {
        //隐藏
        self.cardNumLab.text = channelModel.account;
    }else{
        self.cardNumLab.text = [NSString stringWithFormat:@"账号代码：%@",channelModel.code];
    }
    [self.iconImageView setImageWithType:1 ImageName:channelModel.imgUrl];
    self.titleLab.text = channelModel.aliasName;
    [self.personLab setTextWithFirstString:[NSString stringWithFormat:@"银行开户名:  %@",channelModel.fullName] SecondString:channelModel.fullName FontSize:14 Color:[UIColor blackColor]] ;
    [self.bankLab setTextWithFirstString:[NSString stringWithFormat:@"开户行:  %@",channelModel.openAcountName] SecondString:channelModel.openAcountName FontSize:14 Color:[UIColor blackColor]];
    self.messageLab.text = channelModel.remark;
    if ([paltformModel.code isEqualToString:@"company"]) {
        //网银存款
        self.chooseDepositeBtn.hidden = YES;
        self.depositeLab.text = paltformModel.name;
        self.addressTextField.hidden = YES;
        self.adressLab.hidden = YES;
        self.depositWay = channelModel.depositWay;
    }else{
        self.accountModelArray = paywayModel.counterRechargeTypes;
        if (self.accountModelArray.count > 0) {
            SH_RechargeCenterAccountModel *dpmodel  = self.accountModelArray[0];
            self.depositWay = dpmodel.code;
            for (SH_RechargeCenterAccountModel *model in self.accountModelArray) {
                [self.depositeTypeArray addObject:model.name?model.name:@""];
            }
            self.depositeLab.text =  self.depositeTypeArray.count > 0 ? self.depositeTypeArray[0]:@"柜员机现金存款";
        }
       
    }
}
- (IBAction)submitBtnClick:(id)sender {
    //提交按钮
    if (self.personTextField.text.length == 0) {
        showMessage(self.superview.superview, @"请填转账账号对应的姓名", nil);
    }else{
        if ([self.platformModel.code isEqualToString:@"counter"]) {
            if (self.addressTextField.text.length == 0) {
                showMessage(self.superview.superview, @"请填写存款地点", nil);
            }else{
                //信息填写齐全
                [self.delegate SH_RechargeDetailBankSubViewWithDepositeWay:self.depositWay Person:self.personTextField.text Address:self.addressTextField.text];
            }
        }else{
             //信息填写齐全,网银存款不用填写地址
            [self.delegate SH_RechargeDetailBankSubViewWithDepositeWay:self.depositWay Person:self.personTextField.text Address:nil];
        }
    }
}
@end
