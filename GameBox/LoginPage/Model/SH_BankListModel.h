//
//  SH_BankListModel.h
//  GameBox
//
//  Created by jun on 2018/7/19.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "JSONModel.h"
@protocol SH_BankListModel;
@interface SH_BankListModel : JSONModel
@property (nonatomic,copy) NSString *bankCode ;
@property (nonatomic,copy) NSString *bankName ;
@end
