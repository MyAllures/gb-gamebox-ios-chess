//
//  UIView+CornerRadius.m
//  IBinspectableDemo
//
//  Created by Paul on 2018/8/9.
//  Copyright © 2018年 Paul. All rights reserved.
//

#import "UIView+CornerRadius.h"
#import <objc/runtime.h>
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
-(void)setDefaultValue:(CGFloat)defaultValue{
    objc_setAssociatedObject(self, _cmd, @(defaultValue), OBJC_ASSOCIATION_ASSIGN);
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
-(CGFloat)defaultValue{
  return [objc_getAssociatedObject(self, _cmd) floatValue];
}
@end
