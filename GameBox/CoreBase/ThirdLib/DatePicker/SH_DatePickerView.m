//
//  SH_DatePickerView.m
//  testOne
//
//  Created by jun on 2018/7/20.
//  Copyright © 2018年 jun. All rights reserved.
//

#import "SH_DatePickerView.h"

#define kPickerSize self.pickerView.frame.size
#define RGBA(r, g, b, a) ([UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a])
#define RGB(r, g, b) RGBA(r,g,b,1)
// 判断是否是iPhone X
#define isiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// home indicator
#define bottom_height (isiPhoneX ? 34.f : 10.f)


#define MAXYEAR 2099
#define MINYEAR 1000

typedef void(^doneBlock)(NSDate *);
@interface SH_DatePickerView()<UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *yearLab;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property(nonatomic,strong)NSMutableArray *yearArray;
@property(nonatomic,strong)NSMutableArray *monthArray;
@property(nonatomic,strong)NSMutableArray *dayArray;
@property(nonatomic,strong)NSMutableArray *hourArray;
@property(nonatomic,strong)NSMutableArray *minuteArray;
@property(nonatomic,copy)NSString *dateFormatter;
@property(nonatomic,assign)NSInteger yearIndex;
@property(nonatomic,assign)NSInteger monthIndex;
@property(nonatomic,assign)NSInteger dayIndex;
@property(nonatomic,assign)NSInteger hourIndex;
@property(nonatomic,assign)NSInteger minuteIndex;
@property(nonatomic,assign)NSInteger preRow;
@property(nonatomic,strong)NSDate *startDate;
@property (nonatomic, retain) NSDate *scrollToDate;//滚到指定日期
@property (nonatomic,strong)doneBlock doneBlock;
@property (nonatomic,assign)DateStyle datePickerStyle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end
@implementation SH_DatePickerView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self configUI];

}
-(void)configUI{
    self.bottomConstraint.constant = bottom_height;
    self.pickerView.showsSelectionIndicator = YES;
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
}
/**
 默认滚动到当前时间
 */
-(void)setDateStyle:(DateStyle)datePickerStyle CompleteBlock:(void(^)(NSDate *))completeBlock {
        self.datePickerStyle = datePickerStyle;
        switch (datePickerStyle) {
            case DateStyleShowYearMonthDayHourMinute:
                self.dateFormatter = @"yyyy-MM-dd HH:mm";
                break;
            case DateStyleShowYearMonthDay:
                self.dateFormatter = @"yyyy-MM-dd";
                break;
            default:
                self.dateFormatter = @"yyyy-MM-dd HH:mm";
                break;
        }
        [self defaultConfig];
        if (completeBlock) {
            self.doneBlock = ^(NSDate *selectDate) {
                completeBlock(selectDate);
            };
        }
}

/**
 滚动到指定的的日期
 */
-(void)setDateStyle:(DateStyle)datePickerStyle scrollToDate:(NSDate *)scrollToDate CompleteBlock:(void(^)(NSDate *))completeBlock {
        self.scrollToDate = scrollToDate;
        [self setDateStyle:datePickerStyle CompleteBlock:completeBlock];
}


-(void)defaultConfig {
    if (!self.scrollToDate) {
        self.scrollToDate = [NSDate date];
    }
    //循环滚动时需要用到
    self.preRow = (self.scrollToDate.year-MINYEAR)*12+self.scrollToDate.month-1;

    //设置年月日时分数据
    self.yearArray = [self setArray:self.yearArray];
    self.monthArray = [self setArray:self.monthArray];
    self.dayArray = [self setArray:self.dayArray];
    self.hourArray = [self setArray:self.hourArray];
    self.minuteArray = [self setArray:self.minuteArray];

    for (int i=0; i<60; i++) {
        NSString *num = [NSString stringWithFormat:@"%02d",i];
        if (0<i && i<=12)
            [self.monthArray addObject:num];
        if (i<24)
            [self.hourArray addObject:num];
        [self.minuteArray addObject:num];
    }
    for (NSInteger i=MINYEAR; i<=MAXYEAR; i++) {
        NSString *num = [NSString stringWithFormat:@"%ld",(long)i];
        [self.yearArray addObject:num];
    }

    //最大最小限制
    if (!self.maxLimitDate) {
        self.maxLimitDate = [NSDate date:@"2099-12-31 23:59" WithFormat:@"yyyy-MM-dd HH:mm"];
    }
    //最小限制
    if (!self.minLimitDate) {
        self.minLimitDate = [NSDate date:@"1000-01-01 00:00" WithFormat:@"yyyy-MM-dd HH:mm"];
    }
}

