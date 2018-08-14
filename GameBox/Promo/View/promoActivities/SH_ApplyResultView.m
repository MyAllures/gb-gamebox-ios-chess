//
//  SH_ApplyResultView.m
//  GameBox
//
//  Created by jun on 2018/8/14.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_ApplyResultView.h"
#import "SH_ApplyFailTableViewCell.h"
@interface SH_ApplyResultView()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet SH_WebPImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *messageLab;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
@implementation SH_ApplyResultView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SH_ApplyFailTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SH_ApplyFailTableViewCell"];
    
}
#pragma mark--
#pragma mark--tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SH_ApplyFailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SH_ApplyFailTableViewCell"];
    return cell;
}
- (IBAction)contactService:(id)sender {
    //联系客服
}
@end
