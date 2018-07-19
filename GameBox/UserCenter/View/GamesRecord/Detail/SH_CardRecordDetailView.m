//
//  SH_CardRecordDetailView.m
//  GameBox
//
//  Created by Paul on 2018/7/18.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_CardRecordDetailView.h"
#import "SH_NetWorkService+UserCenter.h"
#import "RH_BettingDetailModel.h"
@interface  SH_CardRecordDetailView()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
@implementation SH_CardRecordDetailView
+(instancetype)instanceCardRecordDetailView{
    return [[NSBundle  mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self loadHttpData];
}
#pragma mark -- 配置界面
-(void)configUI{
    
}
#pragma mark -- 请求数据
-(void)loadHttpData{
    [SH_NetWorkService  fetchBettingDetails:[self.mId integerValue] complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
