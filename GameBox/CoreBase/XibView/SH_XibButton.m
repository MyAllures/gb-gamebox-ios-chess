//
//  SH_XibButton.m
//  GameBox
//
//  Created by shin on 2018/8/2.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_XibButton.h"

@implementation SH_XibButton

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
