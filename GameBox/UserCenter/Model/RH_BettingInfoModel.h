//
//  RH_BettingInfoModel.h
//  cpLottery
//
//  Created by luis on 2017/11/2.
//  Copyright © 2017年 luis. All rights reserved.
//


#import <CoreGraphics/CoreGraphics.h>

@interface RH_BettingInfoModel : JSONModel
@property(nonatomic,strong) NSString  *mID ;
@property(nonatomic,assign) NSInteger  apiID ;
@property(nonatomic,strong) NSString*  apiName ;
@property(nonatomic,assign) NSInteger  gameID ;
@property(nonatomic,strong) NSString*  gameName ;
@property(nonatomic,strong) NSString*  terminal ;
@property(nonatomic,strong) NSDate*    bettime    ;
@property(nonatomic,assign) CGFloat    singleAmount ;
@property(nonatomic,assign) CGFloat    profitAmount ;
@property(nonatomic,strong) NSString*  orderState ;
@property(nonatomic,strong) NSString*  uRL ;


//extend
@property (nonatomic,strong) NSString *showName ;
@property (nonatomic,strong) NSString *showBettingDate ;
@property (nonatomic,strong) NSString *showStatus ;
@property (nonatomic,strong) NSString *showSingleAmount ;
@property (nonatomic,strong) NSString *showProfitAmount ;
@property (nonatomic,strong) NSString *showDetailUrl;

@end
