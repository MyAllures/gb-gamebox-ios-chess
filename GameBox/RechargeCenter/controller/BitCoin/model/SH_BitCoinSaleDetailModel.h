//
//  SH_BitCoinSaleDetailModel.h
//  GameBox
//
//  Created by jun on 2018/7/12.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "JSONModel.h"
@protocol SH_BitCoinSaleDetailModel;
@interface SH_BitCoinSaleDetailModel : JSONModel
@property(nonatomic,copy)NSString<Optional> *ID;
@property(nonatomic,copy)NSString<Optional> *activityName;
@end
