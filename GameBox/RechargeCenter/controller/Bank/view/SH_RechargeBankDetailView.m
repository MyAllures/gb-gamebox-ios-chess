//
//  SH_RechargeBankDetailVIew.m
//  GameBox
//
//  Created by jun on 2018/7/11.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_RechargeBankDetailView.h"
#import "SH_RechargeDetailBankView.h"

@interface SH_RechargeBankDetailView()<SH_RechargeDetailBankViewDelegate>
@property(nonatomic,strong)SH_RechargeDetailBankView *headView;
@property(nonatomic,strong)UILabel *bottomLab;
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
-(UILabel *)bottomLab{
    if (!_bottomLab) {
        _bottomLab = [[UILabel alloc]init];
        _bottomLab.numberOfLines = 0;
        _bottomLab.font = [UIFont systemFontOfSize:14];
        [self addSubview:_bottomLab];
    }
    return _bottomLab;
}
-(void)configUI{
      __weak typeof(self) weakSelf = self;
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@470);
    }];
    [self.bottomLab mas_makeConstraints:^(MASConstraintMaker *make) {
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
        self.bottomLab.text = @"温馨提示\n• 先查看要入款的银行账号信息，然后通过网上银行或手机银行进行转账，转账成功后再如实提交转账信息，财务专员查收到信息后会及时添加您的款项。\n• 请尽可能选择同行办理转账，可快速到账。\n• 存款完成后，保留单据以利核对并确保您的权益。\n• 如出现充值失败或充值后未到账等情况，请联系在线客服获取帮助。点击联系在线客服";
    }else if([platformModel.code isEqualToString:@"counter"]){
        self.bottomLab.text = @"温馨提示：\n• 先查看要入款的银行账号信息，然后通过网上银行、ATM、柜台或手机银行进行转账，转账成功后再如实提交转账信息，财务专员查收到信息后会及时添加您的款项。\n• 请尽可能选择同行办理转账，可快速到账。\n• 存款完成后，保留单据以利核对并确保您的权益。\n• 如出现充值失败或充值后未到账等情况，请联系在线客服获取帮助。 点击联系在线客服";
    }
    [self.headView updateWithChannelModel:channelModel PaywayModel:paywayModel PlatformModel:platformModel];
    
}
#pragma mark--
#pragma mark--提交按钮
- (void)SH_RechargeDetailBankSubViewWithDepositeWay:(NSString *)depositeWay Person:(NSString *)person Address:(NSString *)address{
    [self.delegate SH_RechargeBankDetailViewSubmitDepositeWay:depositeWay Person:person Address:address];
}
@end
