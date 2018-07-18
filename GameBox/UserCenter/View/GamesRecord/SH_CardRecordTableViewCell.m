//
//  SH_CardRecordTableViewCell.m
//  GameBox
//
//  Created by Paul on 2018/7/18.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_CardRecordTableViewCell.h"
#import "RH_BettingInfoModel.h"
@interface  SH_CardRecordTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *one_label;
@property (weak, nonatomic) IBOutlet UILabel *two_label;
@property (weak, nonatomic) IBOutlet UILabel *three_label;
@property (weak, nonatomic) IBOutlet UILabel *four_label;
@property (weak, nonatomic) IBOutlet UILabel *five_label;

@end
@implementation SH_CardRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context{
    RH_BettingInfoModel * model = ConvertToClassPointer(RH_BettingInfoModel, context);
    self.one_label.text =  model.showName;
    self.two_label.text = model.showBettingDate;
    self.three_label.text = model.showSingleAmount;
    if ([model.orderState isEqualToString:@"settle"] && model.profitAmount >0) {
        self.four_label.textColor = colorWithRGB(77, 206, 131) ;
    }else if ([model.orderState isEqualToString:@"settle"] && model.profitAmount < 0)
    {
        self.four_label.textColor = colorWithRGB(243, 66, 53) ;
    }else if ([model.orderState isEqualToString:@"settle"] &&
              model.profitAmount == 0)
    {
        self.four_label.textColor = [UIColor blackColor] ;
    }
    self.four_label.text = model.showProfitAmount ;
    
    if ([model.orderState isEqualToString:@"settle"]) {
        self.five_label.textColor = colorWithRGB(77, 206, 131) ;
    }else if ([model.orderState isEqualToString:@"pending_settle"])
    {
        self.five_label.textColor = colorWithRGB(253, 160, 0) ;
    }else
    {
        self.five_label.textColor = colorWithRGB(234, 94, 94) ;
    }
       self.five_label.text = model.showStatus ;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
