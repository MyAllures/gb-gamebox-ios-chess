//
//  SH_CardRecordHeaderView.m
//  GameBox
//
//  Created by Paul on 2018/7/17.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_CardRecordHeaderView.h"

#import "PGDatePicker.h"
#import "PGDatePickManager.h"
@interface  SH_CardRecordHeaderView()<PGDatePickerDelegate>

@property (weak, nonatomic) IBOutlet UIView *letf_view;
@property (weak, nonatomic) IBOutlet UIView *right_view;
@property (weak, nonatomic) IBOutlet UILabel *start_label;
@property (weak, nonatomic) IBOutlet UILabel *end_label;

@property (strong, nonatomic) NSString *startTimeStr;
@property (strong, nonatomic) NSString *endTimeStr;
@property(nonatomic, strong) NSString *startAndEndDateStr;
@end
@implementation SH_CardRecordHeaderView
+(instancetype)instanceCardRecordHeaderView{
    return [[NSBundle  mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}
-(void)awakeFromNib{
    [super  awakeFromNib];
    [self configUI];
}

#pragma mark --- 配置UI
-(void)configUI{
    self.start_label.text = dateString([NSDate date], @"yyyy-MM-dd");
    self.end_label.text = dateString([NSDate date], @"yyyy-MM-dd");
    [self borderColorWith:self.letf_view];
    [self borderColorWith:self.right_view];
}
#pragma mark-- 切圆角 
-(void)borderColorWith:(UIView*)view{
    view.layer.cornerRadius= 5;
    view.layer.masksToBounds = YES;
    view.layer.borderWidth = 1;
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
}
- (IBAction)searchBtnClick:(UIButton *)sender {
    if (sender.tag == 100) {
        PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
        datePickManager.style = PGDatePickManagerStyle1;
        datePickManager.isShadeBackgroud = true;
        
        PGDatePicker *datePicker = datePickManager.datePicker;
        datePicker.isHiddenMiddleText = false;
        datePicker.delegate = self;
        datePicker.datePickerType = PGPickerViewType3;
        datePicker.datePickerMode = PGDatePickerModeDate;
        [self presentViewController:datePickManager addTargetViewController:self.alertVC];
    }else if (sender.tag ==101){
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
        [self presentViewController:datePickManager addTargetViewController:self.alertVC];
    }else{
        if (self.searchConditionBlock) {
        self.searchConditionBlock(@{@"startTime":self.start_label.text,@"endTime":self.end_label.text});
        }
    }
}
#pragma mark --- 模态弹出viewController
-(void)presentViewController:(UIViewController*)viewController addTargetViewController:(UIViewController*)targetVC{
    viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    viewController.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    [targetVC presentViewController:viewController animated:YES completion:nil];
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
    if (self.searchConditionBlock) {
        self.searchConditionBlock(@{@"startTime":self.start_label.text,@"endTime":self.end_label.text});
    }
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
    if (self.searchConditionBlock) {
        self.searchConditionBlock(@{@"startTime":self.start_label.text,@"endTime":self.end_label.text});
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

@end
