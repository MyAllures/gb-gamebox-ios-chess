//
//  SH_ApplyDetails.h
//  GameBox
//
//  Created by jun on 2018/8/19.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol SH_ApplyDetailsModel;
@interface SH_ApplyDetailsModel : JSONModel
@property(nonatomic,copy)NSString <Optional>*condition;
@property(nonatomic,copy)NSString <Optional>*showSchedule;
@property(nonatomic,copy)NSString <Optional>*standard;
@property(nonatomic,copy)NSString <Optional>*reached;
@property(nonatomic,copy)NSString <Optional>*checkTime;
@property(nonatomic,copy)NSString <Optional>*mayApply;
@property(nonatomic,copy)NSString <Optional>*transactionNo;
@property(nonatomic,copy)NSString <Optional>*satisfy;
@end
