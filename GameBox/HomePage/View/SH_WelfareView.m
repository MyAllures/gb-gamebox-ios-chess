
//
//  SH_WelfareView.m
//  GameBox
//
//  Created by egan on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_WelfareView.h"
#import "Masonry.h"
#import "HLPopTableView.h"

@interface SH_WelfareView() <UITextFieldDelegate>
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

@end

@implementation SH_WelfareView

 - (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self createUI];
        [self createDatePicker];
    }
    return self;
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
        make.top.equalTo(self.mas_top).mas_equalTo(40);
        make.left.equalTo(self.mas_left).mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(130, 35));
    }];

    //开始时间
    self.startField = [[UITextField alloc] init];
    self.startField.delegate = self;
    self.startField.tag = 101;
    self.startField.backgroundColor = [UIColor whiteColor];
    self.startField.borderStyle = UITextBorderStyleLine;
    //左侧图片
    UIImage *img = [UIImage imageNamed:@"betRec_calendar_icon"];
    UIImageView *imgV = [[UIImageView alloc] initWithImage:img];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    imgV.center = view.center;
    [view addSubview:imgV];
    
    self.startField.leftViewMode = UITextFieldViewModeAlways;
    self.startField.leftView = view;
    [self addSubview:self.startField];

    [self.startField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(40);
        make.left.equalTo(self.mas_left).with.offset(100);
        make.size.mas_equalTo(CGSizeMake(140, 45));
    }];

    //间隔线
    self.distanceLbl = [[UILabel alloc] init];
    self.distanceLbl.text = @"~";
    self.distanceLbl.textColor = [UIColor blackColor];
    self.distanceLbl.font = [UIFont systemFontOfSize:18.0];
    [self addSubview:self.distanceLbl];
    
    [self.distanceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 10));
        make.left.equalTo(self.startField.mas_right).with.offset(5);
        make.top.equalTo(self.mas_top).with.offset(55);
    }];

    //结束时间
    self.endField = [[UITextField alloc] init];
    self.endField.delegate = self;
    self.endField.tag = 102;
    self.endField.backgroundColor = [UIColor whiteColor];
    self.endField.borderStyle = UITextBorderStyleLine;
    
    //左侧图片
    UIImage *img1 = [UIImage imageNamed:@"betRec_calendar_icon"];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img1];
    UIView *leftV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 200)];
    imgView.center = leftV.center;
    [leftV addSubview:imgView];
    
    self.endField.leftViewMode = UITextFieldViewModeAlways;
    self.endField.leftView = leftV;
    
    [self addSubview:self.endField];
    
    [self.endField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(140, 45));
        make.left.equalTo(self.distanceLbl.mas_right).with.offset(0);
        make.top.equalTo(self.mas_top).with.offset(40);
    }];

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
        make.right.equalTo(self.mas_right).with.offset(-23);
        make.top.equalTo(self.mas_top).with.offset(45);
        make.size.mas_equalTo(CGSizeMake(60, 40));
    }];

    //分割线1
    self.lineFirst = [[UIView alloc] init];
    self.lineFirst.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.lineFirst];
    
    [self.lineFirst mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(100);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.height.mas_equalTo(1);
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
    self.lineSecond.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.lineSecond];
    
    [self.lineSecond mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.top.equalTo(self.searchBtn.mas_bottom).with.offset(10);
        make.height.mas_equalTo(1);
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
    
    
    //间隔线
    self.lineThird = [[UIView alloc] init];
    self.lineThird.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.lineThird];
    
    [self.lineThird mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.transferLbl.mas_bottom).with.offset(18);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.mas_equalTo(8);
    }];
}

//创建日期选择器
- (void)createDatePicker
{
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setDate:[NSDate date] animated:YES];
    
    [datePicker addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    //设置最大时间，当前时间往后推10年
    [comps setYear:10];
    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    //设置最小时间，当前时间往前推10年
    [comps setYear:-10];
    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    
    [datePicker setDate:minDate];
    [datePicker setDate:maxDate];
    
    self.startField.inputView = datePicker;
    self.endField.inputView = datePicker;
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
    NSArray *arr = @[@"今天",@"昨天",@"本周"];
    
    HLPopTableView *popTV = [HLPopTableView initWithFrame:CGRectMake(0, 0, self.selectBtn.bounds.size.width + 5, 125) dependView:self.selectBtn textArr:arr block:^(NSString *region_name, NSInteger index) {
        
    }];

    [self addSubview:popTV];
}

//全部类型
- (void)pressAllBtn
{
    NSArray *arr = @[@"所有",@"存款",@"返水",@"取款",@"推荐"];
    
    HLPopTableView *popTV = [HLPopTableView initWithFrame:CGRectMake(0, 0, self.allBtn.bounds.size.width, 140) dependView:self.allBtn textArr:arr block:^(NSString *region_name, NSInteger index) {
        
    }];

    [self addSubview:popTV];
}

- (void)search
{
   
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return NO;
}



@end
