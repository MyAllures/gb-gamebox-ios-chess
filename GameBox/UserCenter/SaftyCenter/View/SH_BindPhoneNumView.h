//
//  SH_BindPhoneNumView.h
//  GameBox
//
//  Created by jun on 2018/7/23.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SH_BindPhoneNumView : UIView
@property(nonatomic,strong)UIViewController *targetVC;
-(void)selectBindPhoneNumView;//在安全中心点击绑定手机按钮走这个方法
@end
