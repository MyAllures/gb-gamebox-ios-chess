//
//  SH_PromoViewCell.m
//  GameBox
//
//  Created by sam on 2018/7/7.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_PromoViewCell.h"

@implementation SH_PromoViewCell


- (void)setFrame:(CGRect)frame{
//    frame.origin.x += 10;
    frame.origin.y += 10;
    frame.size.height -= 10;
//    frame.size.width -= 20;
    [super setFrame:frame];
}

- (IBAction)promoDetailAction:(id)sender {
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.bgImageView.image = [UIImage imageNamed:@"promo_bg"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
