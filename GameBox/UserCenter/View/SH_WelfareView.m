
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
//资金日期
@property (nonatomic, strong) UILabel *foundLbl;
//开始时间
@property (nonatomic, strong) UITextField *startField;
//结束时间
@property (nonatomic, strong) UITextField *endField;
//快选
@property (nonatomic, strong) UIButton *selectBtn;
//全部类型
@property (nonatomic, strong) UIButton *allBtn;
//搜索
@property (nonatomic, strong) UIButton *searchBtn;
//取款处理
@property (nonatomic, strong) UILabel *drawLbl;
//转账处理
@property (nonatomic, strong) UILabel *transferLbl;
//分割线1
@property (nonatomic, strong) UIView *lineFirst;
//分割线2
@property (nonatomic, strong) UIView *lineSecond;
//分割线3
@property (nonatomic, strong) UIView *lineThird;
//间隔线
@property (nonatomic, strong) UILabel *distanceLbl;
//取款余额
@property (nonatomic, strong) UILabel *balanceW;
//转账余额
@property (nonatomic, strong) UILabel *balanceT;


@property (strong, nonatomic) NSString *startTimeStr;
@property (strong, nonatomic) NSString *endTimeStr;

@property(nonatomic, strong) NSString *startAndEndDateStr;

@property(nonatomic,strong)NSArray * dataArray;
@end

