//
//  SH_WelfareTableViewCell.m
//  GameBox
//
//  Created by Paul on 2018/7/17.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_WelfareTableViewCell.h"
#import "SH_FundListModel.h"
@interface SH_WelfareTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *one_label;
@property (weak, nonatomic) IBOutlet UILabel *two_label;
@property (weak, nonatomic) IBOutlet UILabel *three_label;
@property (weak, nonatomic) IBOutlet UILabel *four_label;

@end
@implementation SH_WelfareTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context{
    SH_FundListModel * model =  ConvertToClassPointer(SH_FundListModel, context);
   
    self.one_label.text =   dateString(model.createTime, @"yyyy-MM-dd");
    self.two_label.text = model.transactionMoney;
    self.three_label.text = model.statusName;
    self.four_label.text = model.transaction_typeName;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
