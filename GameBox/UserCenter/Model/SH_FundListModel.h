//
//  SH_FundListModel.h
//  GameBox
//
//  Created by Paul on 2018/7/17.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "JSONModel.h"
@protocol  SH_FundListModel;
@interface SH_FundListModel : JSONModel
@property(nonatomic,assign)NSInteger mId;
@property(nonatomic,strong)NSDate *createTime;
@property(nonatomic,strong)NSString *transactionMoney;
@property(nonatomic,strong)NSString *transactionType;
@property(nonatomic,strong)NSString *transaction_typeName;
@property(nonatomic,strong)NSString *status;
@property(nonatomic,strong)NSString *statusName;
@end
