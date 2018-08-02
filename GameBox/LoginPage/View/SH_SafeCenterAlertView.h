//
//  SH_SafeCenterAlertView.h
//  GameBox
//
//  Created by sam on 2018/8/2.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertViewController.h"

@interface SH_SafeCenterAlertView : UIView
@property(nonatomic,strong)AlertViewController  * vc;
+(instancetype)instanceSafeCenterAlertView;
@end
