//
//  SH_ApplyFailTableViewCell.m
//  GameBox
//
//  Created by jun on 2018/8/14.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_ApplyFailTableViewCell.h"

@interface SH_ApplyFailTableViewCell()
@property (weak, nonatomic) IBOutlet SH_WebPImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *downImageView;
@property (weak, nonatomic) IBOutlet UIImageView *upImageView;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet SH_WebPButton *applyBtn;
@end
@implementation SH_ApplyFailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
