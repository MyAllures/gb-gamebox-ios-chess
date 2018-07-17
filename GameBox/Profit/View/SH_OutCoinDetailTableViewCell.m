//
//  SH_OutCoinDetailTableViewCell.m
//  GameBox
//
//  Created by jun on 2018/7/17.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_OutCoinDetailTableViewCell.h"

@interface SH_OutCoinDetailTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;

@end
@implementation SH_OutCoinDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.detailLab.layer.borderWidth = 1;
    self.detailLab.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.36].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)updateUIWithTitle:(NSString *)title
                  Detail:(NSString *)detail{
    self.titleLab.text = title;
    self.detailLab.text = detail;
}
@end
