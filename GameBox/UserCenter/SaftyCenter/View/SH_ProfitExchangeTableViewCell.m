//
//  SH_ProfitExchangeTableViewCell.m
//  GameBox
//
//  Created by jun on 2018/7/23.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_ProfitExchangeTableViewCell.h"

@interface SH_ProfitExchangeTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property(nonatomic,copy)NSString *apiId;

@end
@implementation SH_ProfitExchangeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)updateUIWithApiModel:(SH_ApiModel *)model{
    self.titleLab.text = model.apiName;
    if (model.status.length > 0) {
        self.moneyLab.text = model.status;
    }else{
        self.moneyLab.text = [NSString stringWithFormat:@"%.2f",[model.balance floatValue]];
    }
    self.apiId = model.apiID;
}
- (IBAction)refreshBtnClick:(id)sender {
    [self.delegate recoveryBtnWithApiId:self.apiId];
}


@end
