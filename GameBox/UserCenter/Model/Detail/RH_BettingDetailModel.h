//
//  RH_BettingDetailModel.h
//  cpLottery
//
//  Created by luis on 2017/11/2.
//  Copyright © 2017年 luis. All rights reserved.
//


@interface RH_BettingDetailModel : JSONModel
@property (nonatomic,assign) NSInteger apiID ;
@property(nonatomic,strong) NSString  *apiName ;
@property(nonatomic,assign) NSInteger  apiTypeId ;
@property(nonatomic,strong) NSString  *betDetail ;
@property(nonatomic,assign) NSInteger  betId ;
@property(nonatomic,strong) NSDate     *betTime ;
@property(nonatomic,strong) NSString  *betTypeName ;
@property(nonatomic,strong) NSString  *contributionAmount ;
@property(nonatomic,strong) NSString  *effectiveTradeAmount ;
@property(nonatomic,assign) NSInteger  gameId ;
@property(nonatomic,strong) NSString  *gameName ;
@property(nonatomic,strong) NSString  *gameType ;
@property(nonatomic,strong) NSString  *oddsTypeName ;
@property(nonatomic,strong) NSString  *orderState ;
@property(nonatomic,strong) NSString  *payoutTime ;
@property(nonatomic,strong) NSString  *profitAmount ;
@property(nonatomic,strong) NSString  *resultArray ;
@property(nonatomic,assign) NSInteger  singleAmount ;
@property(nonatomic,assign) NSInteger  terminal ;
@property(nonatomic,strong) NSString  *userName ;


@end
