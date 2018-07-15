//
//  SH_RechargeBankDetailViewController.h
//  GameBox
//
//  Created by jun on 2018/7/11.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_RechargeBasicViewController.h"
#import "SH_RechargeCenterChannelModel.h"
#import "SH_RechargeCenterPlatformModel.h"
#import "SH_RechargeCenterPaywayModel.h"
@interface SH_RechargeBankDetailViewController : SH_RechargeBasicViewController
@property(nonatomic,strong)SH_RechargeCenterPlatformModel *platformModel; //主要记录是哪个平台 0.0
@property(nonatomic,strong)SH_RechargeCenterChannelModel *channelModel;
@property(nonatomic,strong)SH_RechargeCenterPaywayModel *paywayModel;//主要标记银行代码label需不需要展示以及柜台机存款时候存款方式的选择
@property(nonatomic,copy)NSString *money;//存款数目
@end
