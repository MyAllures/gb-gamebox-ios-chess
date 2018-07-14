//
//  SH_RechargeBankDetailVIew.h
//  GameBox
//
//  Created by jun on 2018/7/11.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SH_RechargeCenterChannelModel.h"
#import "SH_RechargeCenterPlatformModel.h"
#import "SH_RechargeCenterPaywayModel.h"
@protocol SH_RechargeBankDetailViewDelegate<NSObject>
-(void)SH_RechargeBankDetailViewSubmitDepositeWay:(NSString *)depositeWay Person:(NSString *)person Address:(NSString *)address;
@end
@interface SH_RechargeBankDetailView : UIView
@property(nonatomic,weak)id<SH_RechargeBankDetailViewDelegate>delegate;
-(void)updateWithChannelModel:(SH_RechargeCenterChannelModel *)channelModel
                PlatformModel:(SH_RechargeCenterPlatformModel *)platformModel
                  PaywayModel:(SH_RechargeCenterPaywayModel *)paywayModel;
@end
