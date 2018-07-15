//
//  SH_RechargeDetailMainView.h
//  GameBox
//
//  Created by jun on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SH_RechargeCenterChannelModel.h"
#import "SH_RechargeCenterPaywayModel.h"
#import "SH_RechargeCenterPlatformModel.h"
@protocol SH_RechargeDetailMainViewDelegate<NSObject> //支付宝有一个真实姓名 ，所以其他方式的这个字段传nil
-(void)SH_RechargeDetailMainViewSubmitRealName:(NSString *)realName AccountNum:(NSString *)accountNum OrderNum:(NSString *)orderNum;
@end
@interface SH_RechargeDetailMainView : UIView
@property(nonatomic,weak)id<SH_RechargeDetailMainViewDelegate>delegate;
-(void)updateWithChannelModel:(SH_RechargeCenterChannelModel *)channelModel
                  PaywayModel:(SH_RechargeCenterPaywayModel *)paywayModel
                PlatformModel:(SH_RechargeCenterPlatformModel *)paltformModel;
@end
