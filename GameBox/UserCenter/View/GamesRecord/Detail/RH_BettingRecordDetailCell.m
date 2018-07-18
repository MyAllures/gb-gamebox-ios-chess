//
//  RH_BettingRecordDetailCell.m
//  gameBoxEx
//
//  Created by lewis on 2018/1/9.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_BettingRecordDetailCell.h"
#import "coreLib.h"
#import "RH_BettingDetailModel.h"

@implementation RH_BettingRecordDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)updateCellWithInfo:(NSDictionary *)info context:(id)context
{
    RH_BettingDetailModel *detailModel = ConvertToClassPointer(RH_BettingDetailModel, context);
    for (int i = 10; i<19; i++) {
        UILabel *lab = [self viewWithTag:i];
        switch (i) {
            case 10:
                lab.text = detailModel.userName;
                break;
            case 11:
                lab.text = [NSString stringWithFormat:@"%ld",detailModel.betId];
                break;
            case 12:
                lab.text =detailModel.apiName;
                break;
            case 13:
                lab.text = nil;
                break;
            case 14:
                lab.text = dateStringWithFormatter(detailModel.betTime, @"yyyy-MM-dd HH:mm:ss");
                break;
            case 15:
                lab.text =[NSString stringWithFormat:@"%ld",detailModel.singleAmount];
                break;
            case 16:
                lab.text = [NSString stringWithFormat:@"%@",detailModel.effectiveTradeAmount];
                break;
            case 17:
                lab.text = detailModel.payoutTime ;
                break;
            case 18:
                lab.text = detailModel.profitAmount;
                break;
            default:
                break;
        }
    }
    
}

@end
