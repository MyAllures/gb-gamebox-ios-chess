//
//  ScreenAdaptation.h
//  CoreLib
//
//  Created by apple pro on 2016/11/22.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define StatusBarHeight         20.f
#define StatusBarHoldHeight     (GreaterThanIOS7System ? StatusBarHeight : 0.f)
#define NavigationBarHeight     44.f
#define TabBarHeight            49.f
#define STATUS_HEIGHT  [[UIApplication  sharedApplication] statusBarFrame].size.height

//---------------------------------------------

typedef NS_ENUM(int,CLScreenSizeType) {
    CLScreenSizeTypeSmallSmall,
    CLScreenSizeTypeSmall,
    CLScreenSizeTypeMiddle,
    CLScreenSizeTypeBig
};

//---------------------------------------------

//屏幕类型
CLScreenSizeType mainScreenType(void);

//适配后可以使用的资源名称
NSArray * adaptationResourceNames(NSString * resourceName);
NSString * adaptationResourceName(NSString * resourceName);

//适配后的nib文件名称
NSString * validAdaptationNibName(NSString * nibName,NSBundle * bundleOrNil);

//---------------------------------------------


@interface NSDictionary (ScreenAdaptation)

- (id)adaptationValueForKey:(NSString *)key;
- (id)adaptationValueForKey:(NSString *)key withClass:(Class)valueClass;
- (id)adaptationValueForKey:(NSString *)key canRespondsToSelector:(SEL)selector;

- (NSInteger)adaptationIntegerValueForKey:(NSString *)key;
- (NSInteger)adaptationIntegerValueForKey:(NSString *)key defaultValue:(NSInteger)defaultValue;
- (CGFloat)adaptationFloatValueForKey:(NSString *)key;
- (CGFloat)adaptationFloatValueForKey:(NSString *)key defaultValue:(CGFloat)defaultValue;


@end

//---------------------------------------------

@interface UIImage (ScreenAdaptation)

+ (UIImage *)adaptationImageWithName:(NSString *)name;

@end
