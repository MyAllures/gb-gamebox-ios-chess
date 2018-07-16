//
//  SH_ProfitModel.h
//  GameBox
//
//  Created by jun on 2018/7/16.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "JSONModel.h"
#import "SH_AuditMapModel.h"
@interface SH_ProfitModel : JSONModel
@property (nonatomic , copy) NSString *auditLogUrl;
@property (nonatomic , copy) SH_AuditMapModel *auditMap;
@property (nonatomic , strong) NSDictionary *bankcardMap;
@property (nonatomic , copy) NSString *currencySign;
@property (nonatomic ,copy) NSString *hasBank;
@property (nonatomic ,copy) NSString *isSafePassword;
@property (nonatomic ,copy) NSString *isBit;
@property (nonatomic ,copy) NSString *isCash;
@property (nonatomic , copy) NSString *token;
@property (nonatomic ,copy) NSString *totalBalance;
@property (nonatomic , strong) NSDictionary *rank;
@end
