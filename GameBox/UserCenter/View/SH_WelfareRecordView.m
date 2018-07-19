//
//  SH_WelfareRecordView.m
//  GameBox
//
//  Created by Paul on 2018/7/16.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_WelfareRecordView.h"
#import "SH_WelfareView.h"
#import "SH_WelfareTableViewCell.h"
#import "SH_NetWorkService+UserCenter.h"
#import "SH_FundListModel.h"
#import "SH_WelfareInfoModel.h"
@interface  SH_WelfareRecordView()<UITableViewDelegate,UITableViewDataSource>
{
    NSDictionary *dict;
    NSInteger page;
    SH_WelfareInfoModel * model;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)SH_WelfareView * headerView;
@property(nonatomic,strong)NSMutableArray * dataArray;
@end
@implementation SH_WelfareRecordView
+(instancetype)instanceWelfareRecordView{
    return [[[NSBundle  mainBundle] loadNibNamed:NSStringFromClass([self  class]) owner:nil options:nil] lastObject];
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self  configUI];
    page = 0;
    self.headerView.withdrawal_label.text = [NSString  stringWithFormat:@"取款处理中:%.2f",model.withdrawSum];
    self.headerView.transfer_label.text = [NSString  stringWithFormat:@"转账处理中:%.2f",model.transferSum];
    
}
#pragma mark ---  配置UI
-(void)configUI{
    UIView * v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frameWidth, 180)];
    [v addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(v);
    }];
    self.tableView.tableHeaderView = v;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 44.0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView  alloc] initWithFrame:CGRectZero];
    [self.tableView registerNib:[UINib nibWithNibName:@"SH_WelfareTableViewCell" bundle:nil] forCellReuseIdentifier:@"SH_WelfareTableViewCell"];
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self->page = 0;
        [SH_NetWorkService  fetchDepositList:self->dict[@"startTime"]?:dateString([NSDate date], @"yyyy-MM-dd") EndDate:self->dict[@"endTime"]?:dateString([NSDate date], @"yyyy-MM-dd") SearchType:self->dict[@"type"]?:@"" PageNumber:self->page PageSize:20 complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
            [weakSelf.tableView.mj_header endRefreshing];
            NSDictionary * result = ConvertToClassPointer(NSDictionary, response);
            if ([result boolValueForKey:@"success"]) {
                NSError * errer;
                SH_WelfareInfoModel * model = [[SH_WelfareInfoModel  alloc]initWithDictionary:result[@"data"] error:&errer];
                if (weakSelf.dataArray.count >0) {
                    [weakSelf.dataArray  removeAllObjects];
                }
                [weakSelf.dataArray addObjectsFromArray:model.fundListApps];
                if (model.fundListApps.count <20) {
                    weakSelf.tableView.mj_footer.hidden = YES;
                }
                [weakSelf.tableView  reloadData];
            }
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            [weakSelf.tableView.mj_header endRefreshing];
        }];//d
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter  footerWithRefreshingBlock:^{
        self->page ++;
        [SH_NetWorkService  fetchDepositList:self->dict[@"startTime"]?:dateString([NSDate date], @"yyyy-MM-dd") EndDate:self->dict[@"endTime"]?:dateString([NSDate date], @"yyyy-MM-dd") SearchType:self->dict[@"type"]?:@"" PageNumber:self->page PageSize:20 complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
            [weakSelf.tableView.mj_footer endRefreshing];
            NSDictionary * result = ConvertToClassPointer(NSDictionary, response);
            if ([result boolValueForKey:@"success"]) {
                NSError * errer;
                SH_WelfareInfoModel * model = [[SH_WelfareInfoModel  alloc]initWithDictionary:result[@"data"] error:&errer];
                if (model.fundListApps.count <20) {
                    weakSelf.tableView.mj_footer.hidden = YES;
                }
                [weakSelf.dataArray addObjectsFromArray:model.fundListApps];
                [weakSelf.tableView  reloadData];
            }

        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            [weakSelf.tableView.mj_footer endRefreshing];
        }];//d
    }];
     self.tableView.mj_footer.hidden = YES;
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    [self.tableView.mj_header  beginRefreshing];
}
#pragma mark --- getter method
-(SH_WelfareView *)headerView{
    if (!_headerView) {
        _headerView = [SH_WelfareView  instanceWelfareView];
         __weak typeof(self)  weakSelf = self;
        _headerView.dataBlock = ^(NSDictionary *context) {
            self->dict = context;
             MBProgressHUD * hud = showHUDWithMyActivityIndicatorView(weakSelf, nil, @"正在搜索...");
            [SH_NetWorkService  fetchDepositList:context[@"startTime"] EndDate:context[@"endTime"] SearchType:context[@"type"] PageNumber:1 PageSize:20 complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
                [hud hideAnimated:false];
                NSDictionary * result = ConvertToClassPointer(NSDictionary, response);
                if ([result boolValueForKey:@"success"]) {
                    NSError * errer;
                    self->model = [[SH_WelfareInfoModel  alloc]initWithDictionary:result[@"data"] error:&errer];
                    if (weakSelf.dataArray.count) {
                        [weakSelf.dataArray  removeAllObjects];
                    }
                    [weakSelf.dataArray addObjectsFromArray:self->model.fundListApps];
                    if (self->model.fundListApps.count==20) {
                        weakSelf.tableView.mj_footer.hidden = false;
                    }
                    [weakSelf.tableView  reloadData];
                }
               
            } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
                [hud hideAnimated:false];
            }];
        };
    }
    return _headerView;
}
-(void)httpData{
    
}

#pragma mark --- UITableView dataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SH_WelfareTableViewCell * cell = [tableView  dequeueReusableCellWithIdentifier:@"SH_WelfareTableViewCell" forIndexPath:indexPath];
    if (indexPath.item%2==0) {
        cell.contentView.backgroundColor = [UIColor colorWithHexStr:@"0xFAFAFA"];
    }
    else
    {
        cell.contentView.backgroundColor = [UIColor colorWithHexStr:@"0xFFFFFF"];
    }
    [cell updateCellWithInfo:nil context:self.dataArray[indexPath.row]];
    return  cell;
}

#pragma tableView delegate method
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
    SH_FundListModel * model = self.dataArray[indexPath.row];
    NSString * searchId = [NSString  stringWithFormat:@"%ld",model.mId];
    if (self.backToDetailViewBlock) {
        self.backToDetailViewBlock(searchId,model);
    }
}
#pragma mark --- getter method
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

//cell分割线与屏幕等宽，两个方法同时添加iOS 10有效
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
