//
//  NSString+CLCategory.h
//  CoreLib
//
//  Created by apple pro on 2016/11/23.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CLCategory)
//返回所有出现string的范围
- (NSArray *)allRangeOfString:(NSString *)string;

//space长度添加一个间距
- (NSString *)stringByInsertMark:(NSString *)mark withSpace:(NSUInteger)space;
- (NSString *)stringByInsertMark:(NSString *)mark withSpace:(NSUInteger)space reverse:(BOOL)reverse;
- (NSString *) trim ;
@end
