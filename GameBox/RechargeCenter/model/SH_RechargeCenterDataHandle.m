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
                             ChannelArray:(NSMutableArray *)channelArray
                                    Block:(HandleBlock)block{
    if (indexPath.section == 0) {
        //选中第一行
        NSMutableArray *array1 = selectedArray[0];
        [array1 exchangeObjectAtIndex:[array1 indexOfObject:@"selected"] withObjectAtIndex:indexPath.row];
        [selectedArray replaceObjectAtIndex:0 withObject:array1];
        SH_RechargeCenterPlatformModel *model = dataArray[indexPath.section][indexPath.row];
        [SH_NetWorkService RechargeCenterPayway:model.code Complete:^(SH_RechargeCenterPaywayModel *model) {
            SH_RechargeCenterPaywayModel *paywayModel = model;
            NSArray *payways = paywayModel.arrayList;
            NSArray *moneys = paywayModel.quickMoneys;
            NSMutableArray *sectionTwoArray = [NSMutableArray array];
            SH_RechargeCenterChannelModel *channelModel;
            if (payways.count > 0) {
                 channelModel = payways[0];
                [channelArray removeAllObjects];
                [channelArray addObjectsFromArray:payways];
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
                block(channelModel,@[@"",@"请选择或输入金额"],paywayModel);
            }else{
                if (dataArray.count == 3) {
                    [dataArray replaceObjectAtIndex:1 withObject:payways?payways:[NSArray array]];
                    [dataArray replaceObjectAtIndex:2 withObject:chooseMoneyArray?chooseMoneyArray:[NSArray array]];
                }else if(dataArray.count == 2){
                    [dataArray replaceObjectAtIndex:1 withObject:payways?payways:[NSArray array]];
                    [dataArray addObject:chooseMoneyArray?chooseMoneyArray:[NSArray array]];
                }
                block(channelModel,@[@"",@"付款方式",@"请选择或输入金额"],paywayModel);
            }
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            
        }];
        
    }else if (indexPath.section == 1){
        //选中第二 行
         SH_RechargeCenterChannelModel *channelModel = channelArray[indexPath.row];
        //处理平台的type
        if (dataArray.count == 2){
            //当前选中的是在线支付
            block(channelModel,@[@"",@"请选择或输入金额"],nil);
        }else{
            block(channelModel,@[@"",@"付款方式",@"请选择或输入金额"],nil);
            NSMutableArray *array2 = selectedArray[1];
            if ([array2 containsObject:@"selected"]) {
                //表示只在第二行点击没有点击过第一行
                NSInteger index = [array2 indexOfObject:@"selected"];
                [array2 exchangeObjectAtIndex:index withObjectAtIndex:indexPath.row];
                
            }else{
                //表示选了第一行 重新刷新第二行选中状态数据
                [array2 replaceObjectAtIndex:indexPath.row withObject:@"selected"];
            }
            [selectedArray replaceObjectAtIndex:1 withObject:array2];
        }
        }
}
@end
