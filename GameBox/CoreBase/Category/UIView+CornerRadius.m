//
//  UIView+CornerRadius.m
//  IBinspectableDemo
//
//  Created by Paul on 2018/8/9.
//  Copyright © 2018年 Paul. All rights reserved.
//

#import "UIView+CornerRadius.h"
@implementation UIView (CornerRadius)
IB_DESIGNABLE

@dynamic cornerRadius,color,borderWidth;
- (void)setCornerRadius:(CGFloat)cornerRadius{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
}
-(void)setColor:(UIColor *)color{
    self.layer.borderColor = color.CGColor;
}
-(void)setBorderWidth:(CGFloat)borderWidth{
    self.layer.borderWidth = borderWidth;
}

-(CGFloat)cornerRadius{
    return self.layer.cornerRadius;
}
-(UIColor *)color{
    return [UIColor  colorWithCGColor:self.layer.borderColor];
}
-(CGFloat)borderWidth{
    return self.layer.borderWidth;
}
@end
