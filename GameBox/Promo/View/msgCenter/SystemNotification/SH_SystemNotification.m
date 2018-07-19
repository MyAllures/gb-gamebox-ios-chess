//
//  SH_SystemNotification.m
//  GameBox
//
//  Created by sam on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_SystemNotification.h"
#import <Masonry/Masonry.h>
#import "SH_GameBulletinTCell.h"
#import "SH_PromoViewCell.h"
#import "SH_NetWorkService+Promo.h"
#import "SH_SystemNotificationModel.h"
#import "RH_UserInfoManager.h"

#import "PGDatePicker.h"
#import "PGDatePickManager.h"
#import "HLPopTableView.h"

@interface SH_SystemNotification () <UITableViewDataSource, UITableViewDelegate,PGDatePickerDelegate>
{
    PGDatePickManager *_datePickManager;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIButton *quickSeleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *startTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *endTimeBtn;

@property (strong, nonatomic) NSMutableArray *gameBulletinArr;
@property (strong, nonatomic) NSMutableArray *quickSeleteArr;

@property (strong, nonatomic) NSString *startTimeStr;
@property (strong, nonatomic) NSString *endTimeStr;

@property (strong, nonatomic) UIPickerView *pickView;

@property(nonatomic, strong) NSString *startAndEndDateStr;
@end

@implementation SH_SystemNotification

- (IBAction)startTimeAction:(id)sender {
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.style = PGDatePickManagerStyle1;
    datePickManager.isShadeBackgroud = true;
    
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.isHiddenMiddleText = false;
    datePicker.delegate = self;
    datePicker.datePickerType = PGPickerViewType3;
    datePicker.datePickerMode = PGDatePickerModeDate;
    _datePickManager = datePickManager;
     UIWindow  * window = [UIApplication  sharedApplication].keyWindow;
     window.backgroundColor = [UIColor  yellowColor];
     [window addSubview:_datePickManager.view];
}
- (IBAction)endTimeAction:(id)sender {
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:@"end",@"isEnd", nil];
    self.startAndEndDateStr = dict[@"isEnd"];
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.style = PGDatePickManagerStyle1;
    datePickManager.isShadeBackgroud = true;
    
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.isHiddenMiddleText = false;
    datePicker.delegate = self;
    datePicker.datePickerType = PGPickerViewType3;
    datePicker.datePickerMode = PGDatePickerModeDate;
     _datePickManager = datePickManager;
    [self.window addSubview:datePickManager.view];

}

- (IBAction)quickSeleteAction:(UIButton *)sender {
    NSArray *arr = @[@"今天",@"昨天",@"本周",@"上周",@"本月"];
    if (![RH_UserInfoManager shareUserManager].isLogin) {
        showMessage(self, @"", @"请先登录");
        return;
    }
    
    HLPopTableView *popTV = [HLPopTableView initWithFrame:CGRectMake(0, 0, sender.bounds.size.width+5, 110) dependView:sender textArr:arr textFont:8.0 block:^(NSString *region_name, NSInteger index) {
        NSDate *startDate = [[NSDate alloc]init];
        NSDate *endDate = [[NSDate alloc]init];
        //获取本周的日期
        NSArray *currentWeekarr = [self getWeekTimeOfCurrentWeekDay];
        NSArray *lastWeekArr = [self getWeekTimeOfLastWeekDay];
        switch (index) {
            case 0:
                //今天
                startDate= [NSDate date];
                endDate = startDate;
                break;
            case 1:
                //昨天
                startDate = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:startDate];
                endDate = startDate;
                break;
            case 2:
                //本周
                startDate = currentWeekarr[0];
                endDate = currentWeekarr[1];
                break;
            case 3:
                //上周
                startDate = lastWeekArr[0];
                endDate = lastWeekArr[1];
                break;
            case 4:
                //本月
                startDate= [self dateFromDateFirstDay];
                endDate = [self getMonthEndDate];
                break;
            case 5:
                //最近7天
                startDate= [NSDate dateWithTimeInterval:-24*60*60*6 sinceDate:startDate];
                endDate = [NSDate dateWithTimeInterval:24*60*60*6 sinceDate:startDate];
                break;
            case 6:
                //最近三十天
                startDate= [NSDate dateWithTimeInterval:-24*60*60*29 sinceDate:startDate];
                endDate = [NSDate dateWithTimeInterval:24*60*60*29 sinceDate:startDate];
                break;
                
            default:
                break;
        }
        //    _headerView.startDate = date;
        self.startTimeStr = dateStringWithFormatter(startDate, @"yyyy-MM-dd");
        self.endTimeStr = dateStringWithFormatter(endDate, @"yyyy-MM-dd") ;
        if ([RH_UserInfoManager shareUserManager].isLogin) {
            [MBProgressHUD showHUDAddedTo:self animated:YES];
            [SH_NetWorkService_Promo startLoadSystemNoticeStartTime:self.startTimeStr endTime:self.endTimeStr pageNumber:1 pageSize:500 complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
                NSDictionary *dic = (NSDictionary *)response;
                for (NSDictionary *dict in dic[@"data"][@"list"]) {
                    NSError *err;
                    SH_SystemNotificationModel *model = [[SH_SystemNotificationModel alloc] initWithDictionary:dict error:&err];
                    if (model) {
                        [self.gameBulletinArr addObject:model];
                    }
                    [self.tableView reloadData];
                }
                [MBProgressHUD hideHUDForView:self animated:YES];
            } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
                
            }];
        }
    }];
    [self addSubview:popTV];
}


