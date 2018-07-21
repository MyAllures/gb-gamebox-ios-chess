//
//  SH_CardRecordView.m
//  GameBox
//
//  Created by egan on 2018/7/15.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_CardRecordView.h"
#import "SH_CardRecordHeaderView.h"
#import "SH_NetWorkService+UserCenter.h"
#import "SH_CardRecordTableViewCell.h"
#import "SH_CardRecordModel.h"
#import "SH_CardRecordDetailView.h"
#import "GameWebViewController.h"
@interface  SH_CardRecordView()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger page;
    NSString * startTime;
    NSString * endTime;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)SH_CardRecordHeaderView *headerView;
@property(nonatomic,strong)NSMutableArray * dataArray;
@end
@implementation SH_CardRecordView
+(instancetype)instanceCardRecordView{
    return [[NSBundle  mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self  configUI];
    page =0;
    startTime =dateString([NSDate date], @"yyyy-MM-dd");
    endTime  = dateString([NSDate date], @"yyyy-MM-dd");
}
#pragma  mark --- 配置UI
-(void)configUI{
    UIView * v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frameWidth, 90)];
    [v addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(v);
    }];
    self.tableView.tableHeaderView = v;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.rowHeight = 44;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView  registerNib:[UINib  nibWithNibName:@"SH_CardRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"SH_CardRecordTableViewCell"];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    __weak  typeof(self)  weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader  headerWithRefreshingBlock:^{
        self->page =0;
        [SH_NetWorkService  fetchBettingList:self->startTime EndDate:self->endTime PageNumber:self->page PageSize:20 withIsStatistics:false complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
            [weakSelf.tableView.mj_header endRefreshing];
            NSDictionary  * dic = ConvertToClassPointer(NSDictionary, response);
            if ([dic boolValueForKey:@"success"]) {
                SH_CardRecordModel  * model = [[SH_CardRecordModel alloc] initWithDictionary:dic[@"data"] error:nil];
                if (weakSelf.dataArray.count >0) {
                    [weakSelf.dataArray  removeAllObjects];
                }
                if (model.list.count ==20) {
                    weakSelf.tableView.mj_footer.hidden = false;
                }else{
                    weakSelf.tableView.mj_footer.hidden = YES;
                }
                weakSelf.dataArray = model.list.mutableCopy;
                
                [weakSelf.tableView  reloadData];
            }
            
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
             [weakSelf.tableView.mj_header endRefreshing];
        }];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter  footerWithRefreshingBlock:^{
        self->page ++;
        [SH_NetWorkService  fetchBettingList:self->startTime EndDate:self->endTime PageNumber:self->page PageSize:20 withIsStatistics:false complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
             [weakSelf.tableView.mj_footer endRefreshing];
            NSDictionary  * dic = ConvertToClassPointer(NSDictionary, response);
            if ([dic boolValueForKey:@"success"]) {
                SH_CardRecordModel  * model = [[SH_CardRecordModel alloc] initWithDictionary:dic[@"data"] error:nil];
                if (model.list.count <20) {
                    weakSelf.tableView.mj_footer.hidden = YES;
                }
                [weakSelf.dataArray addObjectsFromArray:model.list];
                [weakSelf.tableView  reloadData];
            }
            
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
               [weakSelf.tableView.mj_footer endRefreshing];
        }];
    }];
    self.tableView.mj_footer.hidden = YES;
    [self.tableView.mj_header  beginRefreshing];
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
#pragma mark --- tableView  delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SH_CardRecordTableViewCell * cell = [tableView  dequeueReusableCellWithIdentifier:@"SH_CardRecordTableViewCell" forIndexPath:indexPath];
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
#pragma 牌局详情 webview 展示 
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
    RH_BettingInfoModel * info = ConvertToClassPointer(RH_BettingInfoModel, self.dataArray[indexPath.row]);
    NSLog(@"----%@",info.mId);
   /* GameWebViewController * webDetail = [[GameWebViewController  alloc] init];
    webDetail.url = info.url;
    [self.alertVC  presentViewController:webDetail animated:YES completion:nil];*/
    SH_CardRecordDetailView * cardDetail = [SH_CardRecordDetailView  instanceCardRecordDetailView];
    cardDetail.mId = info.mId;
    AlertViewController *dcr  = [[AlertViewController  alloc] initAlertView:cardDetail viewHeight:[UIScreen mainScreen].bounds.size.height-60 titleImageName:@"title10" alertViewType:AlertViewTypeLong];
    [self presentViewController:dcr addTargetViewController:self.alertVC];
}
#pragma mark --- 模态弹出viewController
-(void)presentViewController:(UIViewController*)viewController addTargetViewController:(UIViewController*)targetVC{
    viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    viewController.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    [targetVC presentViewController:viewController animated:YES completion:nil];
}
#pragma  amark --- getter method
-(SH_CardRecordHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [SH_CardRecordHeaderView  instanceCardRecordHeaderView];
        __weak  typeof(self)  weakSelf = self;
        _headerView.searchConditionBlock = ^(NSDictionary *context) {
            NSLog(@"%@----",context);
            self->startTime = context[@"startTime"];
            self->endTime = context[@"endTime"];
            MBProgressHUD * hud = showHUDWithMyActivityIndicatorView(weakSelf, nil, @"正在搜索...");
            [SH_NetWorkService  fetchBettingList:context[@"startTime"] EndDate:context[@"endTime"] PageNumber:self->page PageSize:20 withIsStatistics:false complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
                [hud hideAnimated:false];
                NSDictionary  * dic = ConvertToClassPointer(NSDictionary, response);
                if ([dic boolValueForKey:@"success"]) {
                    SH_CardRecordModel  * model = [[SH_CardRecordModel alloc] initWithDictionary:dic[@"data"] error:nil];
                    if (model.list.count ==20) {
                        weakSelf.tableView.mj_footer.hidden = false;
                    }else{
                        weakSelf.tableView.mj_footer.hidden = YES;
                    }
                    if (weakSelf.dataArray.count) {
                        [weakSelf.dataArray removeAllObjects];
                    }
                    [weakSelf.dataArray  addObjectsFromArray:model.list];
                    [weakSelf.tableView  reloadData];
                }
                
            } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
                [hud hideAnimated:false];
            }];
        };
    }
    return  _headerView;
}
#pragma mark --- getter  method
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray  array];
    }
    return  _dataArray;
}
#pragma mark --- setter method
-(void)setAlertVC:(AlertViewController *)alertVC{
    _alertVC = alertVC;
    self.headerView.alertVC = alertVC;
}
@end
