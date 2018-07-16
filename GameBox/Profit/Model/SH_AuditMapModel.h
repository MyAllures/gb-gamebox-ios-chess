//
//  SH_AuditMapModel.h
//  GameBox
//
//  Created by jun on 2018/7/16.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "JSONModel.h"
@protocol SH_AuditMapModel;
@interface SH_AuditMapModel : JSONModel
@property (nonatomic , copy) NSString <Optional>*deductFavorable; //优惠
@property (nonatomic , copy) NSString  <Optional>*counterFee; //手续费
@property (nonatomic , copy) NSString  <Optional>*withdrawFeeMoney;
@property (nonatomic , copy) NSString <Optional>*administrativeFee; //行政费
@property (nonatomic , copy) NSString  <Optional>*actualWithdraw;
@property (nonatomic , copy) NSString <Optional>*transactionNo;
@property (nonatomic , copy) NSString <Optional>*recordList;
@property (nonatomic , copy) NSString <Optional>*withdrawAmount; //最终可取
@end
