//
//  SH_SiteMsgViewCell.h
//  GameBox
//
//  Created by sam on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SH_SiteMsgViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *advisoryContentLabel;
@property (weak, nonatomic) IBOutlet SH_WebPButton *seleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *advisoryTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mearkReadImageView;


@end
