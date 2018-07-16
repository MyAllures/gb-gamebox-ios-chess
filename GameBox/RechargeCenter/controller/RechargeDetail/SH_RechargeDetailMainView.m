//
//  SH_RechargeDetailMainView.m
//  GameBox
//
//  Created by jun on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_RechargeDetailMainView.h"
#import "SH_RechargeDetailHeadView.h"
#import "SH_RechargeDetailMainSubmitView.h"
#import "TTTAttributedLabel.h"
@interface SH_RechargeDetailMainView()<SH_RechargeDetailMainSubmitViewDelegate,TTTAttributedLabelDelegate>
@property(nonatomic,strong)SH_RechargeDetailHeadView *headView;
@property(nonatomic,strong)SH_RechargeDetailMainSubmitView *submitView;
@property(nonatomic,strong)UILabel *messageLab;
@property(nonatomic,strong)TTTAttributedLabel *tttLab;
@end
@implementation SH_RechargeDetailMainView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}
#pragma mark--
#pragma mark--lazy
- (SH_RechargeDetailHeadView *)headView{
    if (!_headView) {
        _headView = [[NSBundle mainBundle]loadNibNamed:@"SH_RechargeDetailHeadView" owner:self options:nil].firstObject;
        [self addSubview:_headView];
    }
    return _headView;
}
- (UILabel *)messageLab{
    if (!_messageLab) {
        _messageLab = [[UILabel alloc]init];
        _messageLab.numberOfLines = 0;
        _messageLab.font = [UIFont systemFontOfSize:12];
        _messageLab.textColor = colorWithRGB(85, 85, 85);
        [self addSubview:_messageLab];
    }
    return _messageLab;
}
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
- (SH_RechargeDetailMainSubmitView *)submitView{
    if (!_submitView) {
        _submitView = [[NSBundle mainBundle]loadNibNamed:@"SH_RechargeDetailMainSubmitView" owner:self options:nil].firstObject;
        _submitView.delegate  =self;
        [self addSubview:_submitView];
    }
    return _submitView;
}
-(void)configUI{
      __weak typeof(self) weakSelf = self;
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@350);
    }];
    [self.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headView.mas_bottom).offset(5);
        make.left.equalTo(weakSelf).offset(15);
        make.right.equalTo(weakSelf).offset(-15);
    }];
    
    [self.submitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.messageLab.mas_bottom).offset(25);
        make.left.right.equalTo(weakSelf);
        make.height.equalTo(@160);
    }];
    [self.tttLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.submitView.mas_bottom).offset(40);
        make.left.equalTo(weakSelf).offset(20);
        make.right.bottom.equalTo(weakSelf).offset(-20);
    }];
}
- (void)updateWithChannelModel:(SH_RechargeCenterChannelModel *)channelModel PaywayModel:(SH_RechargeCenterPaywayModel *)paywayModel PlatformModel:(SH_RechargeCenterPlatformModel *)paltformModel{
    
    [self.headView updateWithChannelModel:channelModel];
    self.messageLab.text = channelModel.remark;
    NSString *message;
    if ([channelModel.bankCode isEqualToString:@"alipay"]) {
       //因为支付宝有一个要填真实姓名的
        [self.submitView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@210);
        }];
         message = @"温馨提示：\n• 请先查看入款账号信息或扫描二维码。\n• 支付成功后，请等待几秒钟，提示「支付成功」按确认键后再关闭支付窗口。\n• 为了系统快速完成转账，请输入订单号后5位，以加快系统入款速度。\n• 如出现充值失败或充值后未到账等情况，请联系在线客服获取帮助。点击联系在线客服";
    }else if ([channelModel.bankCode isEqualToString:@"onecodepay"]){
        //一码付
        [self.submitView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@110);
        }];
        message = @"温馨提示：\n• 五码合一，使用网银，支付宝，微信，QQ钱包，京东钱包均可扫描二维码进行转账存款。\n• 支付成功后，请等待几秒钟，提示「支付成功」按确认键后再关闭支付窗口。\n• 为了系统快速完成转账，请输入订单号后5位，以加快系统入款速度。\n• 如出现充值失败或充值后未到账等情况，请联系在线客服获取帮助。点击联系在线客服";
    }else if ([channelModel.bankCode isEqualToString:@"other"]){
        message = @"温馨提示：\n• 请先查看入款账号信息或扫描二维码。\n• 支付成功后，请等待几秒钟，提示「支付成功」按确认键后再关闭支付窗口。\n• 如出现充值失败或充值后未到账等情况，请联系在线客服获取帮助。点击联系在线客服";
    }else{
        //qq  微信等
        message = @"温馨提示：\n• 请先查看入款账号信息或扫描二维码。\n• 支付成功后，请等待几秒钟，提示「支付成功」按确认键后再关闭支付窗口。\n• 为了系统快速完成转账，请输入订单号后5位，以加快系统入款速度。\n• 如出现充值失败或充值后未到账等情况，请联系在线客服获取帮助。点击联系在线客服";
    }
    [self.submitView updateWithChannelModel:channelModel];
    [self setBottomLabWithMessage:message];
    
    
}
#pragma mark--
#pragma mark--submitView  Delegate
- (void)submitRealName:(NSString *)realName AccountNum:(NSString *)accountNum OrderNum:(NSString *)orderNum{
    [self.delegate SH_RechargeDetailMainViewSubmitRealName:realName AccountNum:accountNum OrderNum:orderNum];
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
#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    NSLog(@"点击联系在线客服");
}
@end
