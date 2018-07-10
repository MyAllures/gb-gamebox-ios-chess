//
//  UIColor+HexString.m
//  CoreLib
//
//  Created by apple pro on 2016/11/18.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import "UIColor+HexString.h"
#import "MacroDef.h"

@implementation UIColor (HexString)
+ (UIColor *)colorWithHexStr:(NSString *)hexString {
    return [self colorWithHexStr:hexString alpha:1.f];
}

+ (UIColor *)colorWithHexStr:(NSString *)hexString alpha:(CGFloat)alpha
{
    if (hexString.length == 0) {
        return nil;
    }

    if ([hexString characterAtIndex:0] == '#') {
        hexString = [hexString stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"0x"];
    }

    if (hexString.length == 8 && [[hexString substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"0x"]){

        unsigned hexNumber = 0.f;

        NSScanner *hexValueScanner = [NSScanner scannerWithString:hexString];
        [hexValueScanner scanHexInt:&hexNumber];

        return [ColorWithNumberRGB(hexNumber) colorWithAlphaComponent:alpha];
    }else if (hexString.length==6){
        NSString *redStr = [NSString stringWithFormat:@"%lu",strtoul([[hexString substringWithRange:NSMakeRange(0, 2)] UTF8String], 0, 16)];
        NSString *greenStr = [NSString stringWithFormat:@"%lu",strtoul([[hexString substringWithRange:NSMakeRange(2, 2)] UTF8String], 0, 16)];
        NSString *blueStr = [NSString stringWithFormat:@"%lu",strtoul([[hexString substringWithRange:NSMakeRange(4, 2)] UTF8String], 0, 16)];

        return [self colorWithRed:[redStr integerValue] / 255.0 green:[greenStr integerValue] / 255.0 blue:[blueStr integerValue] / 255.0 alpha:alpha];
    }

    return nil;
}

- (NSString *)hexString
{
    CGFloat red,green,blue;

    if ([self getRed:&red green:&green blue:&blue alpha:nil]) {

        UInt8 _red   = red * UINT8_MAX;
        UInt8 _green = red * UINT8_MAX;
        UInt8 _blue  = red * UINT8_MAX;

        return [NSString stringWithFormat:@"0x%02X%02X%02X",_red,_green,_blue];
    }

    return nil;
}

@end
