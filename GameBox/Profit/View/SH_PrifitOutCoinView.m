//
//  SH_PrifitOutCoinView.m
//  GameBox
//
//  Created by jun on 2018/7/16.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_PrifitOutCoinView.h"
#import "SH_NetWorkService+Profit.h"
#import "SH_BigWindowViewController.h"
#import "SH_SmallWindowViewController.h"
#import "SH_OutCoinDetailView.h"
#import "SH_FeeModel.h"
#import "SH_ProfitAlertView.h"
#import "SH_SaftyCenterView.h"
#import "SH_TopLevelControllerManager.h"
@interface SH_PrifitOutCoinView()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *numTextField;
@property (weak, nonatomic) IBOutlet UILabel *feeLab;
@property (weak, nonatomic) IBOutlet UILabel *balanceLab;
@property (weak, nonatomic) IBOutlet UILabel *bankNumLab;
//@property(nonatomic,strong)UIViewController *targetVC;
@property (weak, nonatomic) IBOutlet SH_WebPButton *bandingBtn;

@property(nonatomic,strong)SH_FeeModel *feeModel;//传到下面一个页面
@property(nonatomic,copy)NSString *token;
@property(nonatomic,strong)SH_ProfitModel *model;
@property(nonatomic,copy)NSString *code;
@property(nonatomic,copy)NSString *message;
@property (weak, nonatomic) IBOutlet SH_WebPButton *sureBtn;

@end
@implementation SH_PrifitOutCoinView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.numTextField.delegate = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateBankNum) name:@"refreshBankNumer" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshBankcard) name:@"refreshBankcard" object:nil];
}

-(void)refreshBankcard {
    NSString *bankcardNumber = [RH_UserInfoManager shareUserManager].mineSettingInfo.bankcard.bankcardNumber;
    NSString *first = [bankcardNumber substringWithRange:NSMakeRange(1, 8)];
    NSString *last = [bankcardNumber substringWithRange:NSMakeRange(bankcardNumber.length-4, 4)];
    self.bankNumLab.text = [NSString stringWithFormat:@"%@****%@",first,last];
    [self.bandingBtn setTitle:@"已绑定" forState:UIControlStateNormal];
    self.bandingBtn.userInteractionEnabled = NO;
}

- (IBAction)bindProfitAccountNumBtnClick:(id)sender {
    if ([self.bankNumLab.text isEqualToString:@"请绑定银行卡"]) {
        SH_SaftyCenterView *view = [[NSBundle mainBundle]loadNibNamed:@"SH_SaftyCenterView" owner:self options:nil].firstObject;
        SH_BigWindowViewController *vc = [SH_BigWindowViewController new];
        vc.titleImageName = @"title12";
        vc.customView = view;
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        UIViewController * svc= [SH_TopLevelControllerManager  fetchTopLevelController];
        
        [svc presentViewController:vc animated:YES completion:nil];
        [view selectedWithType:@"bindBankcard" From:@"profitView"];
    }else{
        showMessage(self, @"您已绑定银行卡", nil);
    }
}
- (IBAction)add50BtnClik:(id)sender {
    NSInteger num = [self.numTextField.text integerValue];
    self.numTextField.text = [NSString stringWithFormat:@"%ld",num+50];
    [self caculateWithMoney:self.numTextField.text];
    self.sureBtn.userInteractionEnabled = NO;
}
- (IBAction)add100BtnClik:(id)sender {
    NSInteger num = [self.numTextField.text integerValue];
    self.numTextField.text = [NSString stringWithFormat:@"%ld",num+100];
    [self caculateWithMoney:self.numTextField.text];
    self.sureBtn.userInteractionEnabled = NO;
}
- (IBAction)sureBtnClick:(id)sender {
    NSDictionary *rank = self.model.rank;
    float withdrawMinNum = [rank[@"withdrawMinNum"] floatValue];
    float withdrawMaxNum = [rank[@"withdrawMaxNum"] floatValue];;
    if ([self.bankNumLab.text isEqualToString:@"请绑定银行卡"]){
        showMessage(self, @"请绑定银行卡", nil);
    }else if (self.numTextField.text.length == 0) {
        [self popAlertView:@"请输入出币数量"];
    }
    else if ([self.numTextField.text floatValue] > [self.balanceLab.text floatValue]) {
        [self popAlertView:@"福利余额不足"];
    }
    else if ([self.numTextField.text intValue] == 0) {
        self.numTextField.text = @"";
        [self popAlertView:@"出币数量应大于0"];
        return;
    }else if ([self.numTextField.text floatValue] < withdrawMinNum){
        [self popAlertView:[NSString stringWithFormat:@"出币数量应大于%.2f",withdrawMinNum]];
    }else if ([self.numTextField.text floatValue] > withdrawMaxNum){
        [self popAlertView:[NSString stringWithFormat:@"出币数量应小于%.2f",withdrawMaxNum]];
    }else{
        if ([self.code intValue] == 1100) {
            [self popAlertView:self.message];
        } else if ([self.code intValue] == 0) {
            if (self.feeModel) {
                SH_OutCoinDetailView *view = [[NSBundle mainBundle]loadNibNamed:@"SH_OutCoinDetailView" owner:self options:nil].firstObject;
                SH_BigWindowViewController *vc = [SH_BigWindowViewController new];
                vc.titleImageName = @"title14";
                vc.customView = view;
                vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                UIViewController * svc= [SH_TopLevelControllerManager  fetchTopLevelController];
                [svc presentViewController:vc animated:YES completion:nil];
                self.feeModel.actualWithdraw = [NSString stringWithFormat:@"%.2f",[self.feeModel.actualWithdraw floatValue]];
                [view updateUIWithDetailArray:@[self.bankNumLab.text,self.numTextField.text,self.feeModel.counterFee,self.feeModel.administrativeFee,self.feeModel.deductFavorable,self.feeModel.actualWithdraw] TargetVC:nil Token:self.token];
                NSLog(@"1-----%@",self.bankNumLab.text);
                NSLog(@"%@",self.numTextField.text);
                NSLog(@"%@",self.feeModel.counterFee);
                NSLog(@"%@",self.feeModel.administrativeFee);
                NSLog(@"%@",self.bankNumLab.text);
                NSLog(@"%@",self.bankNumLab.text);
            }
        }
    }
}

