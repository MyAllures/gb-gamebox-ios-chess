
//
//  SH_WelfareView.m
//  GameBox
//
//  Created by egan on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_WelfareView.h"

#import "HLPopTableView.h"

#import "PGDatePicker.h"
#import "PGDatePickManager.h"
#import "SH_NetWorkService+UserCenter.h"
#import "SH_SearchTypeModel.h"
@interface SH_WelfareView() <UITextFieldDelegate,PGDatePickerDelegate>
{
    PGDatePickManager *_datePickManager;
    NSInteger  _selectIndex;
    NSArray *_selectIdArray;
}
@property (weak, nonatomic) IBOutlet UIView *left_view;
@property (weak, nonatomic) IBOutlet UIView *right_view;
@property (weak, nonatomic) IBOutlet UILabel *type_label;
@property (weak, nonatomic) IBOutlet UILabel *end_label;
@property (weak, nonatomic) IBOutlet UILabel *start_label;
@property (weak, nonatomic) IBOutlet UIButton *quickBtn;

@property (strong, nonatomic) NSString *startTimeStr;
@property (strong, nonatomic) NSString *endTimeStr;

@property(nonatomic, strong) NSString *startAndEndDateStr;

@property(nonatomic,strong)NSArray * dataArray;
@end

@implementation SH_WelfareView

+(instancetype)instanceWelfareView{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}
-(void)awakeFromNib{
    [super  awakeFromNib];
    self.start_label.text = dateString([NSDate  date], @"yyyy-MM-dd");
    self.end_label.text = dateString([NSDate  date], @"yyyy-MM-dd");
    [self borderColorWith:self.left_view];
    [self borderColorWith:self.right_view];
    
    _selectIndex =0;
    _selectIdArray = [NSArray  array];
    [self httpData];
}
-(void)borderColorWith:(UIView*)view{
    view.layer.cornerRadius= 5;
    view.layer.masksToBounds = YES;
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
}
#pragma mark -- 请求数据
-(void)httpData{
    __weak  typeof(self)  weakSelf = self;
    [SH_NetWorkService fetchDepositPulldownListComplete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary * dic = ConvertToClassPointer(NSDictionary, response);
        if ([dic boolValueForKey:@"success"]) {
            SH_SearchTypeModel * model = [[SH_SearchTypeModel  alloc]initWithDictionary:dic[@"data"] error:nil];
            weakSelf.dataArray = @[@"全部类型",model.deposit,model.backwater,model.withdrawals,model.recommend,model.transfers,model.favorable];
            self->_selectIdArray = @[@"",@"deposit",@"backwater",@"withdrawals",@"recommend",@"transfers",@"favorable"];
        }else{
            showMessage(self, dic[@"message"], nil);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
         showMessage(self, err, nil);
    }];
}
#pragma mark ---  button click method
- (IBAction)buttonClick:(UIButton *)sender {
    if (sender.tag==100) {
        [self  startBtnClick];
    }else if (sender.tag==101){
        [self  endBtnClick];
    }else if (sender.tag==102){
        __weak typeof(self) weakSelf = self;
        HLPopTableView *popTV = [HLPopTableView initWithFrame:CGRectMake(0, 0, sender.bounds.size.width, 140) dependView:sender textArr:self.dataArray textFont:14.0  block:^(NSString *region_name, NSInteger index) {
            self->_selectIndex = index;
            weakSelf.type_label.text = region_name;
        }];
        
        [self addSubview:popTV];
    }else if (sender.tag==103){
        [self  search];
    }
}

- (void)changeDate:(UIDatePicker *)datePicker
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy年 MM月 dd日";
    NSString *minDate = [formatter stringFromDate:datePicker.minimumDate];
    NSString *maxDate = [formatter stringFromDate:datePicker.maximumDate];
  
    self.start_label.text = minDate;
    self.end_label.text = maxDate;
}
#pragma mark --- 快选
- (IBAction)quickSelect:(UIButton *)sender {
    NSArray *arr = @[@"今天",@"昨天",@"本周",@"最近七天"];
    __weak typeof(self) weakSelf = self;
    HLPopTableView *popTV = [HLPopTableView initWithFrame:CGRectMake(0, 0, sender.bounds.size.width, 125) dependView:sender textArr:arr textFont:14.0 block:^(NSString *region_name, NSInteger index) {
        [weakSelf  changedSinceTimeString:index];
    }];
    
    [self addSubview:popTV];
}

