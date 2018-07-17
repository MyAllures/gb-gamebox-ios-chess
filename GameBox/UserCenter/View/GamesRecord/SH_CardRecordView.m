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
@interface  SH_CardRecordView()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)SH_CardRecordHeaderView *headerView;
@end
@implementation SH_CardRecordView
+(instancetype)instanceCardRecordView{
    return [[NSBundle  mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self  configUI];
}
#pragma  mark --- 配置UI
-(void)configUI{
    UIView * v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frameWidth, 90)];
    [v addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(v);
    }];
    self.tableView.tableHeaderView = v;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
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
#pragma  amark --- getter method
-(SH_CardRecordHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [SH_CardRecordHeaderView  instanceCardRecordHeaderView];
        _headerView.searchConditionBlock = ^(NSDictionary *context) {
            NSLog(@"%@----",context);
            [SH_NetWorkService  fetchBettingList:context[@"startTime"] EndDate:context[@"endTime"] PageNumber:0 PageSize:20 withIsStatistics:false complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
                
                NSLog(@"%@",response);
            } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
                
            }];
        };
    }
    return  _headerView;
}
@end
