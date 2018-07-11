//
//  UIColor+HexString.h
//  CoreLib
//
//  Created by apple pro on 2016/11/18.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIColor (HexString)
+ (UIColor *)colorWithHexStr:(NSString *)hexString;

+ (UIColor *)colorWithHexStr:(NSString *)hexString alpha:(CGFloat)alpha;

- (NSString *)hexString;
@end
