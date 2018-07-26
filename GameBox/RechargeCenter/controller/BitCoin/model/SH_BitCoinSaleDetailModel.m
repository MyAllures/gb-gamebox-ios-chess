//
//  SH_BitCoinSaleDetailModel.m
//  GameBox
//
//  Created by jun on 2018/7/12.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_BitCoinSaleDetailModel.h"

@implementation SH_BitCoinSaleDetailModel

+ (BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"ID":@"id"}];
}

@end
