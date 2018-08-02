//
//  UIAlertView+Block.h
//  CoreLib
//
//  Created by apple pro on 2016/11/23.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^UIAlertViewCallBackBlock)(UIAlertView * alertView,NSInteger buttonIndex);

@interface UIAlertView (Block)<UIAlertViewDelegate>
@property (nonatomic, copy) UIAlertViewCallBackBlock alertViewCallBackBlock;

+ (instancetype)alertWithCallBackBlock:(UIAlertViewCallBackBlock)alertViewCallBackBlock
                                 title:(NSString *)title
                               message:(NSString *)message
                      cancelButtonName:(NSString *)cancelButtonName
                     otherButtonTitles:(NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION;
@end
