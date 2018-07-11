//
//  SH_RechargeCenterBasicCollectionViewCell.m
//  GameBox
//
//  Created by jun on 2018/7/9.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_RechargeCenterBasicCollectionViewCell.h"

@implementation SH_RechargeCenterBasicCollectionViewCell
-(void)updateUIWithContex:(id)contex Selected:(NSString *)selected{
}
-(void)setCellBoardWithSelected:(NSString *)selected{
    UIColor *color;
    if ([selected isEqualToString:@"selected"]) {
        color = [UIColor blueColor];
    }else{
        color = [UIColor clearColor];
    }
    self.layer.borderWidth = 1;
    self.layer.borderColor = color.CGColor;
    
}
@end
