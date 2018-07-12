//
//  SH_PopSubViewTableViewCell.m
//  GameBox
//
//  Created by jun on 2018/7/12.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_PopSubViewTableViewCell.h"
@interface SH_PopSubViewTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
@implementation SH_PopSubViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)updateUIWithSaleDetailModel:(SH_BitCoinSaleDetailModel *)model{
    self.titleLab.text = model.activityName;
}
@end
