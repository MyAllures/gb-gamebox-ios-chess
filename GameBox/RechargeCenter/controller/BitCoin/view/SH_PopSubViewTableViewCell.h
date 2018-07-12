//
//  SH_PopSubViewTableViewCell.h
//  GameBox
//
//  Created by jun on 2018/7/12.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SH_BitCoinSaleDetailModel.h"
@interface SH_PopSubViewTableViewCell : UITableViewCell
-(void)updateUIWithSaleDetailModel:(SH_BitCoinSaleDetailModel *)model;
@end
