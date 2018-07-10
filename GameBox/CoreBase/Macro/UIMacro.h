//
//  UI.h
//  lotteryBox
//
//  Created by jun on 2018/6/19.
//  Copyright © 2018年 luis. All rights reserved.
//

#ifndef UI_h
#define UI_h

#define StatusBarHeight   [[UIApplication  sharedApplication] statusBarFrame].size.height
#define StatusBarHoldHeight     (GreaterThanIOS7System ? StatusBarHeight : 0.f)
#define NavigationBarHeight     44.f
#define TabBarHeight            49.f

#define WIDTH_PERCENT  [UIScreen mainScreen].bounds.size.width/375.0
#define HEIGHT_PERCENT [UIScreen mainScreen].bounds.size.height/667.0
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define  colorWithRGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#endif /* UI_h */
