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
#import "SH_BankCardModel.h"
#import "SH_ModiftSaftyPSDView.h"
#import "SH_TopLevelControllerManager.h"
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRealName) name:@"realName" object:nil];
    [self updateRealName];
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
        NSString *first = [self.realNameTF.text substringWithRange:NSMakeRange(0, 1)];
        NSString *last = [self.realNameTF.text substringWithRange:NSMakeRange(self.realNameTF.text.length-1, 1)];
        if (self.realNameTF.text.length == 2) {
            self.realNameTF.text = [NSString stringWithFormat:@"%@*",first];
        } else {
            self.realNameTF.text = [NSString stringWithFormat:@"%@*%@",first,last];
        }
        if ( [RH_UserInfoManager shareUserManager].mineSettingInfo.bankcard.bankName.length > 0) {
            self.bankTF.text = [RH_UserInfoManager shareUserManager].mineSettingInfo.bankcard.bankName;
        } else {
            self.bankTF.text = [RH_UserInfoManager shareUserManager].mineSettingInfo.bankcard.bankNameCode;
        }
        
        self.cardNumTF.text = [RH_UserInfoManager shareUserManager].mineSettingInfo.bankcard.bankcardNumber;
        if ([RH_UserInfoManager shareUserManager].mineSettingInfo.bankcard.bankDeposit.length > 0) {
            self.addressTF.text = [RH_UserInfoManager shareUserManager].mineSettingInfo.bankcard.bankDeposit;
        } else {
            self.addressTF.placeholder = @"";
        }
        
        self.chooseBankBtn.hidden = YES;
        self.sureBtn.hidden = YES;

    }
}

-(void)updateRealName {
    if ([RH_UserInfoManager shareUserManager].mineSettingInfo.realName.length > 0) {
        self.realNameTF.userInteractionEnabled = NO;
        NSString *first = [[RH_UserInfoManager shareUserManager].mineSettingInfo.realName substringWithRange:NSMakeRange(0, 1)];
        NSString *last = [[RH_UserInfoManager shareUserManager].mineSettingInfo.realName substringWithRange:NSMakeRange([RH_UserInfoManager shareUserManager].mineSettingInfo.realName.length-1, 1)];
        if (self.realNameTF.text.length == 2) {
            self.realNameTF.text = [NSString stringWithFormat:@"%@*",first];
        } else {
            self.realNameTF.text = [NSString stringWithFormat:@"%@*%@",first,last];
        }
    } else {
        self.realNameTF.userInteractionEnabled = YES;
    }
}

- (IBAction)sureBtnClick:(id)sender {
    if (self.realNameTF.text.length == 0) {
        showMessage(self, @"请输入真实姓名", nil);
    }else if (self.realNameTF.text.length < 2 ){
        showMessage(self, @"真实姓名至少2位数", nil);
    }
    else if (self.bankTF.text.length == 0 ){
         showMessage(self, @"请选择银行", nil);
    }else if (self.cardNumTF.text.length == 0){
        showMessage(self, @"请输入银行卡号", nil);
    }else if (self.cardNumTF.text.length < 14){
        showMessage(self, @"卡号至少14位数", nil);
    }else if ([self.bankTF.text isEqualToString:@" 其它银行"]){
        if (self.addressTF.text.length > 0) {
           [self bindBankcardRequeset];
        } else {
            showMessage(self, @"请输入开户银行", nil);
            return;
        }
    }else{
        [self bindBankcardRequeset];
    }
}

-(void)bindBankcardRequeset {
    if ([RH_UserInfoManager shareUserManager].mineSettingInfo.realName.length > 0) {
        self.bankTF.text = [RH_UserInfoManager shareUserManager].mineSettingInfo.realName;
    }
    [SH_NetWorkService bindBankcardRealName:self.realNameTF.text BankName:self.bankTF.text CardNum:self.cardNumTF.text BankDeposit:self.addressTF.text?:@"" Success:^(NSHTTPURLResponse *httpURLResponse, id response) {
        
        NSString *code = [NSString stringWithFormat:@"%@",response[@"code"]];
        if ([code isEqualToString:@"0"]) {
            showMessage(self, @"绑定成功", nil);
            SH_BankCardModel *model = [[SH_BankCardModel alloc]init];
            model.bankcardNumber = response[@"data"][@"bankCardNumber"];
            model.bankDeposit = response[@"data"][@"bankDeposit"];
            model.bankName = response[@"data"][@"bankName"];
            model.realName  = response[@"data"][@"realName"];
            [RH_UserInfoManager shareUserManager].mineSettingInfo.bankcard = model;
            //绑定成功刷新已绑定状态
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshBankcard" object:nil];
            //更新用户银行信息
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 UIViewController * svc = [SH_TopLevelControllerManager fetchTopLevelController];
                [svc dismissViewControllerAnimated:NO completion:^{
                    if ([self.from isEqualToString:@"profitView"]) {
                        //从收益跳过来要通知其刷新数据
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshBankNumer" object:nil];
                    }
                }];
            });
        } else {
            showMessage(self, response[@"message"], nil);
        }
        
        
    } Fail:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
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
- (void)setFrom:(NSString *)from{
    _from = from;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"realName" object:nil];
}

@end