-(void)addLabelWithName:(NSArray *)nameArr {
    for (id subView in self.yearLab.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            [subView removeFromSuperview];
        }
    }

    if (!self.dateLabelColor) {
        self.dateLabelColor =  RGB(247, 133, 51);
    }

    for (int i=0; i<nameArr.count; i++) {
        CGFloat labelX = kPickerSize.width/(nameArr.count*2)+18+kPickerSize.width/nameArr.count*i;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(labelX, self.yearLab.frame.size.height/2-15/2.0, 15, 15)];
        label.text = nameArr[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor =  self.dateLabelColor;
        label.backgroundColor = [UIColor clearColor];
        [self.yearLab addSubview:label];
    }
}


-(void)setDateLabelColor:(UIColor *)dateLabelColor {
    _dateLabelColor = dateLabelColor;
    for (id subView in self.yearLab.subviews) {
        if ([subView isKindOfClass:[UILabel class]]) {
            UILabel *label = subView;
            label.textColor = _dateLabelColor;
        }
    }
}


- (NSMutableArray *)setArray:(id)mutableArray
{
    if (mutableArray)
        [mutableArray removeAllObjects];
    else
        mutableArray = [NSMutableArray array];
    return mutableArray;
}

-(void)setYearLabelColor:(UIColor *)yearLabelColor {
    self.yearLab.textColor = yearLabelColor;
}

#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    switch (self.datePickerStyle) {
        case DateStyleShowYearMonthDayHourMinute:
            [self addLabelWithName:@[@"年",@"月",@"日",@"时",@"分"]];
            return 5;
        case DateStyleShowYearMonthDay:
            [self addLabelWithName:@[@"年",@"月",@"日"]];
            return 3;
        default:
            return 0;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSArray *numberArr = [self getNumberOfRowsInComponent];
    return [numberArr[component] integerValue];
}

-(NSArray *)getNumberOfRowsInComponent {

    NSInteger yearNum = self.yearArray.count;
    NSInteger monthNum = self.monthArray.count;
    NSInteger dayNum = [self DaysfromYear:[self.yearArray[self.yearIndex] integerValue] andMonth:[self.monthArray[self.monthIndex] integerValue]];
    NSInteger hourNum = self.hourArray.count;
    NSInteger minuteNUm = self.minuteArray.count;
    switch (self.datePickerStyle) {
        case DateStyleShowYearMonthDayHourMinute:
            return @[@(yearNum),@(monthNum),@(dayNum),@(hourNum),@(minuteNUm)];
            break;
        case DateStyleShowYearMonthDay:
            return @[@(yearNum),@(monthNum),@(dayNum)];
            break;
        default:
            return @[];
            break;
    }

}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}


-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *customLabel = (UILabel *)view;
    if (!customLabel) {
        customLabel = [[UILabel alloc] init];
        customLabel.textAlignment = NSTextAlignmentCenter;
        [customLabel setFont:[UIFont systemFontOfSize:17]];
    }
    NSString *title;

    switch (self.datePickerStyle) {
        case DateStyleShowYearMonthDayHourMinute:
            if (component==0) {
                title = self.yearArray[row];
            }
            if (component==1) {
                title = self.monthArray[row];
            }
            if (component==2) {
                title = self.dayArray[row];
            }
            if (component==3) {
                title = self.hourArray[row];
            }
            if (component==4) {
                title = self.minuteArray[row];
            }
            break;
        case DateStyleShowYearMonthDay:
            if (component==0) {
                title = self.yearArray[row];
            }
            if (component==1) {
                title = self.monthArray[row];
            }
            if (component==2) {
                title = self.dayArray[row];
            }
            break;
        default:
            title = @"";
            break;
    }
    customLabel.text = title;
    if (!self.datePickerColor) {
        self.datePickerColor = [UIColor blackColor];
    }
    customLabel.textColor = self.datePickerColor;
    return customLabel;

}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    switch (self.datePickerStyle) {
        case DateStyleShowYearMonthDayHourMinute:{

            if (component == 0) {
                self.yearIndex = row;
                self.yearLab.text =self.yearArray[self.yearIndex];
            }
            if (component == 1) {
                self.monthIndex = row;
            }
            if (component == 2) {
                self.dayIndex = row;
            }
            if (component == 3) {
                self.hourIndex = row;
            }
            if (component == 4) {
                self.minuteIndex = row;
            }
            if (component == 0 || component == 1){
                [self DaysfromYear:[self.yearArray[self.yearIndex] integerValue] andMonth:[self.monthArray[self.monthIndex] integerValue]];
                if (self.dayArray.count-1<self.dayIndex) {
                    self.dayIndex = self.dayArray.count-1;
                }

            }
        }
            break;
        case DateStyleShowYearMonthDay:{
            if (component == 0) {
                self.yearIndex = row;
                self.yearLab.text =self.yearArray[self.yearIndex];
            }
            if (component == 1) {
                self.monthIndex = row;
            }
            if (component == 2) {
                self.dayIndex = row;
            }
            if (component == 0 || component == 1){
                [self DaysfromYear:[self.yearArray[self.yearIndex] integerValue] andMonth:[self.monthArray[self.monthIndex] integerValue]];
                if (self.dayArray.count-1<self.dayIndex) {
                    self.dayIndex = self.dayArray.count-1;
                }
            }
        }
            break;
        default:
            break;
    }

    [pickerView reloadAllComponents];
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",self.yearArray[self.yearIndex],self.monthArray[self.monthIndex],self.dayArray[self.dayIndex],self.hourArray[self.hourIndex],self.minuteArray[self.minuteIndex]];

    self.scrollToDate = [[NSDate date:dateStr WithFormat:@"yyyy-MM-dd HH:mm"] dateWithFormatter:self.dateFormatter];

    if ([self.scrollToDate compare:self.minLimitDate] == NSOrderedAscending) {
        self.scrollToDate = self.minLimitDate;
        [self getNowDate:self.minLimitDate animated:YES];
    }else if ([self.scrollToDate compare:self.maxLimitDate] == NSOrderedDescending){
        self.scrollToDate = self.maxLimitDate;
        [self getNowDate:self.maxLimitDate animated:YES];
    }

    self.startDate = self.scrollToDate;

}