-(void)awakeFromNib {
    [super awakeFromNib];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changedDate:) name:@"seletedDate" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(seletedEndDate:) name:@"seletedEndDate" object:nil];
//    self.backgroundColor = [UIColor colorWithRed:0.15 green:0.19 blue:0.44 alpha:1];
//    self.tableView.backgroundColor = [UIColor colorWithRed:0.15 green:0.19 blue:0.44 alpha:1];
    
    self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    [self.startTimeBtn setTitle:[self getCurrentTimes] forState:UIControlStateNormal];
    [self.endTimeBtn setTitle:[self getCurrentTimes] forState:UIControlStateNormal];
//    self.quickSeleteBtn.backgroundColor = [UIColor blueColor];
//    self.quickSeleteBtn.layer.cornerRadius = 5;
//    self.quickSeleteBtn.clipsToBounds = YES;
    self.gameBulletinArr = [NSMutableArray array];
    if ([RH_UserInfoManager shareUserManager].isLogin) {
        [MBProgressHUD showHUDAddedTo:self animated:YES];
        [SH_NetWorkService_Promo startLoadSystemNoticeStartTime:[self getCurrentTimes] endTime:[self getCurrentTimes] pageNumber:1 pageSize:500 complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
            NSDictionary *dic = (NSDictionary *)response;
            for (NSDictionary *dict in dic[@"data"][@"list"]) {
                NSError *err;
                SH_SystemNotificationModel *model = [[SH_SystemNotificationModel alloc] initWithDictionary:dict error:&err];
                if (model) {
                    [self.gameBulletinArr addObject:model];
                }
                
                [self.tableView reloadData];
            }
            [MBProgressHUD hideHUDForView:self animated:YES];
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            
        }];
    }else{
        showMessage(self, @"", @"请先登录");
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    [self.tableView registerNib:[UINib nibWithNibName:@"SH_GameBulletinTCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    [self.tableView reloadData];
}

-(void)changedDate:(NSDictionary *)nt {
    [self.startTimeBtn setTitle:nt[@"date"] forState:UIControlStateNormal];
    self.startTimeStr = nt[@"date"];
    if (!self.endTimeStr) {
        self.endTimeStr = [self getCurrentTimes];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [dateFormatter dateFromString:self.startTimeStr];
    NSDate *endDate = [dateFormatter dateFromString:self.endTimeStr];
    if (startDate > endDate) {
        showMessage(self, @"提示", @"时间选择有误,请重试选择");
        return;
    }
    [self.gameBulletinArr removeAllObjects];
    if ([RH_UserInfoManager shareUserManager].isLogin) {
        [MBProgressHUD showHUDAddedTo:self animated:YES];
        [SH_NetWorkService_Promo startLoadSystemNoticeStartTime:self.startTimeStr endTime:self.endTimeStr pageNumber:1 pageSize:50000 complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
            NSDictionary *dic = (NSDictionary *)response;
            for (NSDictionary *dict in dic[@"data"][@"list"]) {
                NSError *err;
                SH_SystemNotificationModel *model = [[SH_SystemNotificationModel alloc] initWithDictionary:dict error:&err];
                if (model) {
                    [self.gameBulletinArr addObject:model];
                }
                
                [self.tableView reloadData];
            }
            [MBProgressHUD hideHUDForView:self animated:YES];
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            
        }];
    }else{
        showMessage(self, @"", @"请先登录");
    }
}

-(void)seletedEndDate:(NSDictionary *)nt {
    [self.endTimeBtn setTitle:nt[@"date"] forState:UIControlStateNormal];
    self.endTimeStr = nt[@"date"];
    if (!self.startTimeStr) {
        self.startTimeStr = [self getCurrentTimes];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [dateFormatter dateFromString:self.startTimeStr];
    NSDate *endDate = [dateFormatter dateFromString:self.endTimeStr];
    if (startDate > endDate) {
        showMessage(self, @"提示", @"时间选择有误,请重试选择");
        return;
    }
    [self.gameBulletinArr removeAllObjects];
    if ([RH_UserInfoManager shareUserManager].isLogin) {
        [MBProgressHUD showHUDAddedTo:self animated:YES];
        [SH_NetWorkService_Promo startLoadSystemNoticeStartTime:self.startTimeStr endTime:self.endTimeStr pageNumber:1 pageSize:50000 complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
            NSDictionary *dic = (NSDictionary *)response;
            for (NSDictionary *dict in dic[@"data"][@"list"]) {
                NSError *err;
                SH_SystemNotificationModel *model = [[SH_SystemNotificationModel alloc] initWithDictionary:dict error:&err];
                if (model) {
                    [self.gameBulletinArr addObject:model];
                }
                
                [self.tableView reloadData];
            }
            [MBProgressHUD hideHUDForView:self animated:YES];
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            
        }];
    }
}

-(NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    return currentTimeString;
    
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

#pragma mark - UITableViewDataSource M

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.gameBulletinArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    
    SH_GameBulletinTCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SH_GameBulletinTCell" owner:nil options:nil] lastObject];
    }
    SH_SystemNotificationModel *model = self.gameBulletinArr[indexPath.row];
    cell.contentLabel.text = model.content;
    cell.publishTimeLabel.text = [self timeStampWithDate:model.publishTime];
//    cell.gameNameLabel.text = model.title;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

#pragma mark - UITableViewDelegate M
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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

#pragma mark -  获取上一周的周一周日的时间
- (NSArray *)getWeekTimeOfLastWeekDay
{
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:nowDate];
    // 获取今天是周几
    NSInteger weekDay = [comp weekday];
    // 获取几天是几号
    NSInteger day = [comp day];
    NSInteger lastDay = day - 7;
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
        firstDiff = [calendar firstWeekday] - weekDay +1;
        lastDiff = 8 - weekDay;
    }
    // 在当前日期(去掉时分秒)基础上加上差的天数
    [comp setDay:lastDay + firstDiff];
    NSDate *firstDayOfWeek = [calendar dateFromComponents:comp];
    [comp setDay:lastDay + lastDiff];
    NSDate *lastDayOfWeek = [calendar dateFromComponents:comp];
    NSArray *dateArr = @[firstDayOfWeek,lastDayOfWeek];
    return dateArr;
}

