//
//  SH_RechargeCenterDataHandle.h
//  GameBox
//
//  Created by jun on 2018/7/9.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SH_RechargeCenterChannelModel.h"
#import "SH_RechargeCenterPaywayModel.h"
typedef void(^HandleBlock)(SH_RechargeCenterChannelModel *model,NSArray *titles,SH_RechargeCenterPaywayModel *paywayModel);
@interface SH_RechargeCenterDataHandle : NSObject

/**
 处理cell的选中状态

 @param selectedArray 状态的数组
 @param indexPath 根据不同的section来处理
 @param dataArray 处理数据源
 */
+(void)dealSelectedStatusWithSlectedArray:(NSMutableArray *)selectedArray
                                indexPath:(NSIndexPath *)indexPath
                                DataArray:(NSMutableArray *)dataArray
                             ChannelArray:(NSMutableArray *)channelArray
                                    Block:(HandleBlock)block;
@end
