//
//  RH_MineInfoModel.h
//  GameBox
//
//  Created by Paul on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "JSONModel.h"

@interface RH_MineInfoModel : JSONModel
@property(nonatomic,strong,readonly) NSString  *avatalUrl ;
@property(nonatomic,strong,readonly) NSString  *currency ;
@property(nonatomic,strong,readonly) NSString  *preferentialAmount ;
@property(nonatomic,strong,readonly) NSString  *loginTime ;
@property(nonatomic,strong,readonly) NSString  *recomdAmount ;
@property(nonatomic,assign,readonly) float  totalAssets ;
@property(nonatomic,assign,readonly) float   transferAmount ;
@property(nonatomic,assign,readonly) float   unReadCount ;
@property(nonatomic,strong,readonly) NSString  *userName ;
@property(nonatomic,assign,readonly) float  walletBalance ;
@property(nonatomic,assign,readonly) float  withdrawAmount ;
@property(nonatomic,assign,readonly) BOOL  isBit ;
@property(nonatomic,assign,readonly) BOOL   isCash ;
@property(nonatomic,assign,readonly) BOOL   isAutoPay ;
@end
