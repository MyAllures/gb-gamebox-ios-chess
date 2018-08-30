//
//  CALayer+SH_XibBorderColor.m
//  GameBox
//
//  Created by egan on 2018/8/30.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "CALayer+SH_XibBorderColor.h"

@implementation CALayer (SH_XibBorderColor)

- (void)setBorderColorWithUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;
}

@end
