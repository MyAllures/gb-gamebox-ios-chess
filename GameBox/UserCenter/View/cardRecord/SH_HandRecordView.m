
//
//  SH_HandRecordView.m
//  GameBox
//
//  Created by sam on 2018/7/26.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_HandRecordView.h"
#import "SH_HandRecordTableViewCell.h"
#import "SH_NetWorkService+UserCenter.h"
#import "SH_CardRecordModel.h"
#import "RH_BettingInfoModel.h"
#import "HLPopTableView.h"
#import "SH_WaitingView.h"
#import "SH_TimeZoneManager.h"

@interface SH_HandRecordView() <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (strong, nonatomic) NSMutableArray *bettingArr;
@property (strong, nonatomic) NSString *startTimeStr;
@property (strong, nonatomic) NSString *endTimeStr;

@property (assign, nonatomic) NSInteger seleteIndex;
@property (weak, nonatomic) IBOutlet UILabel *effectiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *profitLabel;

@property (weak, nonatomic) IBOutlet SH_WebPImageView *imageView;
@property (assign, nonatomic) NSInteger page;
@property (assign, nonatomic) NSString *noMoreData;
@end

@implementation SH_HandRecordView
+(instancetype)instanceCardRecordView {
    return  [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.imageView.hidden = YES;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"SH_HandRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"SH_HandRecordTableViewCell"];
    self.bettingArr = [NSMutableArray array];
    self.seleteIndex = 3;
    [self changedSinceTimeString:self.seleteIndex];
    [self requestData];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

-(void)loadMoreData {
    if ([self.noMoreData isEqualToString:@"noMoreData"]) {
        [self.tableView.mj_footer resetNoMoreData];
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    self.page = self.page + 1 ;
    [SH_NetWorkService fetchBettingList:self.startTimeStr EndDate:self.endTimeStr PageNumber:self.page PageSize:20 withIsStatistics:YES complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary *dict = (NSDictionary *)response;
        NSLog(@"dict == %@",dict);
        [self.tableView.mj_footer endRefreshing];
        self.effectiveLabel.text = [NSString stringWithFormat:@"福利投注合计:%.2f",[dict[@"data"][@"statisticsData"][@"single"] floatValue]];
        self.profitLabel.text = [NSString stringWithFormat:@"赛果合计:%.2f",[dict[@"data"][@"statisticsData"][@"profit"] floatValue]];
        NSArray *arr = dict[@"data"][@"list"];
        if (arr.count > 0) {
            if (arr.count < 20) {
                self.noMoreData = @"noMoreData";
            }
            for (NSDictionary *dict1 in dict[@"data"][@"list"]) {
                RH_BettingInfoModel *model = [[RH_BettingInfoModel alloc] initWithDictionary:dict1 error:nil];
                [self.bettingArr addObject:model];
                [self.tableView reloadData];
                [SH_WaitingView hide:self];
            }
        }else{
            [SH_WaitingView hide:self];
            [self.tableView reloadData];
        }
        
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        [SH_WaitingView hide:self];
        [self.tableView.mj_footer endRefreshing];
    }];
    
    
}

- (IBAction)searchAction:(SH_WebPButton *)sender {
    [sender setScale];
    [self changedSinceTimeString:self.seleteIndex];
    [self requestData];
}

- (IBAction)seleteTimeAction:(UIButton *)sender {
    NSArray *searchTypeArr = @[@"今天",@"昨天",@"本周",@"近七天"];
    HLPopTableView *popTV = [HLPopTableView initWithFrame:CGRectMake(0, 0, sender.bounds.size.width + 5, 110) dependView:sender textArr:searchTypeArr textFont:14.0 block:^(NSString *region_name, NSInteger index) {
        [self.timeBtn setTitle:region_name forState:UIControlStateNormal];
        self.seleteIndex = index;
    }];
    [self addSubview:popTV];
}

-(void)requestData {
    [self.bettingArr removeAllObjects];
    [SH_WaitingView showOn:self];
    [SH_NetWorkService fetchBettingList:self.startTimeStr EndDate:self.endTimeStr PageNumber:1 PageSize:20 withIsStatistics:YES complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary *dict = (NSDictionary *)response;
        NSLog(@"dict == %@",dict);
        self.effectiveLabel.text = [NSString stringWithFormat:@"福利投注合计:%.2f",[dict[@"data"][@"statisticsData"][@"single"] floatValue]];
        self.profitLabel.text = [NSString stringWithFormat:@"赛果合计:%.2f",[dict[@"data"][@"statisticsData"][@"profit"] floatValue]];
        NSArray *arr = dict[@"data"][@"list"];
        if (arr.count > 0) {
            if (arr.count < 20) {
                self.noMoreData = @"noMoreData";
            }
            for (NSDictionary *dict1 in dict[@"data"][@"list"]) {
                RH_BettingInfoModel *model = [[RH_BettingInfoModel alloc] initWithDictionary:dict1 error:nil];
                [self.bettingArr addObject:model];
                [self.tableView reloadData];
                [SH_WaitingView hide:self];
            }
            self.imageView.hidden = YES;
        }else{
            [SH_WaitingView hide:self];
            [self.tableView reloadData];
            self.imageView.hidden = NO;
        }
        
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        [SH_WaitingView hide:self];
    }];
}
#pragma mark -  获取当前周的周一周日的时间
- (NSArray *)getWeekTimeOfCurrentWeekDay
{
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:nowDate];
    // 获取今天是周几
    NSInteger weekDay = [comp weekday];
    // 获取几天是几号
    NSInteger day = [comp day];
    // 计算当前日期和本周的星期一和星期天相差天数
    long firstDiff,lastDiff;
    //    weekDay = 1;
    if (weekDay == 1)
    {
        firstDiff = -6;
        lastDiff = 0;
    }
    else
    {
        firstDiff = [calendar firstWeekday] - weekDay + 1;
        lastDiff = 8 - weekDay;
    }
    // 在当前日期(去掉时分秒)基础上加上差的天数
    [comp setDay:day + firstDiff];
    NSDate *firstDayOfWeek = [calendar dateFromComponents:comp];
    [comp setDay:day + lastDiff];
    NSDate *lastDayOfWeek = [calendar dateFromComponents:comp];
    NSArray *dateArr = @[firstDayOfWeek,lastDayOfWeek];
    return dateArr;
}


