//
//  SH_RechargeCenterDataHandle.m
//  GameBox
//
//  Created by jun on 2018/7/9.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_RechargeCenterDataHandle.h"
#import "SH_NetWorkService+RechargeCenter.h"

@implementation SH_RechargeCenterDataHandle
+(void)dealSelectedStatusWithSlectedArray:(NSMutableArray *)selectedArray
                                indexPath:(NSIndexPath *)indexPath
                                DataArray:(NSMutableArray *)dataArray
                           CollectionView:(UICollectionView *)collectionView
                                 Platform:(NSMutableDictionary *)platform
                                   Number:(NSString *)number{
    if (indexPath.section == 0) {
        //选中第一行
        NSMutableArray *array1 = selectedArray[0];
        [array1 exchangeObjectAtIndex:[array1 indexOfObject:@"selected"] withObjectAtIndex:indexPath.row];
        [selectedArray replaceObjectAtIndex:0 withObject:array1];
        SH_RechargeCenterPlatformModel *model = dataArray[indexPath.section][indexPath.row];
        [platform setObject:model.code forKey:@"code"] ;
        [SH_NetWorkService RechargeCenterPayway:model.code Complete:^(SH_RechargeCenterPaywayModel *model) {
            SH_RechargeCenterPaywayModel *paywayModel = model;
            NSArray *payways = paywayModel.arrayList;
            NSArray *moneys = paywayModel.quickMoneys;
            NSMutableArray *sectionTwoArray = [NSMutableArray array];
            if (payways.count > 0) {
                SH_RechargeCenterChannelModel *channelModel = payways[0];
                [platform setObject:channelModel.type forKey:@"type"] ;
            }
            for (int i = 0; i < payways.count; i++) {
                [sectionTwoArray addObject:@"unSelected"];
            }
            [selectedArray replaceObjectAtIndex:1 withObject:sectionTwoArray];
            [dataArray replaceObjectAtIndex:1 withObject:payways?payways:[NSArray array]];
            [dataArray replaceObjectAtIndex:2 withObject:moneys?moneys:[NSArray array]];
            [collectionView reloadData];
           
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            
        }];
        
    }else if (indexPath.section == 1){
        //选中第二 行
        
        //处理平台的type
        SH_RechargeCenterChannelModel *channelModel = dataArray[indexPath.section][indexPath.row];
        [platform setObject:channelModel.type forKey:@"type"] ;
        NSMutableArray *array2 = selectedArray[1];
        if ([array2 containsObject:@"selected"]) {
            //表示只在第二行点击没有点击多第一行
            NSInteger index = [array2 indexOfObject:@"selected"];
            [array2 exchangeObjectAtIndex:index withObjectAtIndex:indexPath.row];
            
        }else{
            //表示选了第一行 重新刷新第二行选中状态数据
            [array2 replaceObjectAtIndex:indexPath.row withObject:@"selected"];
        }
         [selectedArray replaceObjectAtIndex:1 withObject:array2];
//        [collectionView reloadSections:[[NSIndexSet alloc]initWithIndex:indexPath.section]];
        [collectionView reloadData];
    }
}
@end
