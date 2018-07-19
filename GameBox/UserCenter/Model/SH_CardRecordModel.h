//
//  SH_CardRecordModel.h
//  GameBox
//
//  Created by Paul on 2018/7/18.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "JSONModel.h"
#import "RH_BettingInfoModel.h"
@interface SH_CardRecordModel : JSONModel
@property (nonatomic,copy) NSString *minDate;
@property (nonatomic,copy) NSString *maxDate;
@property (nonatomic,copy) NSString *totalSize;
@property (nonatomic,copy) NSString *statisticsData;
@property (nonatomic,strong)NSArray<RH_BettingInfoModel> *list;
@end
