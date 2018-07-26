//
//  SH_RechargeCenterChannelModel.m
//  GameBox
//
//  Created by jun on 2018/7/9.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_RechargeCenterChannelModel.h"

@implementation SH_RechargeCenterChannelModel
+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"ID":@"id"}];
}
@end
