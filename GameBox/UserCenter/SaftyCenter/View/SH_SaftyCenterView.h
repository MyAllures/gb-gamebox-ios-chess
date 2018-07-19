//
//  SH_SaftyCenterView.h
//  GameBox
//
//  Created by jun on 2018/7/17.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SH_SaftyCenterView : UIView
@property(nonatomic,strong)UIViewController *targetVC;
-(void)selectedWithType:(NSString *)type From:(NSString *)from;
@end
