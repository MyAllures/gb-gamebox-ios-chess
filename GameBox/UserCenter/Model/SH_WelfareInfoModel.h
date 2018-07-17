//
//  SH_WelfareInfoModel.h
//  GameBox
//
//  Created by Paul on 2018/7/17.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "JSONModel.h"
#import "SH_FundListModel.h"

@interface  SumPlayerMapModel :JSONModel
@property (nonatomic,copy) NSString *recharge;//充值总额
@property (nonatomic,copy) NSString *favorable;//优惠总额
@property (nonatomic,copy) NSString *rakeback;//反水总额
@property (nonatomic,copy) NSString *withdraw;//提现总额
@end

@interface SH_WelfareInfoModel : JSONModel
@property (nonatomic,assign) CGFloat withdrawSum ;
@property (nonatomic,assign) CGFloat transferSum ;
@property (nonatomic,assign) NSInteger mTotalCount ;
@property (nonatomic,strong) NSArray<SH_FundListModel> *fundListApps;
@property (nonatomic,strong) SumPlayerMapModel *sumPlayerMap ;
@property (nonatomic,copy) NSString *minDate;
@property (nonatomic,copy) NSString *maxDate;
@property (nonatomic,copy) NSString *currency;
@property (nonatomic,copy) NSString *totalCount;



@end