#pragma mark - 获取本月最后一天
- (NSDate *)getMonthEndDate
{
    NSDate *newDate=[NSDate date];
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginDate interval:&interval forDate:newDate];
    //分别修改为 NSCalendarUnitMonth NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return nil;
    }
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"YYYY-MM-dd"];
    return endDate;
}

#pragma mark - 获取当前月1号
- (NSDate *)dateFromDateFirstDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:[NSDate date]];
    
    NSString *str1 =  [currentDateString substringWithRange:NSMakeRange(7, 3)];
    NSString *str2 = [currentDateString stringByReplacingOccurrencesOfString:str1 withString:@"-01"];
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    formatter.dateFormat = @"yyyy-MM-dd";
    //NSString转NSDate
    NSDate *date = [formatter dateFromString:str2] ;
    return date;
}


#pragma mark - PGDatePickerDelegate M
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSLog(@"dateComponents = %@", dateComponents);
    NSString *month ;
    NSString *day;
    if (dateComponents.month < 10) {
        month = [NSString stringWithFormat:@"0%@",@(dateComponents.month)];
    }else{
        month = [NSString stringWithFormat:@"%@",@(dateComponents.month)];
    }
    
    if (dateComponents.day < 10) {
        day = [NSString stringWithFormat:@"0%@",@(dateComponents.day)];
    }else{
        day = [NSString stringWithFormat:@"%@",@(dateComponents.day)];
    }
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@",@(dateComponents.year),month,day];
    NSLog(@"---%@",dateStr);
    if ([self.startAndEndDateStr isEqualToString:@"end"]) {
        NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@",@(dateComponents.year),month,day];
        NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:dateStr,@"date",nil];
        [self seletedEndDate:dict];
//        //创建通知
//        NSNotification *notification =[NSNotification notificationWithName:@"seletedEndDate" object:nil userInfo:dict];
//        //通过通知中心发送通知
//        [[NSNotificationCenter defaultCenter] postNotification:notification];
        self.startAndEndDateStr = @"";
        
    } else {
        NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@",@(dateComponents.year),month,day];
        NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:dateStr,@"date",nil];
        [self changedDate:dict];
        //创建通知
//        [self seletedDate:dict];
//        NSNotification *notification =[NSNotification notificationWithName:@"seletedDate" object:nil userInfo:dict];
//        //通过通知中心发送通知
//        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}

@end
