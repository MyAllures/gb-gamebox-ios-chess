//
//  SH_FundListModel.m
//  GameBox
//
//  Created by Paul on 2018/7/17.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_FundListModel.h"

@implementation SH_FundListModel
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper  alloc] initWithModelToJSONDictionary:@{@"mId":@"id"}];
}
@end
