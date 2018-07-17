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
@interface SH_WelfareDetailView()
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
    __weak typeof(self)  weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader  headerWithRefreshingBlock:^{
        [weakSelf  getHttpData];
    }];
    [self.tableView.mj_header beginRefreshing];
}
-(void)getHttpData{
    __weak typeof(self)  weakSelf = self;
    [SH_NetWorkService  fetchDepositListDetail:self.searchId complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary  * result = ConvertToClassPointer(NSDictionary, response);
        if ([result boolValueForKey:@"success"]) {
            RH_CapitalDetailModel * model = [[RH_CapitalDetailModel alloc] initWithDictionary:result[@"data"] error:nil];
        }
        [weakSelf.tableView.mj_header endRefreshing];
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}
@end
