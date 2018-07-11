
//
//  SH_WelfareView.m
//  GameBox
//
//  Created by egan on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_WelfareView.h"
#import "Masonry.h"

@interface SH_WelfareView()
//资金日期
@property (nonatomic, strong) UILabel *foundLbl;
//开始时间
@property (nonatomic, strong) UITextField *startField;
//结束时间
@property (nonatomic, strong) UITextField *endField;
//快选
@property (nonatomic, strong) UIButton *selectBtn;
//全部类型
@property (nonatomic, strong) UITextField *allField;
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
//关闭按钮
@property (nonatomic, strong) UIButton *closeBtn;

@end


@implementation SH_WelfareView

 - (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self createUI];
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
    self.startField.backgroundColor = [UIColor darkGrayColor];
    [self addSubview:self.startField];

    [self.startField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(40);
        make.left.equalTo(self.mas_left).with.offset(100);
        make.size.mas_equalTo(CGSizeMake(120, 45));
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
    self.endField.backgroundColor = [UIColor darkGrayColor];
    [self addSubview:self.endField];
    
    [self.endField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120, 45));
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
        make.left.equalTo(self.endField.mas_right).with.offset(28);
        make.top.equalTo(self.mas_top).with.offset(45);
        make.size.mas_equalTo(CGSizeMake(60, 40));
    }];

    //分割线1
    self.lineFirst = [[UIView alloc] init];
    self.lineFirst.backgroundColor = [UIColor grayColor];
    [self addSubview:self.lineFirst];
    
    [self.lineFirst mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(100);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
        make.height.mas_equalTo(1);
    }];
    
    //全部类型
    self.allField = [[UITextField alloc] init];
    self.allField.backgroundColor = [UIColor darkGrayColor];
    self.allField.layer.cornerRadius = 5.0;
    self.allField.text = @"  全部类型";
    self.allField.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.allField];

    [self.allField mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.left.equalTo(self.allField.mas_right).with.offset(30);
    }];

    //分割线2
    self.lineSecond = [[UIView alloc] init];
    self.lineSecond.backgroundColor = [UIColor grayColor];
    [self addSubview:self.lineSecond];
    
    [self.lineSecond mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.top.equalTo(self.searchBtn.mas_bottom).with.offset(10);
        make.height.mas_equalTo(1);
    }];

    //取款处理中
    self.drawLbl = [[UILabel alloc] init];
    self.drawLbl.text = [NSString stringWithFormat:@"取款处理中: ¥ %f",0.0];
    self.drawLbl.textColor = [UIColor blackColor];
    self.drawLbl.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:self.drawLbl];

    [self.drawLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(8);
        make.top.equalTo(self.lineSecond.mas_bottom).with.offset(18);
    }];

    //转账处理中
    self.transferLbl = [[UILabel alloc] init];
    self.transferLbl.text = [NSString stringWithFormat:@"转账处理中: ¥ %f",0.0];
    self.transferLbl.textColor = [UIColor blackColor];
    self.transferLbl.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:self.transferLbl];

    [self.transferLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-5);
        make.top.equalTo(self.lineSecond.mas_bottom).with.offset(18);
    }];

    //间隔线
    self.lineThird = [[UIView alloc] init];
    self.lineThird.backgroundColor = [UIColor grayColor];
    [self addSubview:self.lineThird];
    
    [self.lineThird mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.transferLbl.mas_bottom).with.offset(18);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.mas_equalTo(8);
    }];

    //关闭按钮
    self.closeBtn = [[UIButton alloc] init];
    [self.closeBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.closeBtn];

    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(12);
        make.top.equalTo(self.mas_top).with.offset(-22);
    }];
}

- (void)quickSelect
{
    
}

- (void)search
{
    
}

- (void)closeView
{
    NSLog(@"This is a test");
    
    if ([self.delegate respondsToSelector:@selector(welfareViewDisappear)]) {
        [self.delegate welfareViewDisappear];
    }
}

@end
