//
//  UIView+CornerRadius.h
//  IBinspectableDemo
//
//  Created by Paul on 2018/8/9.
//  Copyright © 2018年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CornerRadius)
@property(nonatomic,assign)IBInspectable CGFloat  cornerRadius;
@property(nonatomic,strong)IBInspectable UIColor *color;
@property(nonatomic,assign)IBInspectable CGFloat borderWidth;
@end
