//
//  SH_BankListModel.m
//  GameBox
//
//  Created by jun on 2018/7/19.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_BankListModel.h"

@implementation SH_BankListModel
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"bankCode":@"value",@"bankName":@"text"}];
}
@end
