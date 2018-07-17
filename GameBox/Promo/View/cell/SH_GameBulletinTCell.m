//
//  SH_GameBulletinTCell.m
//  GameBox
//
//  Created by sam on 2018/7/11.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_GameBulletinTCell.h"

@implementation SH_GameBulletinTCell

- (void)setFrame:(CGRect)frame{
    //    frame.origin.x += 10;
    frame.origin.y += 10;
    frame.size.height -= 10;
    //    frame.size.width -= 20;
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
