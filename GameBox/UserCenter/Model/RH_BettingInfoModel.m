//
//  RH_BettingInfoModel.m
//  cpLottery
//
//  Created by luis on 2017/11/2.
//  Copyright © 2017年 luis. All rights reserved.
//

#import "RH_BettingInfoModel.h"

@implementation RH_BettingInfoModel

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
        _showBettingDate = dateStringWithFormatter(_bettime, @"yyyy-MM-dd \n HH:mm:ss") ;
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
/*
-(NSString *)showDetailUrl
{
    if (!_showDetailUrl){
        RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
        if (_mURL.length){
            if ([_mURL containsString:@"http"] || [_mURL containsString:@"https:"]) {
                 _showDetailUrl = [NSString stringWithFormat:@"%@",_mURL] ;
            }else
            {
                NSArray *checkTypeCom = [appDelegate.checkType componentsSeparatedByString:@"+"];
                _showDetailUrl = [NSString stringWithFormat:@"%@://%@%@%@",checkTypeCom[0],appDelegate.headerDomain,checkTypeCom.count == 2 ? [NSString stringWithFormat:@":%@",checkTypeCom[1]] : @"",_mURL];
                NSLog(@"");
            }
           
        }
    }
    return _showDetailUrl ;
    
}
*/
@end
