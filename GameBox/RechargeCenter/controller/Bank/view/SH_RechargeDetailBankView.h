//
//  SH_RechargeDetailBankView.h
//  GameBox
//
//  Created by jun on 2018/7/11.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SH_RechargeCenterChannelModel.h"
#import "SH_RechargeCenterPlatformModel.h"
#import "SH_RechargeCenterPaywayModel.h"

@protocol SH_RechargeDetailBankViewDelegate<NSObject>
-(void)SH_RechargeDetailBankSubViewWithDepositeWay:(NSString *)depositeWay Person:(NSString *)person Address:(NSString *)address;
@end

@interface SH_RechargeDetailBankView : UIView
@property(nonatomic,weak)id<SH_RechargeDetailBankViewDelegate>delegate;
-(void)updateWithChannelModel:(SH_RechargeCenterChannelModel *)channelModel
                  PaywayModel:(SH_RechargeCenterPaywayModel *)paywayModel
                PlatformModel:(SH_RechargeCenterPlatformModel *)paltformModel;
@end
