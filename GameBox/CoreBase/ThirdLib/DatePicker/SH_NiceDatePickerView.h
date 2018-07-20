//
//  SH_DatePickerView.h
//  testOne
//
//  Created by jun on 2018/7/20.
//  Copyright © 2018年 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDate+Extension.h"
/**
 *  弹出日期类型
 */
typedef enum{
    DateStyleShowYearMonthDayHourMinute  = 0,//年月日时分
    DateStyleShowYearMonthDay,//年月日
}DateStyle;

@interface SH_NiceDatePickerView : UIView
/**
 *  年-月-日-时-分 文字颜色(默认橙色)
 */
@property (nonatomic,strong)UIColor *dateLabelColor;
/**
 *  滚轮日期颜色(默认黑色)
 */
@property (nonatomic,strong)UIColor *datePickerColor;

/**
 *  限制最大时间（默认2099）datePicker大于最大日期则滚动回最大限制日期
 */
@property (nonatomic, retain) NSDate *maxLimitDate;
/**
 *  限制最小时间（默认0） datePicker小于最小日期则滚动回最小限制日期
 */
@property (nonatomic, retain) NSDate *minLimitDate;

/**
 *  大号年份字体颜色(默认灰色)想隐藏可以设置为clearColor
 */
@property (nonatomic, retain) UIColor *yearLabelColor;

/**
 *  隐藏背景年份文字
 */
@property (nonatomic, assign) BOOL hideBackgroundYearLabel;

/**
 默认滚动到当前时间
 */
-(void)setDateStyle:(DateStyle)datePickerStyle CompleteBlock:(void(^)(NSDate *))completeBlock;

/**
 滚动到指定的的日期
 */
-(void)setDateStyle:(DateStyle)datePickerStyle scrollToDate:(NSDate *)scrollToDate CompleteBlock:(void(^)(NSDate *))completeBlock;
-(void)showPickerView;
@end
