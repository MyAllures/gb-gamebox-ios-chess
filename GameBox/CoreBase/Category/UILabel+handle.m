
//
//  UILabel+handle.m
//  test
//
//  Created by jun on 2018/5/1.
//  Copyright © 2018年 jun. All rights reserved.
//

#import "UILabel+handle.h"

@implementation UILabel (handle)
-(void)setTextWithFirstString:(NSString *)firstString
                 SecondString:(NSString *)secondString
                     FontSize:(CGFloat)fontSize
                        Color:(UIColor *)color{
    NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc] initWithString:firstString];
    //富文本的属性通过字典的形式传入
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [UIFont systemFontOfSize:fontSize],NSFontAttributeName,//字体
                                   color,NSForegroundColorAttributeName,//字体颜色
                                   nil ];
    NSRange range = NSMakeRange(0, 0);
    if (firstString&&secondString) {
        range  = [firstString rangeOfString:secondString];
    }
    
    //统一设置富文本对象的属性
    [attributedStr addAttributes:attributeDict range:range];
    self.attributedText = attributedStr;
    
}
@end
