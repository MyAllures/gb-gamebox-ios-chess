//
//  SH_HandRecordTableViewCell.m
//  GameBox
//
//  Created by sam on 2018/7/26.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_HandRecordTableViewCell.h"

@implementation SH_HandRecordTableViewCell

-(void)setFrame:(CGRect)frame {
    frame.origin.y += 3;
    frame.size.height -= 3;
    [super setFrame:frame];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
