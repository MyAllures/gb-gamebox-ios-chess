//
//  SH_CardRecordHeaderView.m
//  GameBox
//
//  Created by Paul on 2018/7/17.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_CardRecordHeaderView.h"

#import "SH_NiceDatePickerView.h"
@interface  SH_CardRecordHeaderView()

@property (weak, nonatomic) IBOutlet UIView *letf_view;
@property (weak, nonatomic) IBOutlet UIView *right_view;
@property (weak, nonatomic) IBOutlet UILabel *start_label;
@property (weak, nonatomic) IBOutlet UILabel *end_label;

@property (strong, nonatomic) NSString *startTimeStr;
@property (strong, nonatomic) NSString *endTimeStr;
@property(nonatomic,strong)SH_NiceDatePickerView * datePickerView;
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
        __weak  typeof(self) weakSelf = self;
        [self.datePickerView setDateStyle:DateStyleShowYearMonthDay CompleteBlock:^(NSDate * date) {
            weakSelf.startTimeStr = dateString(date, @"yyyy-MM-dd");
            if (!weakSelf.endTimeStr) {
                weakSelf.endTimeStr = [weakSelf getCurrentTimes];
            }
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *startDate = [dateFormatter dateFromString:weakSelf.startTimeStr];
            NSDate *endDate = [dateFormatter dateFromString:weakSelf.endTimeStr];
            if (startDate > endDate) {
                showAlertView(@"提示", @"时间选择有误,请重试选择");
                return;
            }
            weakSelf.start_label.text = dateString(date, @"yyyy-MM-dd");
            if (weakSelf.searchConditionBlock) {
                weakSelf.searchConditionBlock(@{@"startTime":weakSelf.start_label.text,@"endTime":weakSelf.end_label.text});
            }
        }];
        [self.datePickerView  showPickerView];
    }else if (sender.tag ==101){

        __weak  typeof(self) weakSelf = self;
        [self.datePickerView setDateStyle:DateStyleShowYearMonthDay CompleteBlock:^(NSDate * date) {
            weakSelf.endTimeStr = dateString(date, @"yyyy-MM-dd");
            if (!weakSelf.startTimeStr) {
                weakSelf.startTimeStr = [weakSelf getCurrentTimes];
            }
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *startDate = [dateFormatter dateFromString:weakSelf.startTimeStr];
            NSDate *endDate = [dateFormatter dateFromString:weakSelf.endTimeStr];
            if (startDate > endDate) {
                showAlertView(@"提示", @"时间选择有误,请重试选择");
                return;
            }
            weakSelf.end_label.text = dateString(date, @"yyyy-MM-dd");
            if (weakSelf.searchConditionBlock) {
                weakSelf.searchConditionBlock(@{@"startTime":weakSelf.start_label.text,@"endTime":weakSelf.end_label.text});
            }
        }];
        [self.datePickerView  showPickerView];
    }else{
        if (self.searchConditionBlock) {
        self.searchConditionBlock(@{@"startTime":self.start_label.text,@"endTime":self.end_label.text});
        }
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
#pragma mark ---getter  method
-(SH_NiceDatePickerView *)datePickerView{
    if (!_datePickerView) {
        _datePickerView = [[NSBundle  mainBundle] loadNibNamed:@"" owner:nil options:nil].lastObject;
    }
    return _datePickerView;
}
@end