@implementation SH_WelfareView

 - (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self httpData];
        [self createUI];
        _selectIndex =0;
        _selectIdArray = [NSArray  array];
    }
    return self;
}
-(void)httpData{
    __weak  typeof(self)  weakSelf = self;
    [SH_NetWorkService fetchDepositPulldownListComplete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary * dic = ConvertToClassPointer(NSDictionary, response);
        if ([dic boolValueForKey:@"success"]) {
            SH_SearchTypeModel * model = [[SH_SearchTypeModel  alloc]initWithDictionary:dic[@"data"] error:nil];
            weakSelf.dataArray = @[@"全部类型",model.deposit,model.backwater,model.withdrawals,model.recommend,model.transfers,model.favorable];
            self->_selectIdArray = @[@"",@"deposit",@"backwater",@"withdrawals",@"recommend",@"transfers",@"favorable"];
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
}
- (void)createUI
{
    //资金日期
    self.foundLbl = [[UILabel alloc] init];
    self.foundLbl.text = @"资金日期:";
    self.foundLbl.textColor = [UIColor blackColor];
    self.foundLbl.font = [UIFont systemFontOfSize:14.5];
    [self addSubview:self.foundLbl];
    
    [self.foundLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).mas_equalTo(8);
        make.left.equalTo(self.mas_left).mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(130, 45));
    }];

    //开始时间
    self.startField = [[UITextField alloc] init];
    self.startField.delegate = self;
    self.startField.tag = 101;
    self.startField.backgroundColor = [UIColor whiteColor];
    self.startField.borderStyle = UITextBorderStyleLine;
    self.startField.text = dateString([NSDate date], @"yyyy-MM-dd");
    
    //左侧图片
    UIImage *img = [UIImage imageNamed:@"betRec_calendar_icon"];
    UIImageView *imgV = [[UIImageView alloc] initWithImage:img];
    imgV.contentMode = UIViewContentModeScaleToFill;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 45)];
    imgV.center = view.center;
    [view addSubview:imgV];
    
    self.startField.leftViewMode = UITextFieldViewModeAlways;
    self.startField.leftView = view;
    [self addSubview:self.startField];

    [self.startField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(8);
        make.left.equalTo(self.mas_left).with.offset(100);
        make.size.mas_equalTo(CGSizeMake(140, 45));
    }];

    UIButton  * startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:startBtn];
    [startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.startField);
    }];
    [startBtn addTarget:self action:@selector(startBtnClick) forControlEvents:UIControlEventTouchUpInside];
  
    
    //间隔线
    self.distanceLbl = [[UILabel alloc] init];
    self.distanceLbl.text = @"~";
    self.distanceLbl.textColor = [UIColor blackColor];
    self.distanceLbl.font = [UIFont systemFontOfSize:18.0];
    [self addSubview:self.distanceLbl];
    
    [self.distanceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 10));
        make.left.equalTo(self.startField.mas_right).with.offset(5);
        make.top.equalTo(self.mas_top).with.offset(23);
    }];

    //结束时间
    self.endField = [[UITextField alloc] init];
    self.endField.delegate = self;
    self.endField.tag = 102;
    self.endField.backgroundColor = [UIColor whiteColor];
    self.endField.borderStyle = UITextBorderStyleLine;
    self.endField.text = dateString([NSDate date], @"yyyy-MM-dd");
    //左侧图片
    UIImage *img1 = [UIImage imageNamed:@"betRec_calendar_icon"];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img1];
    imgView.contentMode = UIViewContentModeScaleToFill;
    UIView *leftV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 45)];
    imgView.center = leftV.center;
    [leftV addSubview:imgView];
    
    self.endField.leftViewMode = UITextFieldViewModeAlways;
    self.endField.leftView = leftV;
    
    [self addSubview:self.endField];
    
    [self.endField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(140, 45));
        make.left.equalTo(self.distanceLbl.mas_right).with.offset(0);
        make.top.equalTo(self.mas_top).with.offset(8);
    }];

    UIButton  * endBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:endBtn];
    [endBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.endField);
    }];
    [endBtn addTarget:self action:@selector(endBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //快选
    self.selectBtn = [[UIButton alloc] init];
    [self.selectBtn setTitle:@"快选" forState:UIControlStateNormal];
    self.selectBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    self.selectBtn.layer.cornerRadius = 5;
    [self.selectBtn setBackgroundColor:[UIColor greenColor]];
    [self.selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.selectBtn addTarget:self action:@selector(quickSelect) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.selectBtn];

    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-8);
//        make.top.equalTo(self.mas_top).with.offset(45);
        make.centerY.mas_equalTo(self.endField.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60, 40));
    }];

    //分割线1
    self.lineFirst = [[UIView alloc] init];
    self.lineFirst.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    [self addSubview:self.lineFirst];
    
    [self.lineFirst mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.startField.mas_bottom).with.offset(8);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.height.mas_equalTo(1.0);
    }];
    
    //全部类型
    self.allBtn = [[UIButton alloc] init];
    self.allBtn.backgroundColor = [UIColor lightGrayColor];
    self.allBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    self.allBtn.layer.cornerRadius = 5.0;
    [self.allBtn setTitle:@"全部类型" forState:UIControlStateNormal];
    [self.allBtn addTarget:self action:@selector(pressAllBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.allBtn];

    [self.allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineFirst.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(200, 50));
        make.left.equalTo(self.mas_left).with.offset(15);
    }];

    //搜索
    self.searchBtn = [[UIButton alloc] init];
    self.searchBtn.layer.cornerRadius = 5.0;
    [self.searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [self.searchBtn setBackgroundColor:[UIColor blueColor]];
    [self.searchBtn setTintColor:[UIColor whiteColor]];
    self.searchBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [self.searchBtn addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.searchBtn];

    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 50));
        make.top.equalTo(self.lineFirst.mas_bottom).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-20);
    }];

    //分割线2
    self.lineSecond = [[UIView alloc] init];
    self.lineSecond.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    [self addSubview:self.lineSecond];
    
    [self.lineSecond mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.top.equalTo(self.searchBtn.mas_bottom).with.offset(10);
        make.height.mas_equalTo(1.0);
    }];

    //取款处理中
    self.drawLbl = [[UILabel alloc] init];
    self.drawLbl.text = [NSString stringWithFormat:@"取款处理中:"];
    self.drawLbl.textColor = [UIColor blackColor];
    self.drawLbl.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:self.drawLbl];

    [self.drawLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(8);
        make.top.equalTo(self.lineSecond.mas_bottom).with.offset(18);
    }];

    //取款余额
    self.balanceW = [[UILabel alloc] init];
    self.balanceW.textColor = [UIColor yellowColor];
    self.balanceW.text = [NSString stringWithFormat:@"¥ %.1f",0.0];
    [self addSubview:self.balanceW];
    
    [self.balanceW mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.drawLbl.mas_right).with.offset(8);
        make.top.equalTo(self.lineSecond.mas_bottom).with.offset(18);
    }];
    
    //转账处理中
    self.transferLbl = [[UILabel alloc] init];
    self.transferLbl.text = [NSString stringWithFormat:@"转账处理中:"];
    self.transferLbl.textColor = [UIColor blackColor];
    self.transferLbl.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:self.transferLbl];

    [self.transferLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-50);
        make.top.equalTo(self.lineSecond.mas_bottom).with.offset(18);
    }];

    //转账余额
    self.balanceT = [[UILabel alloc] init];
    self.balanceT.textColor = [UIColor yellowColor];
    self.balanceT.text = [NSString stringWithFormat:@"¥ %.1f",0.0];
    [self addSubview:self.balanceT];
    
    [self.balanceT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.transferLbl.mas_right).with.offset(3);
        make.top.equalTo(self.lineSecond.mas_bottom).with.offset(18);
    }];
    
    UIView * bottom = [UIView  new];
    [self addSubview:bottom];
    [bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.transferLbl.mas_bottom).with.offset(18);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.mas_equalTo(30);
    }];
    bottom.backgroundColor = [UIColor  orangeColor];
    NSArray * title = @[@"时间",@"金额",@"状态",@"类型"];
    NSMutableArray * tmp = [NSMutableArray  array];
    NSMutableArray * tmpLine = [NSMutableArray  array];
    CGFloat width = 121.5;
    for (int i=0; i<4; i++) {
        UILabel * label = [UILabel  new];
        label.backgroundColor = [UIColor  lightGrayColor];
        label.text = title[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont  systemFontOfSize:11.0];
        [bottom addSubview:label];
        [tmp  addObject:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i==0) {
                make.leading.mas_equalTo(bottom.mas_leading).mas_offset(0);
            }else{
                UILabel * lb = tmp[i-1];
                make.leading.mas_equalTo(lb.mas_trailing);
            }
            make.top.mas_equalTo(bottom.mas_top);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(30);
        }];
        
        UIView  * line = [UIView new];
        line.backgroundColor = [UIColor whiteColor];
        [bottom addSubview:line];
        [tmpLine addObject:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i==0) {
                make.leading.mas_equalTo(122);
            }else{
                UILabel *l = tmp[i-1];
                make.leading.mas_equalTo(l.mas_trailing);
            }
            make.top.mas_equalTo(bottom.mas_top);
            make.bottom.mas_equalTo(bottom.mas_bottom);
            make.width.mas_equalTo(1);
        }];
    }
    //间隔线
    return;
    self.lineThird = [[UIView alloc] init];
    self.lineThird.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];;
    [self addSubview:self.lineThird];
    
    [self.lineThird mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.transferLbl.mas_bottom).with.offset(18);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.mas_equalTo(8);
    }];
}

