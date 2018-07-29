//
//  SH_XibImageView.m
//  GameBox
//
//  Created by shin on 2018/7/29.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_XibImageView.h"

@implementation SH_XibImageView

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

@end
