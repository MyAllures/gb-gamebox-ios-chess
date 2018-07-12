//
//  RH_RechargeCenterFooterView.m
//  testDemo
//
//  Created by jun on 2018/7/6.
//  Copyright © 2018年 jun. All rights reserved.
//

#import "RH_RechargeCenterFooterView.h"
#import "THScrollChooseView.h"
#import "SH_RechargeCenterChannelModel.h"
@interface RH_RechargeCenterFooterView()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *messageLab;
@property(nonatomic,copy)NSString *content;
@property (weak, nonatomic) IBOutlet UILabel *chooseBkLab;
@property (weak, nonatomic) IBOutlet UIButton *chooseBKBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnTop;
@property(nonatomic,strong)NSArray *bankArray;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLab;

@end
@implementation RH_RechargeCenterFooterView
- (void)awakeFromNib{
    [super awakeFromNib];
//    [self addSureBtnInTextfield];
    
}
//-(void)addSureBtnInTextfield{
//    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
//    toolBar.backgroundColor = [UIColor lightGrayColor];
//
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(0, 0, 50, 30);
//    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
//    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [btn setTitle:@"完成" forState:UIControlStateNormal];
//    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
//    [toolBar setItems:@[btnSpace,btnItem]];
//    self.textField.inputAccessoryView = toolBar;
//
//}
//-(void)btnClick{
//    [self.textField endEditing:YES];
//}
-(void)updateUIWithCode:(NSString *)code
                   Type:(NSString *)type
                 Number:(NSString *)number
      ChannelModelArray:(NSArray *)array{
    self.bankArray = array;
    if ([code isEqualToString:@"online"]) {
        self.content = @"温馨提示：\n• 为了提高对账速度及成功率，当前支付方式已开随机额度，请输入整数存款金额，将随机增加0.01~0.99元！\n• 请保留好转账单据作为核对证明。\n• 如出现充值失败或充值后未到账等情况，请联系在线客服获取帮助。 点击联系在线客服";
        self.chooseBKBtn.hidden = NO;
        self.chooseBkLab.hidden = NO;
        self.bankNameLab.hidden  = NO;
        self.btnTop.constant = 90;
    }else{
        self.chooseBKBtn.hidden = YES;
        self.chooseBkLab.hidden = YES;
        self.bankNameLab.hidden = YES;
        self.btnTop.constant = 50;
     if ([code isEqualToString:@"wechat"]||[code isEqualToString:@"alipay"]||[code isEqualToString:@"qq"]||[code isEqualToString:@"jd"]||[code isEqualToString:@"bd"]||[code isEqualToString:@"unionpay"]) {
        if ([type isEqualToString:@"1"]) {
            self.content =@"温馨提示：\n• 存款金额请加以小数点或尾数，以便区别。如充值200元，请输入201元或200.1之类小数。\n• 如有任何疑问，请联系在线客服获取帮助。点击联系在线客服";
        }
        else if ([type isEqualToString:@"2"]){
            self.content = @"温馨提示：\n• 为了提高对账速度及成功率，当前支付方式已开随机额度，请输入整数存款金额，将随机增加0.01~0.99元！\n• 支付成功后，请等待几秒钟，提示「支付成功」按确认键后再关闭支付窗口。\n• 如出现充值失败或充值后未到账等情况，请联系在线客服获取帮助。 点击联系在线客服";
        }
        
    }
    else if ([code isEqualToString:@"onecodepay"]) {
        self.content = @"温馨提示：\n• 存款金额请加以小数点或尾数，以便区别。如充值200元，请输入201元或200.1之类小数。\n• 如有任何疑问，请联系在线客服获取帮助。点击联系在线客服";
    }
    else if ([code isEqualToString:@"company"]) {
        self.content = @"温馨提示：\n• 存款金额请加以小数点或尾数，以便区别。如充值200元，请输入201元或200.1之类小数。\n• 如有任何疑问，请联系在线客服获取帮助。点击联系在线客服";
    }
    else if ([code isEqualToString:@"counter"]) {
        self.content = @"温馨提示：\n• 存款金额请加以小数点或尾数，以便区别。如充值200元，请输入201元或200.1之类小数。\n• 如有任何疑问，请联系在线客服获取帮助。点击联系在线客服";
    }
    else if ([code isEqualToString:@"other"]) {
        self.content = @"温馨提示：\n• 存款金额请加以小数点或尾数，以便区别。如充值200元，请输入201元或200.1之类小数。\n• 如有任何疑问，请联系在线客服获取帮助。点击联系在线客服";
    }
    else if ([code isEqualToString:@"easy"]) {
        self.content = @"温馨提示：\n• 当前支付额度必须精确到小数点，请严格核对您的转账金额精确到分，如：100.51，否则无法提高对账速度及成功率，谢谢您的配合。\n• 如有任何疑问，请联系在线客服获取帮助。点击联系在线客服";
    }
    }
    self.messageLab.text = self.content;
    self.textField.text = number;
}
- (IBAction)submitBtnClick:(id)sender {
    [self.delegate RH_RechargeCenterFooterViewSubmitBtnClick];
}
- (IBAction)chooseBKBtnXClick:(id)sender {
    NSMutableArray *bankNameArray = [NSMutableArray array];
    for (int i = 0; i < self.bankArray.count; i++) {
        SH_RechargeCenterChannelModel *model = self.bankArray[i];
        [bankNameArray addObject:model.payName];
        
    }
    THScrollChooseView *scrollChooseView = [[THScrollChooseView alloc] initWithQuestionArray:bankNameArray withDefaultDesc:bankNameArray[0]];
    [scrollChooseView showView];
    __weak typeof(self) weakSelf = self;
    scrollChooseView.confirmBlock = ^(NSInteger selectedQuestion) {
        SH_RechargeCenterChannelModel *model = weakSelf.bankArray[selectedQuestion];
        self.bankNameLab.text = model.payName;
        weakSelf.textField.placeholder = [NSString stringWithFormat:@"%@~%@",model.singleDepositMin,model.singleDepositMax];
    };
}

@end
