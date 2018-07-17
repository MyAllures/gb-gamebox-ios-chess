//
//  RH_CapitalDetailModel.m
//  gameBoxEx
//
//  Created by Richard on 2018/1/10.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_CapitalDetailModel.h"

@implementation RH_CapitalDetailModel

+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return  YES;
}
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper  alloc] initWithModelToJSONDictionary:@{@"mId":@"id"}];
}
/*
-(NSString *)showBankURL
{
    if (!_showBankURL){
        RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
        if (_mBankUrl.length){
            if ([_mBankUrl containsString:@"http:"] || [_mBankUrl containsString:@"https:"]) {
                 _showBankURL = [NSString stringWithFormat:@"%@",_mBankUrl] ;
            }else
            {
                if ([[_mBankUrl substringToIndex:1] isEqualToString:@"/"]){
                    _showBankURL = [NSString stringWithFormat:@"%@%@",appDelegate.domain,_mBankUrl] ;
                }else {
                    _showBankURL = [NSString stringWithFormat:@"%@/%@",appDelegate.domain,_mBankUrl] ;
                }
            }
           
        }
    }
    
    return _showBankURL ;
}
*/
@end
