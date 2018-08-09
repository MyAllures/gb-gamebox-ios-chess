//
//  UIView+CurrentVC.h
//  GameBox
//
//  Created by jun on 2018/8/9.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CurrentVC)
/** 获取当前View的控制器对象 */
-(UIViewController *)getCurrentViewController;
@end
