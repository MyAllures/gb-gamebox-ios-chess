//
//  SH_ApplyResultView.m
//  GameBox
//
//  Created by jun on 2018/8/14.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_ApplyResultView.h"

@interface SH_ApplyResultView()
@property (weak, nonatomic) IBOutlet SH_WebPImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *messageLab;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
@implementation SH_ApplyResultView

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (IBAction)contactService:(id)sender {
    //联系客服
}
@end
