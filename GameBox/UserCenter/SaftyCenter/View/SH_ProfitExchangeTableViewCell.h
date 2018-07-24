//
//  SH_ProfitExchangeTableViewCell.h
//  GameBox
//
//  Created by jun on 2018/7/23.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SH_ApiModel.h"

@protocol SH_ProfitExchangeTableViewCellDelegate<NSObject>
-(void)recoveryBtnWithApiId:(NSString *)apiId;
@end
@interface SH_ProfitExchangeTableViewCell : UITableViewCell
@property(nonatomic,weak)id<SH_ProfitExchangeTableViewCellDelegate>delegate;
-(void)updateUIWithApiModel:(SH_ApiModel *)model;
@end

