//
//  SH_LookJiHeView.m
//  GameBox
//
//  Created by jun on 2018/7/16.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_LookJiHeView.h"
#import "SH_LookJiHeTableViewCell.h"
#import "SH_NetWorkService+Profit.h"
@interface SH_LookJiHeView()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property(nonatomic,strong)NSArray *dataArray;
@end
@implementation SH_LookJiHeView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self loadData];
    [self configUI];
}
-(void)loadData{
    [SH_NetWorkService jiHeListSuccess:^(SH_JiHeModel *model) {
        self.dataArray = model.withdrawAudit;
        [self.mainTableView reloadData];
    } Failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
}
-(void)configUI{
    self.mainTableView.delegate  = self;
    self.mainTableView.dataSource = self;
    [self.mainTableView registerNib:[UINib nibWithNibName:@"SH_LookJiHeTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SH_LookJiHeTableViewCell"];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 32;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SH_LookJiHeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SH_LookJiHeTableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell updaetUIWithModel:self.dataArray[indexPath.row]];
    return cell;
}
- (void)setTargetVC:(UIViewController *)targetVC{
    _targetVC = targetVC;
}
@end
