//
//  SH_MyMsgTabelViewCell.m
//  GameBox
//
//  Created by sam on 2018/7/13.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_MyMsgTabelViewCell.h"

@implementation SH_MyMsgTabelViewCell

- (IBAction)seleteAction:(UIButton
                          *)sender {
    
    sender.selected = !sender.selected;
    NSLog(@"tag===%ld",(long)sender.tag);
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)sender.tag],@"row", nil];
    NSNotification *noti = [NSNotification notificationWithName:@"changedImage1" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:noti];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
