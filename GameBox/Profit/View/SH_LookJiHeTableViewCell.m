//
//  SH_LookJiHeTableViewCell.m
//  GameBox
//
//  Created by jun on 2018/7/17.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_LookJiHeTableViewCell.h"
#import "SH_TimeZoneManager.h"

@interface SH_LookJiHeTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *createTimeLB;//存款时间
@property (weak, nonatomic) IBOutlet UILabel *rechargeAmountLB;//存款金额
@property (weak, nonatomic) IBOutlet UILabel *rechargeAuditLB;//存款稽核点
@property (weak, nonatomic) IBOutlet UILabel *favorableAmountLB;//优惠金额
@property (weak, nonatomic) IBOutlet UILabel *favorableAuditLB;//优惠稽核点
@property (weak, nonatomic) IBOutlet UILabel *favorableFeeLB;//优惠扣除

@end
@implementation SH_LookJiHeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)updaetUIWithModel:(SH_JiHeSubModel *)model{
    self.createTimeLB.text = [[SH_TimeZoneManager sharedManager] timeStringFrom:[model.createTime longLongValue]/1000.0 format:@"yyyy-MM-dd HH:MM:ss"];
    self.rechargeAmountLB.text = model.rechargeAmount;
    self.rechargeAuditLB.text = [NSString stringWithFormat:@"%@/%@",model.rechargeRemindAudit,model.rechargeAudit];
    self.favorableAmountLB.text = model.favorableAmount;
    self.favorableAuditLB.text = [NSString stringWithFormat:@"%@/%@",model.favorableRemindAudit,model.favorableAudit];
    self.favorableFeeLB.text = model.favorableFee;
}
@end
