//
//  SH_LookJiHeTableViewCell.m
//  GameBox
//
//  Created by jun on 2018/7/17.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_LookJiHeTableViewCell.h"

@interface SH_LookJiHeTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *pointLab;
@property (weak, nonatomic) IBOutlet UILabel *feeLab;

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
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[model.createTime longLongValue]/1000.0];
    self.timeLab.text = dateStringWithFormatter(date, @"yyyy-MM-dd");
    self.moneyLab.text = model.rechargeAmount;
    self.pointLab.text = model.rechargeAudit;
    if ([model.rechargeFee isEqualToString:@"0"]) {
        self.feeLab.text = model.rechargeFee;
    }else{
        self.feeLab.text = @"未通过";
    }
    
}
@end
