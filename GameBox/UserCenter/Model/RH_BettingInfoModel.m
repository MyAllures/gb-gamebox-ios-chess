//
//  RH_BettingInfoModel.m
//  cpLottery
//
//  Created by luis on 2017/11/2.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_BettingInfoModel.h"
#import "SH_TimeZoneManager.h"

@implementation RH_BettingInfoModel
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper  alloc] initWithModelToJSONDictionary:@{@"mId":@"id"}];
}
+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return  YES;
}

-(NSString *)showName
{
    if (!_showName){
        _showName = [NSString stringWithFormat:@"%@\n%@",_apiName,_gameName] ;
    }
    
    return _showName ;
}

-(NSString *)showBettingDate
{
    if (!_showBettingDate){
        NSTimeInterval interval    =_betTime/ 1000.0;
        _showBettingDate = [[SH_TimeZoneManager sharedManager] timeStringFrom:interval format:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    return _showBettingDate ;
}

-(NSString *)showStatus
{
    if (!_showStatus){
        if ([_orderState isEqualToString:@"pending_settle"]){
            _showStatus = @"未结算" ;
        }else if ([_orderState isEqualToString:@"settle"]){
            _showStatus = @"已结算" ;
        }else{
            _showStatus = @"取消订单" ;
        }
    }
    
    return _showStatus ;
}

-(NSString *)showSingleAmount
{
    if (!_showSingleAmount){
        _showSingleAmount = [NSString stringWithFormat:@"%.02f",_singleAmount] ;
    }
    
    return _showSingleAmount ;
}

-(NSString *)showProfitAmount
{
    if (!_showProfitAmount){
        if (_profitAmount==0){
            _showProfitAmount = @"--" ;
        }else{
            _showProfitAmount = [NSString stringWithFormat:@"%.02f",_profitAmount] ;
        }
    }

    return _showProfitAmount ;
}

-(NSString *)showDetailUrl
{
    if (!_showDetailUrl){
        if (_url.length){
            if ([_url containsString:@"http"] || [_url containsString:@"https:"]) {
                 _showDetailUrl = [NSString stringWithFormat:@"%@",_url] ;
            }else
            {
                NSArray *checkTypeCom = [[NetWorkLineMangaer sharedManager].currentHttpType componentsSeparatedByString:@"+"];
                _showDetailUrl = [NSString stringWithFormat:@"%@://%@%@%@",checkTypeCom[0],[NetWorkLineMangaer sharedManager].currentHost,checkTypeCom.count == 2 ? [NSString stringWithFormat:@":%@",checkTypeCom[1]] : @"",_url];
                NSLog(@"");
            }
           
        }
    }
    return _showDetailUrl ;
    
}

@end
