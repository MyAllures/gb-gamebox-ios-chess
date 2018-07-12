//
//  UILabel+handle.h
//  test
//
//  Created by jun on 2018/5/1.
//  Copyright © 2018年 jun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (handle)
-(void)setTextWithFirstString:(NSString *)firstString
                 SecondString:(NSString *)secondString
                     FontSize:(CGFloat)fontSize
                        Color:(UIColor *)color;
@end
