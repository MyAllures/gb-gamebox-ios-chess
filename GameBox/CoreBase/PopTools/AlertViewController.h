//
//  AlertViewController.h
//  GameBox
//
//  Created by Paul on 2018/7/6.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_BaseViewController.h"

typedef NS_ENUM(NSUInteger ,AlertViewType){
    AlertViewTypeLong,
    AlertViewTypeShort
} ;
@class AlertViewController;
typedef void(^alertViewDismissBlock)(void);
@interface AlertViewController : SH_BaseViewController
@property(nonatomic,copy)NSString * subTitle;
@property(nonatomic,copy,readonly)NSString * imageName;
@property(nonatomic,copy)alertViewDismissBlock dismissBlock;
@property (weak, nonatomic) IBOutlet UIView *animationView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
/**
 自定义弹窗
 @param view 自定义的UIView
 @param height 自定义的UIView的高度
 @return return value description
 */
-(instancetype)initAlertView:(UIView*)view
                  viewHeight:(CGFloat)height
              titleImageName:(NSString*)imageName
               alertViewType:(AlertViewType)type;
-(void)close;
-(void)setImageName:(NSString *)imageName;
@end
