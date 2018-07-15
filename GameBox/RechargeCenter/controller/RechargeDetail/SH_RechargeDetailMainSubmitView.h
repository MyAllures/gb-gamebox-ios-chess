//
//  SH_RechargeDetailMainSubmitView.h
//  GameBox
//
//  Created by jun on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SH_RechargeCenterChannelModel.h"
@protocol SH_RechargeDetailMainSubmitViewDelegate<NSObject>
//支付宝有一个真实姓名 ，所以其他方式的这个字段传nil
-(void)submitRealName:(NSString *)realName AccountNum:(NSString *)accountNum OrderNum:(NSString *)orderNum;

@end
@interface SH_RechargeDetailMainSubmitView : UIView
@property(nonatomic,weak)id<SH_RechargeDetailMainSubmitViewDelegate>delegate;
-(void)updateWithChannelModel:(SH_RechargeCenterChannelModel *)channelModel;
@end