- (void)changeDate:(UIDatePicker *)datePicker
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy年 MM月 dd日";
    NSString *minDate = [formatter stringFromDate:datePicker.minimumDate];
    NSString *maxDate = [formatter stringFromDate:datePicker.maximumDate];
    
    
    NSLog(@"min######%@",minDate);
    NSLog(@"max######%@",maxDate);
    
    self.startField.text = minDate;
    self.endField.text = maxDate;
}

//快选
- (void)quickSelect
{
    NSArray *arr = @[@"今天",@"昨天",@"本周",@"最近七天"];
    __weak typeof(self) weakSelf = self;
    HLPopTableView *popTV = [HLPopTableView initWithFrame:CGRectMake(50, 0, self.selectBtn.bounds.size.width , 125) dependView:self.selectBtn textArr:arr block:^(NSString *region_name, NSInteger index) {
        [weakSelf  changedSinceTimeString:index];
    }];

    [self addSubview:popTV];
}

//全部类型
- (void)pressAllBtn
{
//    NSArray *arr = @[@"所有类型",@"存款",@"返水",@"取款",@"推荐"];
    __weak typeof(self) weakSelf = self;
    HLPopTableView *popTV = [HLPopTableView initWithFrame:CGRectMake(0, 0, self.allBtn.bounds.size.width, 140) dependView:self.allBtn textArr:self.dataArray block:^(NSString *region_name, NSInteger index) {
        self->_selectIndex = index;
        [weakSelf.allBtn setTitle:region_name forState:UIControlStateNormal];
    }];

    [self addSubview:popTV];
}
#pragma mark -- 搜索
- (void)search
{
    NSDateFormatter  * formatter = [[NSDateFormatter  alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate  * startDate = [formatter  dateFromString:self.startField.text];
    NSDate  * endDate = [formatter  dateFromString:self.endField.text];
    if ( [self compareOneDay:startDate withAnotherDay:endDate] == 1) {
        showAlertView(@"提示", @"时间选择有误,请重试选择");
        return;
    }
    if (self.dataBlock) {
        NSDictionary * dic = [NSDictionary  dictionaryWithObjectsAndKeys:self.startField.text,@"startTime",self.startField.text,@"endTime",_selectIdArray[_selectIndex],@"type", nil];
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

    self.endField.text = nt[@"date"];
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
    
}
#pragma mark -- 开始时间
-(void)changedDate:(NSDictionary *)nt {
    self.startField.text = nt[@"date"];
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
            self.endField.text = dateString(date, @"yyyy-MM-dd");
            break;
         }
        case 1:{
            // 昨天
            date = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:date];
            self.startField.text = dateString(date, @"yyyy-MM-dd");
            self.endField.text = dateString([NSDate  date], @"yyyy-MM-dd");
            break;
        }
        case 2:{
            //本周
            date = currentWeekarr[0];
            self.endField.text =dateString(currentWeekarr[1], @"yyyy-MM-dd");
            self.startField.text = dateString([NSDate  date], @"yyyy-MM-dd");
            break;
        }
        case 3:{
            //最近七天
            date= [NSDate dateWithTimeInterval:-24*60*60*6 sinceDate:date];
//            NSDate * dat = [NSDate dateWithTimeInterval:24*60*60*6 sinceDate:date];
            self.endField.text = dateString([NSDate date], @"yyyy-MM-dd");
            self.startField.text = dateString(date, @"yyyy-MM-dd");
//            _capitalRecordHeaderView.endDate = [NSDate dateWithTimeInterval:24*60*60*6 sinceDate:date];
            break;
        }
        default:
            break;
    }
//    _capitalRecordHeaderView.startDate = date;
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