-(void)updateUIWithBalance:(SH_ProfitModel *)model
                   BankNum:(NSString *)bankNum
                  TargetVC:(UIViewController *)targetVC
                     Token:(NSString *)token
                      Code:(NSString *)code
                   Message:(NSString *)message{
    
    if (bankNum.length == 0) {
        self.bankNumLab.text = @"请绑定银行卡";
    }else{
        self.bankNumLab.text = bankNum;
        [self.bandingBtn setTitle:@"已绑定" forState:UIControlStateNormal];
        self.bandingBtn.userInteractionEnabled = NO;
    }
    self.balanceLab.text = [NSString stringWithFormat:@"%.2f",[model.totalBalance floatValue]];
    self.token = token;
    self.model = model;
    self.code = code;
    self.message = message;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self caculateWithMoney:textField.text];
}

-(void)caculateWithMoney:(NSString *)money{
    //计算手续费
    MBProgressHUD *hud =showHUDWithMyActivityIndicatorView(self, nil, @"获取中...");
    [SH_NetWorkService caculateOutCoinFeeWithNum:self.numTextField.text Complete:^(SH_FeeModel *model) {
        self.feeLab.text = [NSString stringWithFormat:@"%.2f",[model.counterFee floatValue]];
        self.feeModel = model;
        [hud setHidden:YES] ;
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        [hud setHidden:YES] ;
    }];
}
-(void)popAlertView: (NSString *)content{
    SH_ProfitAlertView *view = [[NSBundle mainBundle]loadNibNamed:@"SH_ProfitAlertView" owner:self options:nil].firstObject;
    view.content = content;
    SH_SmallWindowViewController * acr = [SH_SmallWindowViewController new];
    acr.titleImageName = @"title03";
    acr.customView = view;
    acr.contentHeight = 202;
    acr.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    acr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    UIViewController * svc= [SH_TopLevelControllerManager  fetchTopLevelController];
    [svc presentViewController:acr animated:YES completion:nil];
    
}
-(void)updateBankNum {
    NSString *bankcardNumber = [RH_UserInfoManager shareUserManager].mineSettingInfo.bankcard.bankcardNumber;
    NSString *first = [bankcardNumber substringWithRange:NSMakeRange(1, 8)];
    NSString *last = [bankcardNumber substringWithRange:NSMakeRange(bankcardNumber.length-4, 4)];
    self.bankNumLab.text = [NSString stringWithFormat:@"%@****%@",first,last];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