#pragma mark -- 搜索
- (void)search
{
    NSDateFormatter  * formatter = [[NSDateFormatter  alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate  * startDate = [formatter  dateFromString:self.start_label.text];
    NSDate  * endDate = [formatter  dateFromString:self.end_label.text];
    if ( [self compareOneDay:startDate withAnotherDay:endDate] == 1) {
        showAlertView(@"提示", @"时间选择有误,请重试选择");
        return;
    }
    if (self.dataBlock) {
        NSDictionary * dic = [NSDictionary  dictionaryWithObjectsAndKeys:self.start_label.text,@"startTime",self.end_label.text,@"endTime",_selectIndex < _selectIdArray.count?_selectIdArray[_selectIndex]:@"",@"type", nil];
        self.dataBlock(dic);
    }
}

#pragma mark -- 点击选择开始时间
-(void)startBtnClick{
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
#pragma mark -- 点击选择结束时间
-(void)endBtnClick{
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
#pragma mark -- 结束时间
-(void)seletedEndDate:(NSDictionary *)nt {

    self.endTimeStr = nt[@"date"];
    if (!self.startTimeStr) {
        self.startTimeStr = [self getCurrentTimes];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [dateFormatter dateFromString:self.startTimeStr];
    NSDate *endDate = [dateFormatter dateFromString:self.endTimeStr];
    if (startDate > endDate) {
        showAlertView(@"提示", @"时间选择有误,请重试选择");
        return;
    }
      self.end_label.text = nt[@"date"];
}
#pragma mark -- 开始时间
-(void)changedDate:(NSDictionary *)nt {
    
    self.startTimeStr = nt[@"date"];
    if (!self.endTimeStr) {
        self.endTimeStr = [self getCurrentTimes];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [dateFormatter dateFromString:self.startTimeStr];
    NSDate *endDate = [dateFormatter dateFromString:self.endTimeStr];
    if (startDate > endDate) {
        showAlertView(@"提示", @"时间选择有误,请重试选择");
        return;
    }
    self.start_label.text = nt[@"date"];
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
        self.startAndEndDateStr = @"";
        
    } else {
        NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@",@(dateComponents.year),month,day];
        NSDictionary *dict =[[NSDictionary alloc]initWithObjectsAndKeys:dateStr,@"date",nil];
        [self changedDate:dict];
    }
}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return NO;
}
#pragma  mark --- getter method

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

-(NSDate *)changedSinceTimeString:(NSInteger)row
{
    NSDate *date = [[NSDate alloc]init];
    //获取本周的日期
    NSArray *currentWeekarr = [self getWeekTimeOfCurrentWeekDay];
    switch (row) {
        case 0:{
            // 今天
            date = [NSDate date];
            self.end_label.text = dateString(date, @"yyyy-MM-dd");
            break;
         }
        case 1:{
            // 昨天
            date = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:date];
            self.end_label.text = dateString([NSDate  date], @"yyyy-MM-dd");
            break;
        }
        case 2:{
            //本周
            date = currentWeekarr[0];
            self.end_label.text =dateString(currentWeekarr[1], @"yyyy-MM-dd");
            break;
        }
        case 3:{
            //最近七天
            date= [NSDate dateWithTimeInterval:-24*60*60*6 sinceDate:date];
            self.end_label.text = dateString([NSDate date], @"yyyy-MM-dd");
            break;
        }
        default:
            break;
    }
    self.start_label.text = dateString(date, @"yyyy-MM-dd");
    [self search];
    return date;
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
    // 22 28
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

#pragma mark -- 时间比较
-(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    
    NSComparisonResult result = [dateA compare:dateB];
    
    if (result == NSOrderedDescending) {
        //NSLog(@"oneDay比 anotherDay时间晚");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"oneDay比 anotherDay时间早");
        return -1;
    }
    //NSLog(@"两者时间是同一个时间");
    return 0;
}

#pragma  mark --- getter  method
-(NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSArray  array];
    }
    return _dataArray;
}
@end
