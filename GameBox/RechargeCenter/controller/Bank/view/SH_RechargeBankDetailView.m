//
//  SH_RechargeBankDetailVIew.m
//  GameBox
//
//  Created by jun on 2018/7/11.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_RechargeBankDetailView.h"
#import "SH_RechargeDetailBankView.h"
#import "TTTAttributedLabel.h"
#import "SH_CustomerServiceManager.h"

@interface SH_RechargeBankDetailView()<SH_RechargeDetailBankViewDelegate,TTTAttributedLabelDelegate>
@property(nonatomic,strong)SH_RechargeDetailBankView *headView;
@property(nonatomic,strong)UILabel *bottomLab;
@property(nonatomic,strong)TTTAttributedLabel *tttLab;
@end
@implementation SH_RechargeBankDetailView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}
#pragma mark--
#pragma mark--lazy
- (SH_RechargeDetailBankView *)headView{
    if (!_headView) {
        _headView = [[NSBundle mainBundle]loadNibNamed:@"SH_RechargeDetailBankView" owner:self options:nil].firstObject;
        _headView.delegate =self;
        [self addSubview:_headView];
    }
    return _headView;
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
-(void)configUI{
      __weak typeof(self) weakSelf = self;
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@470);
    }];
    [self.tttLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headView.mas_bottom).offset(40);
        make.left.equalTo(weakSelf).offset(20);
        make.right.bottom.equalTo(weakSelf).offset(-20);
    }];
}
- (void)updateWithChannelModel:(SH_RechargeCenterChannelModel *)channelModel
                 PlatformModel:(SH_RechargeCenterPlatformModel *)platformModel
                   PaywayModel:(SH_RechargeCenterPaywayModel *)paywayModel{
    if ([platformModel.code isEqualToString:@"company"]) {
        //网银存款
        [self.headView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@450);
        }];
        [self setBottomLabWithMessage:@"温馨提示\n• 先查看要入款的银行账号信息，然后通过网上银行或手机银行进行转账，转账成功后再如实提交转账信息，财务专员查收到信息后会及时添加您的款项。\n• 请尽可能选择同行办理转账，可快速到账。\n• 存款完成后，保留单据以利核对并确保您的权益。\n• 如出现充值失败或充值后未到账等情况，请联系在线客服获取帮助。点击联系在线客服"];
    }else if([platformModel.code isEqualToString:@"counter"]){
        [self setBottomLabWithMessage:@"温馨提示\n• 先查看要入款的银行账号信息，然后通过网上银行或手机银行进行转账，转账成功后再如实提交转账信息，财务专员查收到信息后会及时添加您的款项。\n• 请尽可能选择同行办理转账，可快速到账。\n• 存款完成后，保留单据以利核对并确保您的权益。\n• 如出现充值失败或充值后未到账等情况，请联系在线客服获取帮助。点击联系在线客服"];
    }
    [self.headView updateWithChannelModel:channelModel PaywayModel:paywayModel PlatformModel:platformModel];
    
}
#pragma mark--
#pragma mark--提交按钮
- (void)SH_RechargeDetailBankSubViewWithDepositeWay:(NSString *)depositeWay Person:(NSString *)person Address:(NSString *)address{
    [self.delegate SH_RechargeBankDetailViewSubmitDepositeWay:depositeWay Person:person Address:address];
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
    [[SH_CustomerServiceManager sharedManager] open];
    NSLog(@"点击联系在线客服");
}
@end
