//
//  SH_AlertView.h
//  GameBox
//
//  Created by Paul on 2018/7/14.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SH_AlertView : UIView
@property(nonatomic,copy)void(^btnClickBlock)(NSInteger tag);
+(instancetype)instanceAlertView;
@end