-(NSDate *)changedSinceTimeString:(NSInteger)row
{
    NSDate *date = [[NSDate alloc]init];
    //获取本周的日期
    NSArray *currentWeekarr = [self getWeekTimeOfCurrentWeekDay];
    switch (row) {
        case 0:{
            // 今天
            date = [NSDate date];
            self.endTimeStr = dateString(date, @"yyyy-MM-dd");
            break;
        }
        case 1:{
            // 昨天
            date = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:date];
            self.endTimeStr = dateString(date, @"yyyy-MM-dd");
            break;
        }
        case 2:{
            //本周
            date = currentWeekarr[0];
            self.endTimeStr =dateString(currentWeekarr[1], @"yyyy-MM-dd");
            break;
        }
        case 3:{
            //最近七天
            date= [NSDate dateWithTimeInterval:-24*60*60*6 sinceDate:date];
            self.endTimeStr = dateString([NSDate date], @"yyyy-MM-dd");
            break;
        }
        default:
            break;
    }
    self.startTimeStr = dateString(date, @"yyyy-MM-dd");
    return date;
}

#pragma mark --UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bettingArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SH_HandRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SH_HandRecordTableViewCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SH_HandRecordTableViewCell" owner:nil options:nil] lastObject];
    }
    RH_BettingInfoModel *model = self.bettingArr[indexPath.row];
    cell.apiNameLabel.text = model.gameName;
    cell.betTimeLabel.text = [[SH_TimeZoneManager sharedManager] timeStringFrom:model.betTime/1000.0 format:@"yyyy-MM-dd HH:mm:ss"];
    
    cell.singleAmountLabel.text = [NSString stringWithFormat:@"%.2f",model.singleAmount];
    cell.profitAmountLabel.text = [NSString stringWithFormat:@"%.2f",model.profitAmount];
    NSString *status;
    if ([model.orderState isEqualToString:@"pending_settle"]){
        status = @"未结算" ;
    }else if ([model.orderState isEqualToString:@"settle"]){
        status = @"已结算" ;
    }else{
        status = @"取消订单" ;
    }
    cell.orderStateLabel.text = status;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark --UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 36;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
