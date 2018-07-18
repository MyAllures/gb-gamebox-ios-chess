//
//  SH_BankCardModel.h
//  GameBox
//
//  Created by jun on 2018/7/18.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "JSONModel.h"

@protocol SH_BankCardModel;
@interface SH_BankCardModel : JSONModel

@property (nonatomic,copy) NSString <Optional>*bankDeposit ; //开户行
@property (nonatomic,copy) NSString <Optional>*bankName; //从bankList取
@property (nonatomic,copy) NSString <Optional>*bankNameCode;
@property (nonatomic,copy) NSString <Optional>*bankcardMasterName; //卡姓名
@property (nonatomic,copy) NSString <Optional>*bankcardNumber ;
@property (nonatomic,copy) NSString <Optional>*bankUrl ; //开户行图片链接
@property (nonatomic,copy) NSString <Optional>*realName ; //开户行图片链接
@end
