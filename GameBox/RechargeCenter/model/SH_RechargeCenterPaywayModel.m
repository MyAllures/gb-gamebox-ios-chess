//
//  SH_RechargeCenterPaywayModel.m
//  GameBox
//
//  Created by jun on 2018/7/9.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_RechargeCenterPaywayModel.h"
@implementation SH_RechargeCenterPaywayModel
+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"mNewActivity":@"newActivity"}];
}
@end
