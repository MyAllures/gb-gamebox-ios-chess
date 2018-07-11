//
//  UI.h
//  lotteryBox
//
//  Created by jun on 2018/6/19.
//  Copyright © 2018年 luis. All rights reserved.
//

#ifndef UI_h
#define UI_h

#define iPhoneX  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define NavigationBarHeight     iPhoneX?84.f:64.f
#define TabBarHeight            49.f

#define WIDTH_PERCENT  [UIScreen mainScreen].bounds.size.width/375.0
#define HEIGHT_PERCENT [UIScreen mainScreen].bounds.size.height/667.0
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define  colorWithRGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#endif /* UI_h */
