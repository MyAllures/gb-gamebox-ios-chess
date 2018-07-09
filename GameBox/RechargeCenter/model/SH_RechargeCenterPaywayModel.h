//
//  SH_RechargeCenterPaywayModel.h
//  GameBox
//
//  Created by jun on 2018/7/9.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "SH_RechargeCenterChannelModel.h"
#import "SH_RechargeCenterAccountModel.h"

@interface SH_RechargeCenterPaywayModel : JSONModel
@property(nonatomic,copy)NSString <Optional>*currency;
@property(nonatomic,copy)NSString <Optional>*customerService;
@property(nonatomic,strong)NSArray<Optional, SH_RechargeCenterChannelModel>*arrayList;
@property(nonatomic,strong)NSArray<Optional, SH_RechargeCenterAccountModel>*counterRechargeTypes;
@property(nonatomic,strong)NSArray *quickMoneys;
@property(nonatomic,copy)NSString <Optional>*payerBankcard;
@property(nonatomic,copy)NSString <Optional>*hide;
@property(nonatomic,copy)NSString <Optional>*mNewActivity;
@property(nonatomic,copy)NSString <Optional>*multipleAccount;
@end
