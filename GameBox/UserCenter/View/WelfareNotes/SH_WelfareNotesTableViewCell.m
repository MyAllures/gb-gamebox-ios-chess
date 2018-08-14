
//
//  SH_WelfareNotesTableViewCell.m
//  GameBox
//
//  Created by sam on 2018/7/26.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_WelfareNotesTableViewCell.h"
#import "SH_FundListModel.h"
#import "SH_TimeZoneManager.h"

@interface SH_WelfareNotesTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *statuLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end

@implementation SH_WelfareNotesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(SH_FundListModel *)model
{
    _model = model;
    self.timeLabel.text = [[SH_TimeZoneManager sharedManager] timeStringFrom:model.createTime/1000.0 format:@"yyyy-MM-dd HH:mm:ss"];
    self.moneyLabel.text = _model.transactionMoney;
    self.statuLabel.text = _model.statusName;
    self.typeLabel.text = _model.transaction_typeName;
}
@end
