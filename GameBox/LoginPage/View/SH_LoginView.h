//
//  SH_LoginView.h
//  GameBox
//
//  Created by Paul on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SH_LoginView : UIView
@property(nonatomic,copy)void (^dismissBlock)(void);
@property(nonatomic,copy)void (^changeChannelBlock)(NSString * string);
+(instancetype)InstanceLoginView;

@end
