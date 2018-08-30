//
//  SH_MsgCenterCell.h
//  GameBox
//
//  Created by shin on 2018/7/25.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SH_MsgCenterCell : UITableViewCell

@property (nonatomic, assign) id model;

- (void)updateSelectedStatus;

@end
