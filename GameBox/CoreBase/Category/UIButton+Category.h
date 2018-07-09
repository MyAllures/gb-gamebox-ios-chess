//
//  UIButton+Category.h
//  test
//
//  Created by jun on 2018/5/20.
//  Copyright © 2018年 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum :NSUInteger{
    /// 图片在左，文字在右
    ButtonPositionStyleDefault,
    /// 图片在右，文字在左
    ButtonPositionStyleRight,
    /// 图片在上，文字在下
    ButtonPositionStyleleTop,
    /// 图片在下，文字在上
    ButtonPositionStyleBottom,
} ButtonPositionStyle;
@interface UIButton (Category)
- (void)ButtonPositionStyle:(ButtonPositionStyle)imagePositionStyle
                    spacing:(CGFloat)spacing;
@end
