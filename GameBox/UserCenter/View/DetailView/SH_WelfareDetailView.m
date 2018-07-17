//
//  SH_WelfareDetailView.m
//  GameBox
//
//  Created by Paul on 2018/7/17.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_WelfareDetailView.h"
#import "SH_NetWorkService+UserCenter.h"
#import "RH_CapitalDetailModel.h"
#import "RH_CapitalRecordDetailsCell.h"
@interface SH_WelfareDetailView()<UITableViewDelegate,UITableViewDataSource>
{
    RH_CapitalDetailModel * model;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
@implementation SH_WelfareDetailView
+(instancetype)instanceWelfareDetailView{
    return [[NSBundle  mainBundle] loadNibNamed:NSStringFromClass([self  class]) owner:nil options:nil].lastObject;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{
    [super  awakeFromNib];
    [self  configUI];
}
-(void)configUI{
    __weak typeof(self)  weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader  headerWithRefreshingBlock:^{
        [weakSelf  getHttpData];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 303;
    [self.tableView registerNib:[UINib nibWithNibName:@"RH_CapitalRecordDetailsCell" bundle:nil] forCellReuseIdentifier:@"RH_CapitalRecordDetailsCell"];
}
-(void)getHttpData{
    __weak typeof(self)  weakSelf = self;
    [SH_NetWorkService  fetchDepositListDetail:self.searchId complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        [weakSelf.tableView.mj_header endRefreshing];
        NSDictionary  * result = ConvertToClassPointer(NSDictionary, response);
        if ([result boolValueForKey:@"success"]) {
            NSError * error;
            self-> model = [[RH_CapitalDetailModel alloc] initWithDictionary:result[@"data"] error:&error];
            [weakSelf.tableView  reloadData];
        }
        
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

#pragma mark ----  tableview dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RH_CapitalRecordDetailsCell * cell = [tableView  dequeueReusableCellWithIdentifier:@"RH_CapitalRecordDetailsCell" forIndexPath:indexPath];
    [cell updateCellWithInfo:@{@"RH_CapitalInfoModel":self.infoModel?:@""} context:model];
    return  cell;
}

@end
