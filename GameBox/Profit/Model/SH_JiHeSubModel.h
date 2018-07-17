//
//  SH_JiHeSubModel.h
//  GameBox
//
//  Created by jun on 2018/7/17.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "JSONModel.h"
@protocol SH_JiHeSubModel;
@interface SH_JiHeSubModel : JSONModel
@property(nonatomic,copy)NSString <Optional>*createTime;
@property(nonatomic,copy)NSString <Optional>*rechargeAmount;
@property(nonatomic,copy)NSString <Optional>*rechargeAudit;
@property(nonatomic,copy)NSString <Optional>*rechargeRemindAudit;
@property(nonatomic,copy)NSString <Optional>*rechargeFee;
@property(nonatomic,copy)NSString <Optional>*favorableAmount;
@property(nonatomic,copy)NSString <Optional>*favorableAudit;
@property(nonatomic,copy)NSString <Optional>*favorableRemindAudit;
@property(nonatomic,copy)NSString <Optional>*favorableFee;
@end
