//
//  SH_RechargeCenterDataHandle.h
//  GameBox
//
//  Created by jun on 2018/7/9.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SH_RechargeCenterChannelModel.h"

typedef void(^HandleBlock)(SH_RechargeCenterChannelModel *model);
@interface SH_RechargeCenterDataHandle : NSObject

/**
 处理cell的选中状态

 @param selectedArray 状态的数组
 @param indexPath 根据不同的section来处理
 @param dataArray 处理数据源
  @param platform 记录当前平台
 */
+(void)dealSelectedStatusWithSlectedArray:(NSMutableArray *)selectedArray
                                indexPath:(NSIndexPath *)indexPath
                                DataArray:(NSMutableArray *)dataArray
                           CollectionView:(UICollectionView *)collectionView
                                 Platform:(NSMutableDictionary *)platform
                                    Block:(HandleBlock)block;
@end
