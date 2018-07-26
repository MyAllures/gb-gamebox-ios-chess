//
//  SH_WelfareNotesTableViewCell.h
//  GameBox
//
//  Created by sam on 2018/7/26.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SH_WelfareNotesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *statuLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@end
