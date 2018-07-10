//
//  ScreenAdaptation.m
//  CoreLib
//
//  Created by apple pro on 2016/11/22.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import "ScreenAdaptation.h"
#import "help.h"


CLScreenSizeType mainScreenType()
{
    CGSize  _screenSize = screenSize();

    if (_screenSize.width <= 320.f) {
        return _screenSize.height < 500.f ? CLScreenSizeTypeSmallSmall : CLScreenSizeTypeSmall;
    }else if (_screenSize.width <= 400.f){
        return CLScreenSizeTypeMiddle;
    }else{
        return CLScreenSizeTypeBig;
    }
}

//适配后的文件名称
NSArray * adaptationResourceNames(NSString * resourceName)
{
    if (resourceName.length) {
        CLScreenSizeType screenType = mainScreenType();
        
        switch (screenType) {
            case CLScreenSizeTypeSmallSmall:
                return @[[resourceName stringByAppendingString:@"@smallsmall"],
                         [resourceName stringByAppendingString:@"@small"]];
                break;
                
            case CLScreenSizeTypeSmall:
                return @[[resourceName stringByAppendingString:@"@small"]];
                break;
                
            case CLScreenSizeTypeMiddle:
                return @[[resourceName stringByAppendingString:@"@middle"]];
                break;
                
            case CLScreenSizeTypeBig:
                return @[[resourceName stringByAppendingString:@"@big"]];
                break;
        }
    }
   
    return nil;
}

NSString * adaptationResourceName(NSString * resourceName)
{
    if (resourceName.length == 0) {
        return nil;
    }

    CLScreenSizeType screenType = mainScreenType();

    switch (screenType) {
        case CLScreenSizeTypeSmallSmall:
            return [resourceName stringByAppendingString:@"@smallsmall"];
            break;

        case CLScreenSizeTypeSmall:
            return [resourceName stringByAppendingString:@"@small"];
            break;

        case CLScreenSizeTypeMiddle:
            return [resourceName stringByAppendingString:@"@middle"];
            break;

        case CLScreenSizeTypeBig:
            return [resourceName stringByAppendingString:@"@big"];
            break;
    }

}

NSString * validAdaptationNibName(NSString * nibName,NSBundle * bundleOrNil)
{
    NSArray * adaptationNibNames = adaptationResourceNames(nibName);
    for (NSString * adaptationNibName in adaptationNibNames) {
        if (nibFileExist(adaptationNibName, bundleOrNil)) {
            return adaptationNibName;
        }
    }

    if(nibFileExist(nibName, bundleOrNil)){
        return nibName;
    }

    return nil;
}

//----------------------------------------------------------

@implementation NSDictionary (ScreenAdaptation)

- (id)adaptationValueForKey:(NSString *)key
{
    id value = nil;

    if (key.length) {
        NSArray * adaptationNames = adaptationResourceNames(key);
        for (NSString * adaptationName in adaptationNames) {
            value = self[adaptationName];
            if (value) break;
        }

        value = value ?: self[key];
    }

    return value;
}

- (id)adaptationValueForKey:(NSString *)key withClass:(Class)valueClass
{
    id value = [self adaptationValueForKey:key];

    if (!valueClass || [value isKindOfClass:valueClass]) {
        return value;
    }

    return nil;
}
- (id)adaptationValueForKey:(NSString *)key canRespondsToSelector:(SEL)selector
{
    id value = [self adaptationValueForKey:key];
    if (!selector || [value respondsToSelector:selector]) {
        return value;
    }

    return nil;
}

- (NSInteger)adaptationIntegerValueForKey:(NSString *)key {
    return [self adaptationIntegerValueForKey:key defaultValue:0];
}
- (NSInteger)adaptationIntegerValueForKey:(NSString *)key defaultValue:(NSInteger)defaultValue
{
    id value = [self adaptationValueForKey:key canRespondsToSelector:@selector(integerValue)];
    return value ? [value integerValue] : defaultValue;
}

- (CGFloat)adaptationFloatValueForKey:(NSString *)key {
    return [self adaptationFloatValueForKey:key defaultValue:0.f];
}
- (CGFloat)adaptationFloatValueForKey:(NSString *)key defaultValue:(CGFloat)defaultValue
{
    id value = [self adaptationValueForKey:key canRespondsToSelector:@selector(floatValue)];
    return value ? [value floatValue] : defaultValue;
}


@end

//----------------------------------------------------------

@implementation UIImage (ScreenAdaptation)

+ (UIImage *)adaptationImageWithName:(NSString *)name
{
    if (name.length == 0) {
        return nil;
    }

    NSString * extension = name.pathExtension;
    NSArray * names = adaptationResourceNames(name.stringByDeletingPathExtension);
    for (NSString * imageName in names) {
        UIImage * image = [self imageNamed:extension.length ? [imageName stringByAppendingPathExtension:extension] : imageName];
        if (image != nil) {
            return image;
        }
    }

    return [UIImage imageNamed:name];
}

@end
