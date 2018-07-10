//
//  NSString+CLCategory.m
//  CoreLib
//
//  Created by apple pro on 2016/11/23.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import "NSString+CLCategory.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation NSString (CLCategory)
- (NSArray *)allRangeOfString:(NSString *)string
{
    if (string.length == 0 || self.length == 0) {
        return nil;
    }

    NSMutableArray * ranges = [NSMutableArray array];
    NSRange filterRange = [self rangeOfString:string];
    while (filterRange.length) {
        [ranges addObject:[NSValue valueWithRange:filterRange]];
        filterRange = [self rangeOfString:string options:NSCaseInsensitiveSearch range:NSMakeRange(filterRange.location + filterRange.length, self.length - filterRange.location - filterRange.length)];
    }

    return ranges;
}

- (NSString *)stringByInsertMark:(NSString *)mark withSpace:(NSUInteger)space {
    return [self stringByInsertMark:mark withSpace:space reverse:NO];
}

- (NSString *)stringByInsertMark:(NSString *)mark withSpace:(NSUInteger)space reverse:(BOOL)reverse
{
    if (self.length < space || space <= 0 || mark.length == 0) {
        return self;
    }

    NSInteger count = ceilf(self.length / (CGFloat)space) - 1;
    NSMutableString * string = [NSMutableString stringWithCapacity:self.length + count];
    for (NSInteger i = 0; i <= count ; ++ i) {

        if (reverse) {

            [string insertString:[self substringWithRange:NSMakeRange(MAX(0, (NSInteger)(self.length - i * space - space)), MIN(space, self.length - i * 4))] atIndex:0];

            if (i < count) {
                [string insertString:mark atIndex:0];
            }

        }else {

            [string appendString:[self substringWithRange:NSMakeRange(i * space, MIN(space, self.length - i * space))]];

            if (i < count) {
                [string appendString:mark];
            }
        }
    }

    return [NSString stringWithString:string];

}

//截取字符串前后空格
- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
@end
