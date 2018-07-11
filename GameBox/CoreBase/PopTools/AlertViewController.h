//
//  AlertViewController.h
//  GameBox
//
//  Created by Paul on 2018/7/6.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_BaseViewController.h"
@class AlertViewController;
typedef void(^alertViewDismissBlock)(void);
@interface AlertViewController : SH_BaseViewController
@property(nonatomic,copy)NSString * imageName;
@property(nonatomic,copy)NSString * subTitle;
@property(nonatomic,copy)alertViewDismissBlock dismissBlock;
@property (weak, nonatomic) IBOutlet UIView *animationView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHeight;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@end
