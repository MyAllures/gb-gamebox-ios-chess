//
//  RH_RegisetInitModel.m
//  gameBoxEx
//
//  Created by Richard on 2018/3/23.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_RegisetInitModel.h"
#import "coreLib.h"

@implementation RH_RegisetInitModel
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return  YES;
}
@end


@implementation IpLocaleModel
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return  YES;
}
@end

@implementation ParamsModel
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return  YES;
}
@end

@implementation SignUpDataMapModel
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]  initWithModelToJSONDictionary:@{@"m110":@"110",@"m201":@"201",@"m301":@"301",@"m304":@"304"}] ;
}
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return  YES;
}
@end

@implementation FieldModel
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper  alloc] initWithModelToJSONDictionary:@{@"mId":@"id"}];
}
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return  YES;
}
@end

@implementation SexModel
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper  alloc] initWithModelToJSONDictionary:@{@"mValue":@"value",@"mText":@"text"}];
}
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return  YES;
}
@end

@implementation DefaultLocaleModel
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper  alloc] initWithModelToJSONDictionary:@{@"mValue":@"value",@"mText":@"text"}];
}
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return  YES;
}
@end

@implementation MainCurrencyModel
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper  alloc] initWithModelToJSONDictionary:@{@"mValue":@"value",@"mText":@"text"}];
}
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return  YES;
}
@end

@implementation SecurityIssuesModel
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper  alloc] initWithModelToJSONDictionary:@{@"mValue":@"value",@"mText":@"text"}];
}
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return  YES;
}
@end

@implementation SelectOptionModel
+(JSONKeyMapper *)keyMapper{
     return [[JSONKeyMapper  alloc] initWithModelToJSONDictionary:@{@"mValue":@"value",@"mText":@"text"}];
}
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return  YES;
}
@end

