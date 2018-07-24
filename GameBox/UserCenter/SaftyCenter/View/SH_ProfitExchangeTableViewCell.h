//
//  SH_ProfitExchangeTableViewCell.h
//  GameBox
//
//  Created by jun on 2018/7/23.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SH_ApiModel.h"
@interface SH_ProfitExchangeTableViewCell : UITableViewCell
-(void)updateUIWithApiModel:(SH_ApiModel *)model;
@end
