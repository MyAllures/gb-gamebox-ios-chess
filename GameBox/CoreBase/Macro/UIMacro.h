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

#define NAVI_STATUBAR_HEIGHT     iPhoneX?84.f:64.f
#define WIDTH   [UIScreen mainScreen].bounds.size.width
#define HEIGHT   [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH  WIDTH < HEIGHT ? WIDTH : HEIGHT
#define SCREEN_HEIGHT  WIDTH < HEIGHT ? HEIGHT : WIDTH

#define WIDTH_PERCENT  SCREEN_WIDTH/375.0
#define HEIGHT_PERCENT SCREEN_HEIGHT/667.0


#define  colorWithRGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define ifRespondsSelector(_obj,_sel)  if (_obj&&[(NSObject *)_obj respondsToSelector:_sel])

#endif /* UI_h */
