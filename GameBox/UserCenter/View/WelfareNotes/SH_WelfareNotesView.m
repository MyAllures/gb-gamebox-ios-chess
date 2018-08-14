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
#import "SH_WaitingView.h"

@interface SH_WelfareNotesView() <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;

@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) NSString *startTimeStr;
@property (strong, nonatomic) NSString *endTimeStr;

@property (assign, nonatomic) NSInteger seleteTypeIndex;

@property (weak, nonatomic) IBOutlet UILabel *totalRechargeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalDiscountlabel;

@property (nonatomic, strong) NSMutableArray *selectTypeNameArr;
@property (nonatomic, strong) NSMutableArray *selectTypeIdArr;
@property (weak, nonatomic) IBOutlet SH_WebPImageView *imageView;

@end

@implementation SH_WelfareNotesView

- (NSMutableArray *)selectTypeNameArr
{
    if (_selectTypeNameArr == nil) {
        _selectTypeNameArr = [NSMutableArray array];
    }
    return _selectTypeNameArr;
}

- (NSMutableArray *)selectTypeIdArr
{
    if (_selectTypeIdArr == nil) {
        _selectTypeIdArr = [NSMutableArray array];
    }
    return _selectTypeIdArr;
}

#pragma mark 时间选择
- (IBAction)seleteTimeAction:(UIButton *)sender {
    NSArray *arr = @[@"今天",@"昨天",@"本周",@"近七天"];
    __weak typeof(self) weakSelf = self;
    HLPopTableView *popTV = [HLPopTableView initWithFrame:CGRectMake(0, 0, sender.bounds.size.width, 125) dependView:sender textArr:arr textFont:14.0 block:^(NSString *region_name, NSInteger index) {
        
        [weakSelf changedSinceTimeString:index];
        [weakSelf.timeBtn setTitle:region_name forState:UIControlStateNormal];
    }];
    popTV.backgroundColor = [UIColor clearColor];
    [self addSubview:popTV];
}

#pragma mark 类型选择
- (IBAction)seleteTypeAction:(UIButton *)sender {
    HLPopTableView *popTV = [HLPopTableView initWithFrame:CGRectMake(0, 0, sender.bounds.size.width, 125) dependView:sender textArr:self.selectTypeNameArr textFont:14.0 block:^(NSString *region_name, NSInteger index) {
        [self.typeBtn setTitle:region_name forState:UIControlStateNormal];
        self.seleteTypeIndex = index;
    }];
    [self addSubview:popTV];
}
#pragma mark 搜索
- (IBAction)searchAction:(id)sender {
    NSString *searchType = [self.selectTypeIdArr objectAtIndex:self.seleteTypeIndex];
    [self requestData:self.startTimeStr endTimeStr:self.endTimeStr searchType:searchType];
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
    [self requestData:self.startTimeStr endTimeStr:self.endTimeStr searchType:@""];
    [self searchTypeRequest];
}

-(void)searchTypeRequest {
    __weak typeof(self) weakSelf = self;
    if ([RH_UserInfoManager  shareUserManager].isLogin) {
        [SH_NetWorkService fetchDepositPulldownListComplete:^(NSHTTPURLResponse *httpURLResponse, id response) {
            NSDictionary *dataDic = [response objectForKey:@"data"];
            [weakSelf.selectTypeNameArr addObject:@"全部"];
            [weakSelf.selectTypeNameArr addObjectsFromArray:[dataDic allValues]];
            
            [weakSelf.selectTypeIdArr addObject:@""];
            [weakSelf.selectTypeIdArr addObjectsFromArray:[dataDic allKeys]];
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            
        }];
    }
}

-(void)requestData:(NSString *)startTimeStr endTimeStr:(NSString *)endTimeStr searchType:(NSString *)searchType
{
    [self.dataArr removeAllObjects];
    [SH_WaitingView showOn:self];
    [SH_NetWorkService fetchDepositList:startTimeStr EndDate:endTimeStr SearchType:searchType PageNumber:1 PageSize:5000 complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary *dict = (NSDictionary *)response;
        NSLog(@"dict===%@",dict);
        NSString *code = dict[@"code"];
        if ([code intValue] == 0) {
            self.totalRechargeLabel.text = [NSString stringWithFormat:@"优惠合计：%.2f",[dict[@"data"][@"sumPlayerMap"][@"favorable"] floatValue]];
            self.totalDiscountlabel.text = [NSString stringWithFormat:@"充值合计：%.2f",[dict[@"data"][@"sumPlayerMap"][@"recharge"] floatValue]];
            NSArray *arr = dict[@"data"][@"fundListApps"];
            if (arr.count > 0) {
                for (NSDictionary *dict1 in arr) {
                    SH_FundListModel *model = [[SH_FundListModel alloc]initWithDictionary:dict1 error:nil];
                    [self.dataArr addObject:model];
                    [self.tableView reloadData];
                    [SH_WaitingView hide:self];
                }
            } else {
                [self.tableView reloadData];
                [SH_WaitingView hide:self];
            }
            
        } else {
            showMessage(self, @"", dict[@"message"]);
            [SH_WaitingView hide:self];
        }
        
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        showMessage(self, @"", err);
        [SH_WaitingView hide:self];
    }];
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
    if (self.dataArr.count > 0) {
        self.imageView.hidden = YES;
    } else {
        self.imageView.hidden = NO;
    }
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SH_WelfareNotesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SH_WelfareNotesTableViewCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SH_WelfareNotesTableViewCell" owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SH_FundListModel *model = self.dataArr[indexPath.row];
    cell.model = model;
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 36;
}

@end
