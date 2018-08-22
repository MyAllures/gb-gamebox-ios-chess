//
//  RH_RechargeCenterFooterView.m
//  testDemo
//
//  Created by jun on 2018/7/6.
//  Copyright © 2018年 jun. All rights reserved.
//

#import "RH_RechargeCenterFooterView.h"
#import "THScrollChooseView.h"
#import "TTTAttributedLabel.h"
#import "SH_CustomerServiceManager.h"

@interface RH_RechargeCenterFooterView()<TTTAttributedLabelDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *chooseBkLab;
@property (weak, nonatomic) IBOutlet UIButton *chooseBKBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnTop;
@property(nonatomic,strong)NSArray *bankArray;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLab;
@property(nonatomic,copy)NSString *code;
@property(nonatomic,copy)NSString *bankName;
@property(nonatomic,strong)SH_RechargeCenterChannelModel *channelModel;
@property(nonatomic,strong)TTTAttributedLabel *tttLab;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIButton *randomBtn;

@end
@implementation RH_RechargeCenterFooterView
- (void)awakeFromNib{
    [super awakeFromNib];
    [self.tttLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.submitBtn.mas_bottom).offset(15);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
    }];
    _textField.delegate = self;
}
#pragma mark--
#pragma mark--lazy
- (TTTAttributedLabel *)tttLab{
    if (!_tttLab) {
        _tttLab = [TTTAttributedLabel  new];
        _tttLab.lineBreakMode = NSLineBreakByWordWrapping;
        _tttLab.numberOfLines = 0;
        _tttLab.delegate = self;
        _tttLab.lineSpacing = 1;
        //要放在`text`, with either `setText:` or `setText:afterInheritingLabelAttributesAndConfiguringWithBlock:前面才有效
        _tttLab.enabledTextCheckingTypes = NSTextCheckingTypePhoneNumber|NSTextCheckingTypeAddress|NSTextCheckingTypeLink;
        //链接正常状态文本属性
        _tttLab.linkAttributes = @{NSForegroundColorAttributeName:[UIColor blueColor],NSUnderlineStyleAttributeName:@(1)};
        //链接高亮状态文本属性
        _tttLab.activeLinkAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor],NSUnderlineStyleAttributeName:@(1)};
        _tttLab.font = [UIFont  systemFontOfSize:14.0];
        [self addSubview:_tttLab];
    }
    return _tttLab;
}
-(void)updateUIWithCode:(NSString *)code
                   Type:(NSString *)type
                 Number:(NSString *)number
      ChannelModelArray:(NSArray *)array
           ChannelModel:(SH_RechargeCenterChannelModel *)channelModel{
    self.bankArray = array;
    self.code = code;
    self.channelModel = channelModel;
    
    NSString *content;
    if ([code isEqualToString:@"online"]) {
        content = @"温馨提示：\n• 为了提高对账速度及成功率，当前支付方式已开随机额度，请输入整数存款金额，将随机增加0.01~0.99元！\n• 请保留好转账单据作为核对证明。\n• 如出现充值失败或充值后未到账等情况，请联系在线客服获取帮助。 点击联系在线客服";
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
            content =@"温馨提示：\n• 存款金额请加以小数点或尾数，以便区别。如充值200元，请输入201元或200.1之类小数。\n• 如有任何疑问，请联系在线客服获取帮助。点击联系在线客服";
        }
        else if ([type isEqualToString:@"2"]){
            content = @"温馨提示：\n• 为了提高对账速度及成功率，当前支付方式已开随机额度，请输入整数存款金额，将随机增加0.01~0.99元！\n• 支付成功后，请等待几秒钟，提示「支付成功」按确认键后再关闭支付窗口。\n• 如出现充值失败或充值后未到账等情况，请联系在线客服获取帮助。 点击联系在线客服";
        }
        
    }else if ([code isEqualToString:@"easy"]) {
        content = @"温馨提示：\n• 当前支付额度必须精确到小数点，请严格核对您的转账金额精确到分，如：100.51，否则无法提高对账速度及成功率，谢谢您的配合。\n• 如有任何疑问，请联系在线客服获取帮助。点击联系在线客服";
    }else{
        content = @"温馨提示：\n• 存款金额请加以小数点或尾数，以便区别。如充值200元，请输入201元或200.1之类小数。\n• 如有任何疑问，请联系在线客服获取帮助。点击联系在线客服";
    }
    }
    [self setBottomLabWithMessage:content];
    self.textField.placeholder = [NSString stringWithFormat:@"%@~%@",channelModel.singleDepositMin,channelModel.singleDepositMax];
    self.textField.text = number;
    
    if (channelModel.randomAmount == NO) {
        self.randomBtn.hidden = YES;
    }else{
        self.randomBtn.hidden = NO;
        NSString *str = [NSString stringWithFormat:@"%.2f",(float)(1+arc4random()%99)/100];
        str = [str substringWithRange:NSMakeRange(1, 3)];
        [self.randomBtn setTitle:str forState:UIControlStateNormal];
    }
}
- (IBAction)submitBtnClick:(id)sender {
    if ([self.code isEqualToString:@"online"]) {
        if (self.bankName.length == 0) {
            showMessage(self.superview.superview, @"请选择银行", nil);
            return;
        }
    }
    
    if ([self.textField.text floatValue]<[self.channelModel.singleDepositMin floatValue] ||[self.textField.text floatValue]>[self.channelModel.singleDepositMax floatValue]) {
        showMessage(self.superview.superview, nil, [NSString stringWithFormat:@"请输入%@~%@",self.channelModel.singleDepositMin,self.channelModel.singleDepositMax]);
        return;
    }
    float money = [self.textField.text floatValue] + [self.randomBtn.titleLabel.text floatValue];
    [self.delegate RH_RechargeCenterFooterViewSubmitBtnClickWithMoney:[NSString stringWithFormat:@"%.2f",money]];
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
        self.bankName = model.payName;
        weakSelf.textField.placeholder = [NSString stringWithFormat:@"%@~%@",model.singleDepositMin,model.singleDepositMax];
    };
}
-(void)setBottomLabWithMessage:(NSString *)message{
    [ self.tttLab  setText:message afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        //设置可点击文字的范围
        NSRange boldRange = [[mutableAttributedString string]rangeOfString:@"点击联系在线客服"options:NSCaseInsensitiveSearch];
        //设定可点击文字的的大小
        UIFont*boldSystemFont = [UIFont systemFontOfSize:14];
        CTFontRef font =CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize,NULL);
        if(font){
            {
                //设置可点击文本的大小
                [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName
                                                value:(__bridge id)font
                                                range:boldRange];
                //文字颜色
                [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName
                                                value:[UIColor blueColor]
                                                range:boldRange];
                CFRelease(font);
            }
        }
        return  mutableAttributedString;
    }];
    NSRange boldRange1 = [message rangeOfString:@"点击联系在线客服" options:NSCaseInsensitiveSearch];
    [self.tttLab addLinkToURL:[NSURL URLWithString:@""]
                    withRange:boldRange1];
}
- (IBAction)randomBtnClick:(id)sender {
    NSString *str = [NSString stringWithFormat:@"%.2f",(float)(1+arc4random()%99)/100];
    str = [str substringWithRange:NSMakeRange(1, 3)];
    [self.randomBtn setTitle:str forState:UIControlStateNormal];
}
#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    [[SH_CustomerServiceManager sharedManager] open];
    NSLog(@"点击联系在线客服");
}
#pragma mark --- UITextViewDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //限制输入小数点后两位
    NSRange ran=[textField.text rangeOfString:@"."];
    NSInteger tt=range.location-ran.location;
    if (tt <= 2){
        return YES;
    }
    return NO;
}
@end
