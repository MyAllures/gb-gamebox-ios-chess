//
//  SH_CardRecordView.m
//  GameBox
//
//  Created by egan on 2018/7/15.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_CardRecordView.h"
#import "Masonry.h"

@implementation SH_CardRecordView

- (id)init
{
    if (self = [super init]) {
        [self createUI];
        [self createButton];
    }
    return self;
}

- (void)createUI
{
    //投注日期
    UILabel *dateLbl = [[UILabel alloc] init];
    dateLbl.text = @"投注日期:";
    dateLbl.textColor = [UIColor blackColor];
    dateLbl.font = [UIFont systemFontOfSize:15.0];
    [self addSubview:dateLbl];
    
    [dateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15);
        make.top.equalTo(self.mas_top).with.offset(25);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];

    //开始时间
    UITextField *startTF = [[UITextField alloc] init];
    startTF.borderStyle = UITextBorderStyleLine;
    startTF.layer.borderColor = [UIColor grayColor].CGColor;
    startTF.backgroundColor = [UIColor whiteColor];
    //左侧视图
    UIImage *img = [UIImage imageNamed:@"betRec_calendar_icon"];
    UIImageView *imgV = [[UIImageView alloc] initWithImage:img];
    UIView *leftV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    imgV.center = leftV.center;
    [leftV addSubview:imgV];
    //设置textField的左侧视图
    startTF.leftViewMode = UITextFieldViewModeAlways;
    startTF.leftView = leftV;
    
    [self addSubview:startTF];

    [startTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dateLbl.mas_right).with.offset(-10);
        make.top.equalTo(self.mas_top).with.offset(28);
        make.size.mas_equalTo(CGSizeMake(130, 40));
    }];

    //分割线
    UILabel *segLbl = [[UILabel alloc] init];
    segLbl.text = @"~";
    segLbl.textColor = [UIColor blackColor];
    [self addSubview:segLbl];
    
    [segLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(38);
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.left.equalTo(startTF.mas_right).with.offset(3);
    }];

    //结束时间
    UITextField *endTF = [[UITextField alloc] init];
    endTF.borderStyle = UITextBorderStyleLine;
    endTF.layer.borderColor = [UIColor grayColor].CGColor;
    endTF.backgroundColor = [UIColor whiteColor];
    //左侧视图
    UIImage *leftImg = [UIImage imageNamed:@"betRec_calendar_icon"];
    UIImageView *leftImgV = [[UIImageView alloc] initWithImage:leftImg];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    leftImgV.center = leftView.center;
    [leftView addSubview:leftImgV];
    
    //设置textField的左侧视图
    endTF.leftViewMode = UITextFieldViewModeAlways;
    endTF.leftView = leftView;
    
    [self addSubview:endTF];

    [endTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(startTF.mas_top);
        make.size.mas_equalTo(CGSizeMake(130, 40));
        make.left.equalTo(segLbl.mas_right).with.offset(3);
    }];

   //搜索按钮
    UIButton *searchBtn = [[UIButton alloc] init];
    searchBtn.layer.cornerRadius = 4.5;
    searchBtn.backgroundColor = [UIColor blueColor];
    [searchBtn setTitle:@"搜索"forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(pressSearchBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:searchBtn];

    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(27);
        make.right.equalTo(self.mas_right).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(60, 40));
    }];
}

- (void)pressSearchBtn
{
    
}

- (void)createButton
{
    NSArray *arrTitle = @[@"游戏名称",@"投注时间",@"投注额",@"派彩",@"状态"];

    int count = 5;

    NSMutableArray *btnArr = [NSMutableArray array];

    for (int i = 0; i < count; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.titleLabel.font = [UIFont systemFontOfSize:18.0];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:arrTitle[i] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor lightGrayColor];
        [btn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [btnArr addObject:btn];

        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(60);
            make.width.mas_equalTo(99);
            make.top.equalTo(self.mas_top).with.offset(95);

            if (i == 0) {
                make.left.mas_equalTo(0);
            } else {
                UIButton *button = btnArr[i-1];
                make.left.equalTo(button.mas_right).with.offset(3);
            }
        }];
    }

    UIView *resultV = [[UIView alloc] init];
    resultV.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:resultV];

    [resultV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(100);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
    }];
}

- (void)pressBtn:(UIButton *)btn
{

}

@end
