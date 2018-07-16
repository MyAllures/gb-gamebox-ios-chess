//
//  SH_UserInformationView.h
//  GameBox
//
//  Created by Paul on 2018/7/13.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SH_UserInformationView : UIView
@property(nonatomic,copy)void(^buttonClickBlock)(NSInteger  tag);
+(instancetype)instanceInformationView;

@end
