//
//  NSLayoutConstraint+RH_IBDesignable.m
//  lotteryBox
//
//  Created by jun on 2018/6/21.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "NSLayoutConstraint+RH_IBDesignable.h"
#define kDevice_Is_iPhone4s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6PlusBigMode ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen]currentMode].size) : NO)

#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen]currentMode].size) : NO)

#define KsuitParam (kDevice_Is_iPhone6Plus ?414.0/375.0:(kDevice_Is_iPhone6?1.0:(iPhone6PlusBigMode ?1.01:(kDevice_Is_iPhoneX?1.0:320.0/375.0)))) //以6为基准图
@implementation NSLayoutConstraint (RH_IBDesignable)
- (void)setAdapterScreen:(BOOL)adapterScreen{
    
    if (adapterScreen){
        self.constant = self.constant * KsuitParam;
    }
}

- (BOOL)adapterScreen{
    return YES;
}

@end
