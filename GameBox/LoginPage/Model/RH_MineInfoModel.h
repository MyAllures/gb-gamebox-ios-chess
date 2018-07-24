//
//  RH_MineInfoModel.h
//  GameBox
//
//  Created by Paul on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "JSONModel.h"
#import "SH_BankCardModel.h"
#import "SH_ApiModel.h"
@interface RH_MineInfoModel : JSONModel
@property(nonatomic,strong) NSString  *avatalUrl ;
@property(nonatomic,strong) NSString  *currency ;
@property(nonatomic,strong) NSString  *preferentialAmount ;
@property(nonatomic,strong) NSString  *loginTime ;
@property(nonatomic,strong) NSString  *lastLoginTime ;
@property(nonatomic,strong) NSString  *recomdAmount ;
@property(nonatomic,assign) float  totalAssets ;
@property(nonatomic,assign) float   transferAmount ;
@property(nonatomic,assign) float   unReadCount ;
@property(nonatomic,strong) NSString  *username ;
@property(nonatomic,strong) NSString  *realName ;
@property(nonatomic,assign) float  walletBalance ;
@property(nonatomic,assign) float  withdrawAmount ;
@property(nonatomic,assign) BOOL  isBit ;
@property(nonatomic,assign) BOOL   isCash ;
@property(nonatomic,assign) BOOL   isAutoPay ;
@property(nonatomic,strong)SH_BankCardModel <Optional>*bankcard;
@property(nonatomic,strong)NSArray<Optional,SH_ApiModel>*apis;
@end
