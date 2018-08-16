//
//  UIView+BgColor.m
//  GameBox
//
//  Created by jun on 2018/8/16.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "UIView+BgColor.h"
#import "SH_ColorsJsonManager.h"
#import "UIColor+HexString.h"
@implementation UIView (BgColor)
@dynamic bgColor;
- (void)setBgColor:(NSString *)bgColor{
    NSString *hexString = [[[SH_ColorsJsonManager sharedManager] obj] objectForKey:bgColor];
    self.backgroundColor = [UIColor colorWithHexStr:hexString];
}

@end
