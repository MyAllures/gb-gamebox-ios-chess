//
//  SH_HandRecordTableViewCell.h
//  GameBox
//
//  Created by sam on 2018/7/26.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SH_HandRecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *apiNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *betTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *singleAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *profitAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStateLabel;

@end
