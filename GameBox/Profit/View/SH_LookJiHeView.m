//
//  SH_LookJiHeView.m
//  GameBox
//
//  Created by jun on 2018/7/16.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_LookJiHeView.h"
#import "SH_LookJiHeTableViewCell.h"
@interface SH_LookJiHeView()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@end
@implementation SH_LookJiHeView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self configUI];
}
-(void)configUI{
    self.mainTableView.delegate  = self;
    self.mainTableView.dataSource = self;
    [self.mainTableView registerNib:[UINib nibWithNibName:@"SH_LookJiHeTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SH_LookJiHeTableViewCell"];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SH_LookJiHeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SH_LookJiHeTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)setTargetVC:(UIViewController *)targetVC{
    _targetVC = targetVC;
}
@end
