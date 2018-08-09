//
//  SH_PromoAlertView.m
//  GameBox
//
//  Created by jun on 2018/8/9.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_PromoAlertView.h"
#import "SH_PromoAlertTableViewCell.h"
@interface SH_PromoAlertView()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
@implementation SH_PromoAlertView
- (void)awakeFromNib{
    [super awakeFromNib];
    self.bgView.layer.borderWidth = 2;
    self.bgView.layer.borderColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.25].CGColor;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.mainTableView registerNib:[UINib nibWithNibName:@"SH_PromoAlertTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SH_PromoAlertTableViewCell"];
    
}
#pragma mark--
#pragma mark--tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SH_PromoAlertTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SH_PromoAlertTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
@end
