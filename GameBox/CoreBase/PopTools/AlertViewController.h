//
//  AlertViewController.h
//  GameBox
//
//  Created by Paul on 2018/7/6.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_BaseViewController.h"
@protocol AlertViewControllerDelegate<NSObject>
@optional
-(void)buttonClickWithIndex:(NSInteger)index;
@end
@class AlertViewController;
typedef void(^alertViewDismissBlock)(void);
@interface AlertViewController : SH_BaseViewController
@property(nonatomic,copy)NSString * imageName;
@property(nonatomic,copy)NSString * subTitle;
@property(nonatomic,copy)alertViewDismissBlock dismissBlock;
@property (weak, nonatomic) IBOutlet UIView *animationView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property(nonatomic,assign)id<AlertViewControllerDelegate>delegate;
/**
 自定义弹窗
 @param view 自定义的UIView 或者vc
 @param height 自定义的UIView的高度
 @param width 自定义的UIView的宽度
 @return return value description
 */
-(instancetype)initAlertView:(id)view viewHeight:(CGFloat)height viewWidth:(CGFloat)width ;
@end
