//
//  SH_RechargeCenterChannelModel.h
//  GameBox
//
//  Created by jun on 2018/7/9.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol SH_RechargeCenterChannelModel;

@interface SH_RechargeCenterChannelModel : JSONModel
@property(nonatomic,copy)NSString <Optional>*ID;
@property(nonatomic,copy)NSString <Optional>*payName;
@property(nonatomic,copy)NSString <Optional>*account;
@property(nonatomic,copy)NSString <Optional>*fullName;
@property(nonatomic,copy)NSString <Optional>*code;
@property(nonatomic,copy)NSString <Optional>*type;
@property(nonatomic,copy)NSString <Optional>*accountType;
@property(nonatomic,copy)NSString <Optional>*bankCode;
@property(nonatomic,copy)NSString <Optional>*bankName;
@property(nonatomic,copy)NSString <Optional>*singleDepositMin;
@property(nonatomic,copy)NSString <Optional>*singleDepositMax;
@property(nonatomic,copy)NSString <Optional>*openAcountName;
@property(nonatomic,copy)NSString <Optional>*qrCodeUrl;
@property(nonatomic,copy)NSString <Optional>*remark;
@property(nonatomic,copy)NSString <Optional>*randomAmount;
@property(nonatomic,copy)NSString <Optional>*aliasName;
@property(nonatomic,copy)NSString <Optional>*customBankName;
@property(nonatomic,copy)NSString <Optional>*accountInformation;
@property(nonatomic,copy)NSString <Optional>*accountPrompt;
@property(nonatomic,copy)NSString <Optional>*rechargeType;
@property(nonatomic,copy)NSString <Optional>*depositWay;
@property(nonatomic,copy)NSString <Optional>*payType;
@property(nonatomic,copy)NSString <Optional>*searchId;
@property(nonatomic,copy)NSString <Optional>*imgUrl;
@end
