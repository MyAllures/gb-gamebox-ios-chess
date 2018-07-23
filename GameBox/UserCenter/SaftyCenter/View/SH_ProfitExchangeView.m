//
//  SH_ProfitExchangeView.m
//  GameBox
//
//  Created by jun on 2018/7/23.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_ProfitExchangeView.h"
#import "SH_ProfitExchangeTableViewCell.h"
@interface SH_ProfitExchangeView()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end
@implementation SH_ProfitExchangeView
- (void)awakeFromNib{
    [super awakeFromNib];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.mainTableView registerNib:[UINib nibWithNibName:@"SH_ProfitExchangeTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SH_ProfitExchangeTableViewCell"];
}

#pragma mark--
#pragma mark--UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 32;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SH_ProfitExchangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SH_ProfitExchangeTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (IBAction)oneKeyRefresh:(id)sender {
}
- (IBAction)oneKeyRecovery:(id)sender {
}


@end
