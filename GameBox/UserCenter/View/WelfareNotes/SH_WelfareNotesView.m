//
//  SH_WelfareNotesView.m
//  GameBox
//
//  Created by sam on 2018/7/26.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_WelfareNotesView.h"
#import "SH_WelfareNotesTableViewCell.h"
#import "HLPopTableView.h"
#import "SH_NetWorkService+UserCenter.h"

#import "SH_FundListModel.h"
#import "SH_SearchTypeModel.h"
@interface SH_WelfareNotesView() <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;

@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) NSArray *searchTypeArr;
@property (strong, nonatomic) NSArray *selectTypeIdArray;
@property (strong, nonatomic) NSString *startTimeStr;
@property (strong, nonatomic) NSString *endTimeStr;

@property (assign, nonatomic) NSInteger seleteTypeIndex;

@property (weak, nonatomic) IBOutlet UILabel *totalRechargeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalDiscountlabel;

@end

@implementation SH_WelfareNotesView
#pragma mark 时间选择
- (IBAction)seleteTimeAction:(UIButton *)sender {
    NSArray *arr = @[@"今天",@"昨天",@"本周",@"最近七天"];
    __weak typeof(self) weakSelf = self;
    HLPopTableView *popTV = [HLPopTableView initWithFrame:CGRectMake(0, 0, sender.bounds.size.width, 125) dependView:sender textArr:arr textFont:14.0 block:^(NSString *region_name, NSInteger index) {
        [weakSelf  changedSinceTimeString:index];
        [self.timeBtn setTitle:region_name forState:UIControlStateNormal];
        [self requestData];
    }];
    [self addSubview:popTV];
}

#pragma mark 类型选择
- (IBAction)seleteTypeAction:(UIButton *)sender {
    HLPopTableView *popTV = [HLPopTableView initWithFrame:CGRectMake(0, 0, sender.bounds.size.width, 125) dependView:sender textArr:self.searchTypeArr textFont:14.0 block:^(NSString *region_name, NSInteger index) {
        [self.typeBtn setTitle:region_name forState:UIControlStateNormal];
        self.seleteTypeIndex = index;
        [self requestData];
    }];
    [self addSubview:popTV];
}
#pragma mark 搜索
- (IBAction)searchAction:(id)sender {
    
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

+(instancetype)instanceWelfareRecordView{
    return [[[NSBundle  mainBundle] loadNibNamed:NSStringFromClass([self  class]) owner:nil options:nil] lastObject];
}

-(void)awakeFromNib {
    [super awakeFromNib];
//    self.tableView.backgroundColor = [UIColor colorWithRed:52.00/255 green:55.00/255 blue:151.00/255 alpha:1];
    
    #pragma mark 默认获取近七天
    if (self.startTimeStr == nil || self.endTimeStr == nil) {
        [self changedSinceTimeString:3];
    }
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"SH_WelfareNotesTableViewCell" bundle:nil] forCellReuseIdentifier:@"SH_WelfareNotesTableViewCell"];
    self.dataArr = [NSMutableArray array];
    [self requestData];
    [self searchTypeRequest];
}

-(void)searchTypeRequest {
    [SH_NetWorkService fetchDepositPulldownListComplete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary *dict = (NSDictionary *)response;
        NSLog(@"dict===%@",dict);
        SH_SearchTypeModel *model = [[SH_SearchTypeModel alloc] initWithDictionary:dict[@"data"] error:nil];
        self.searchTypeArr = @[@"全部类型",model.deposit,model.backwater,model.withdrawals,model.recommend,model.transfers,model.favorable];
        self.selectTypeIdArray = @[@"",@"deposit",@"backwater",@"withdrawals",@"recommend",@"transfers",@"favorable"];
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
}

-(void)requestData {
    [self.dataArr removeAllObjects];
    NSLog(@"startTimeStr===%@",self.startTimeStr);
    NSLog(@" endTimeStr===%@",self.endTimeStr);
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [SH_NetWorkService  fetchDepositList:self.startTimeStr EndDate:self.endTimeStr SearchType:self.selectTypeIdArray[self.seleteTypeIndex] PageNumber:1 PageSize:5000 complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary *dict = (NSDictionary *)response;
        NSLog(@"dict===%@",dict);
        NSString *code = dict[@"code"];
        if ([code intValue] == 0) {
            self.totalRechargeLabel.text = [NSString stringWithFormat:@"优惠合计：%@",dict[@"data"][@"sumPlayerMap"][@"favorable"]];
            self.totalDiscountlabel.text = [NSString stringWithFormat:@"充值合计：%@",dict[@"data"][@"sumPlayerMap"][@"recharge"]];
            NSArray *arr = dict[@"data"][@"fundListApps"];
            if (arr.count > 0) {
                for (NSDictionary *dict1 in arr) {
                    SH_FundListModel *model = [[SH_FundListModel alloc]initWithDictionary:dict1 error:nil];
                    [self.dataArr addObject:model];
                    [self.tableView reloadData];
                    [MBProgressHUD hideHUDForView:self animated:YES];
                }
            } else {
                [self.tableView reloadData];
                [MBProgressHUD hideHUDForView:self animated:YES];
            }
            
        } else {
            showMessage(self, @"", dict[@"message"]);
            [MBProgressHUD hideHUDForView:self animated:YES];
        }
        
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        showMessage(self, @"", err);
        [MBProgressHUD hideHUDForView:self animated:YES];
    }];
}

-(NSString *)timeStampWithDate: (NSInteger)timeStamp {
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    =timeStamp / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString       = [formatter stringFromDate: date];
    return dateString;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SH_WelfareNotesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SH_WelfareNotesTableViewCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SH_WelfareNotesTableViewCell" owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SH_FundListModel *model = self.dataArr[indexPath.row];
    cell.timeLabel.text = [self timeStampWithDate:model.createTime];
    cell.moneyLabel.text = model.transactionMoney;
    cell.statuLabel.text = model.statusName;
    cell.typeLabel.text = model.transaction_typeName;
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 29;
}

@end
