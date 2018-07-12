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
                                    Block:(HandleBlock)block{
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
            SH_RechargeCenterChannelModel *channelModel;
            if (payways.count > 0) {
                 channelModel = payways[0];
                block(channelModel);
                [platform setObject:channelModel.type forKey:@"type"] ;
            }
            for (int i = 0; i < payways.count; i++) {
                [sectionTwoArray addObject:@"unSelected"];
            }
            NSMutableArray *chooseMoneyArray =  [NSMutableArray array];
            for (int i = 0; i < moneys.count; i++) {
                //图片名称数组
                NSArray *picNameArray = @[@"chip_blue",@"chip_red",@"chip_yellow",@"chip_green",@"chip_black"];
                if (moneys.count == picNameArray.count) {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                    [dic setObject:moneys[i] forKey:@"num"];
                    [dic setObject:picNameArray[i] forKey:@"imageName"];
                    [chooseMoneyArray addObject:dic];
                }
            }
            [selectedArray replaceObjectAtIndex:1 withObject:sectionTwoArray];
            //这里在线支付有点特别 所以要做特别处理
            if ([channelModel.type isEqualToString:@"2"]&&[channelModel.accountType isEqualToString:@"2"]) {
                if (dataArray.count == 3) {
                    [dataArray removeObjectAtIndex:2];
                    [dataArray replaceObjectAtIndex:1 withObject:chooseMoneyArray?chooseMoneyArray:[NSArray array]];
                }else if(dataArray.count == 2){
                    [dataArray replaceObjectAtIndex:1 withObject:chooseMoneyArray?chooseMoneyArray:[NSArray array]];
                }
            }else{
                if (dataArray.count == 3) {
                    [dataArray replaceObjectAtIndex:1 withObject:payways?payways:[NSArray array]];
                    [dataArray replaceObjectAtIndex:2 withObject:chooseMoneyArray?chooseMoneyArray:[NSArray array]];
                }else if(dataArray.count == 2){
                    [dataArray replaceObjectAtIndex:1 withObject:chooseMoneyArray?chooseMoneyArray:[NSArray array]];
                }
            }
           
            [collectionView reloadData];
           
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            
        }];
        
    }else if (indexPath.section == 1){
        //选中第二 行
        
        //处理平台的type
       SH_RechargeCenterChannelModel *channelModel = dataArray[indexPath.section][indexPath.row];
        [platform setObject:channelModel.type forKey:@"type"] ;
        block(channelModel);
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