-(void)yearChange:(NSInteger)row {

    self.monthIndex = row%12;
    //年份状态变化
    if (row-self.preRow <12 && row-self.preRow>0 && [self.monthArray[self.monthIndex] integerValue] < [self.monthArray[self.preRow%12] integerValue]) {
        self.yearIndex ++;
    } else if(self.preRow-row <12 && self.preRow-row > 0 && [self.monthArray[self.monthIndex] integerValue] > [self.monthArray[self.preRow%12] integerValue]) {
        self.yearIndex --;
    }else {
        NSInteger interval = (row-self.preRow)/12;
        self.yearIndex += interval;
    }

    self.yearLab.text = self.yearArray[self.yearIndex];

    self.preRow = row;
}

#pragma mark - Action
-(void)showPickerView {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(window);
    }];
}
-(void)dismiss {
   [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismiss];
}
- (IBAction)doneAction:(UIButton *)btn {
    
    self.startDate = [self.scrollToDate dateWithFormatter:self.dateFormatter];
    self.doneBlock(self.startDate);
    [self dismiss];
}

#pragma mark - tools
//通过年月求每月天数
- (NSInteger)DaysfromYear:(NSInteger)year andMonth:(NSInteger)month
{
    NSInteger num_year  = year;
    NSInteger num_month = month;
    
    BOOL isrunNian = num_year%4==0 ? (num_year%100==0? (num_year%400==0?YES:NO):YES):NO;
    switch (num_month) {
        case 1:case 3:case 5:case 7:case 8:case 10:case 12:{
            [self setdayArray:31];
            return 31;
        }
        case 4:case 6:case 9:case 11:{
            [self setdayArray:30];
            return 30;
        }
        case 2:{
            if (isrunNian) {
                [self setdayArray:29];
                return 29;
            }else{
                [self setdayArray:28];
                return 28;
            }
        }
        default:
            break;
    }
    return 0;
}

//设置每月的天数数组
- (void)setdayArray:(NSInteger)num
{
    [self.dayArray removeAllObjects];
    for (int i=1; i<=num; i++) {
        [self.dayArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
}

//滚动到指定的时间位置
- (void)getNowDate:(NSDate *)date animated:(BOOL)animated
{
    if (!date) {
        date = [NSDate date];
    }
    
    [self DaysfromYear:date.year andMonth:date.month];
    
    self.yearIndex = date.year-MINYEAR;
    self.monthIndex = date.month-1;
    self.dayIndex = date.day-1;
    self.hourIndex = date.hour;
    self.minuteIndex = date.minute;
    
    //循环滚动时需要用到
    self.preRow = (self.scrollToDate.year-MINYEAR)*12+self.scrollToDate.month-1;
    
    NSArray *indexArray;
    
    if (self.datePickerStyle == DateStyleShowYearMonthDayHourMinute)
        indexArray = @[@(self.yearIndex),@(self.monthIndex),@(self.dayIndex),@(self.hourIndex),@(self.minuteIndex)];
    if (self.datePickerStyle == DateStyleShowYearMonthDay)
        indexArray = @[@(self.yearIndex),@(self.monthIndex),@(self.dayIndex)];
    self.yearLab.text = self.yearArray[self.yearIndex];
    
    [self.pickerView reloadAllComponents];
    
    for (int i=0; i<indexArray.count; i++) {
            [self.pickerView selectRow:[indexArray[i] integerValue] inComponent:i animated:animated];
        
    }
}


-(void)setMinLimitDate:(NSDate *)minLimitDate {
    _minLimitDate = minLimitDate;
    if ([self.scrollToDate compare:self.minLimitDate] == NSOrderedAscending) {
        self.scrollToDate = self.minLimitDate;
    }
    [self getNowDate:self.scrollToDate animated:NO];
}
-(void)setHideBackgroundYearLabel:(BOOL)hideBackgroundYearLabel {
    self.yearLab.textColor = [UIColor clearColor];
}


@end
