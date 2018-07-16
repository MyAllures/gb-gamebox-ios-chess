//
//  SH_SecurityCenterView.m
//  GameBox
//
//  Created by egan on 2018/7/15.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_SecurityCenterView.h"

@interface SH_SecurityCenterView ()
@property (nonatomic, strong) NSArray *titleArr;
@end

@implementation SH_SecurityCenterView

- (id)init
{
    if (self = [super init]) {
        [self buttonView];
        [self informationView];
    }
    return self;
}

- (void)buttonView
{
    UIView *btnView = [[UIView alloc] init];
    btnView.backgroundColor = [UIColor colorWithRed:36.1/255.0 green:42/255.0 blue:84.5/255.0 alpha:1];
    [self addSubview:btnView];
    
    [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(200);
        make.top.equalTo(self).with.offset(0);
        make.left.equalTo(self).with.offset(0);
        make.bottom.equalTo(self).with.offset(0);
    }];
    
    self.titleArr = @[@"修改密码登录",@"修改安全密码",@"银行卡"];
    NSMutableArray *btnArr = [NSMutableArray array];
    
    for (int i = 0; i < 3; i++) {
        UIButton *button = [[UIButton alloc] init];
        button.titleLabel.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:17.0];
        [button setTitle:self.titleArr[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(pressBtn) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:@"button-long"] forState:UIControlStateNormal];
        [btnArr addObject:button];
        
        if (i == 2) {
            [button setBackgroundImage:[UIImage imageNamed:@"button-long-click"] forState:UIControlStateNormal];
        }
        
        [btnView addSubview:button];
    
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.top.equalTo(btnView.mas_top).with.offset(12);
            } else {
                UIButton *btn = btnArr[i - 1];
                make.top.equalTo(btn.mas_bottom).with.offset(12);
            }
            make.size.mas_equalTo(CGSizeMake(160, 60));
            make.left.equalTo(btnView.mas_left).with.offset(20);
        }];
    }
    
}

- (void)pressBtn
{
    
}

- (void)informationView
{
    UIView *informationV = [[UIView alloc] init];
    informationV.backgroundColor = [UIColor colorWithRed:43.6/255.0 green:50.7/255.0 blue:102/255.0 alpha:1];
    [self addSubview:informationV];
    
    [informationV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.equalTo(self.mas_left).with.offset(218);
        make.size.mas_equalTo(CGSizeMake(415, 280));
    }];

    UILabel *nameLbl = [[UILabel alloc] init];
    nameLbl.text = @"真实姓名";
    nameLbl.textColor = [UIColor whiteColor];
    nameLbl.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:16.0];
    [informationV addSubview:nameLbl];
    
    [nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 17));
        make.left.equalTo(informationV.mas_left).with.offset(33);
        make.top.equalTo(informationV.mas_top).with.offset(31);
    }];

    UITextField *nameTF = [[UITextField alloc] init];
    nameTF.placeholder = @"姓名";
    nameTF.backgroundColor = [UIColor colorWithRed:14 green:41 blue:95 alpha:0.6];
    nameTF.textAlignment = NSTextAlignmentCenter;
    nameTF.borderStyle = UITextBorderStyleRoundedRect;
    nameTF.layer.cornerRadius = 4.5;
    [informationV addSubview:nameTF];
    
    [nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(informationV.mas_top).with.offset(20);
        make.left.equalTo(nameLbl.mas_left).with.offset(70);
        make.size.mas_equalTo(CGSizeMake(280, 40));
    }];

    UILabel *carefulLbl = [[UILabel alloc] init];
    carefulLbl.text = @"银行卡户名和真实姓名一致才能取款成功";
    carefulLbl.textColor = [UIColor whiteColor];
    carefulLbl.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:12.0];
    [informationV addSubview:carefulLbl];

    [carefulLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameTF.mas_bottom).with.offset(3);
        make.right.equalTo(informationV.mas_right).with.offset(-65);
    }];

    UILabel *bankLbl = [[UILabel alloc] init];
    bankLbl.text = @"银行";
    bankLbl.textAlignment = NSTextAlignmentCenter;
    bankLbl.textColor = [UIColor whiteColor];
    bankLbl.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:16.0];
    [informationV addSubview:bankLbl];

    [bankLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(informationV.mas_left).with.offset(60);
        make.size.mas_equalTo(CGSizeMake(40, 14));
        make.top.equalTo(nameLbl.mas_bottom).with.offset(50);
    }];

    UITextField *bankTF = [[UITextField alloc] init];
    bankTF.textColor = [UIColor whiteColor];
    bankTF.backgroundColor = [UIColor colorWithRed:14 green:41 blue:95 alpha:0.6];
    bankTF.textAlignment = NSTextAlignmentCenter;
    bankTF.borderStyle = UITextBorderStyleRoundedRect;
    bankTF.layer.cornerRadius = 4.5;
    bankTF.placeholder = @"请选择";
    //右边图片
    UIImageView *rightView = [[UIImageView alloc] init];
    rightView.image = [UIImage imageNamed:@"down"];
    rightView.frame = CGRectMake(0, 0, 40, 40);
    rightView.contentMode = UIViewContentModeCenter;
    bankTF.rightView = rightView;
    bankTF.rightViewMode = UITextFieldViewModeAlways;
    [informationV addSubview:bankTF];
    
    [bankTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bankLbl.mas_right).with.offset(4);
        make.size.mas_equalTo(CGSizeMake(280, 40));
        make.top.equalTo(carefulLbl.mas_bottom).with.offset(5);
    }];

    UILabel *numLbl = [[UILabel alloc] init];
    numLbl.text = @"卡号";
    numLbl.textAlignment = NSTextAlignmentCenter;
    numLbl.textColor = [UIColor whiteColor];
    numLbl.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:16.0];
    [informationV addSubview:numLbl];
    
    [numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 14));
        make.left.equalTo(informationV.mas_left).with.offset(60);
        make.top.equalTo(bankTF.mas_bottom).with.offset(25);
    }];
    
    UITextField *numTF = [[UITextField alloc] init];
    numTF.textColor = [UIColor whiteColor];
    numTF.backgroundColor = [UIColor colorWithRed:14 green:41 blue:95 alpha:0.6];
    numTF.textAlignment = NSTextAlignmentCenter;
    numTF.borderStyle = UITextBorderStyleRoundedRect;
    numTF.layer.cornerRadius = 4.5;
    numTF.placeholder = @"请输入卡号";
    [informationV addSubview:numTF];
    
    [numTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(280, 40));
        make.left.equalTo(numLbl.mas_right).with.offset(4);
        make.top.equalTo(bankTF.mas_bottom).with.offset(10);
    }];

    UILabel *openLbl = [[UILabel alloc] init];
    openLbl.text = @"开户银行";
    openLbl.textAlignment = NSTextAlignmentCenter;
    openLbl.textColor = [UIColor whiteColor];
    openLbl.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:16.0];
    [informationV addSubview:openLbl];
    
    [openLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 17));
        make.left.equalTo(informationV.mas_left).with.offset(25);
        make.top.equalTo(numTF.mas_bottom).with.offset(18);
    }];

    UITextField *openTF = [[UITextField alloc] init];
    openTF.textColor = [UIColor whiteColor];
    openTF.backgroundColor = [UIColor colorWithRed:14 green:41 blue:95 alpha:0.6];
    openTF.textAlignment = NSTextAlignmentCenter;
    openTF.borderStyle = UITextBorderStyleRoundedRect;
    openTF.layer.cornerRadius = 4.5;
    openTF.placeholder = @"如:河北唐山银行";
    [informationV addSubview:openTF];
    
    [openTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(280, 40));
        make.left.equalTo(openLbl.mas_right).with.offset(0);
        make.top.equalTo(numTF.mas_bottom).with.offset(10);
    }];

    //选择
    UILabel *selLbl = [[UILabel alloc] init];
    selLbl.text = @"选择”其他“银行必填";
    selLbl.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:9.0];
    selLbl.textColor = [UIColor whiteColor];
    [informationV addSubview:selLbl];
    
    [selLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 10));
        make.left.equalTo(informationV.mas_left).with.offset(180);
        make.top.equalTo(openTF.mas_bottom).with.offset(3);
    }];
    
    
    UIButton *confiBtn = [[UIButton alloc] init];
    [confiBtn setTitle:@"确认提交" forState:UIControlStateNormal];
    [confiBtn setBackgroundImage:[UIImage imageNamed:@"button-long"] forState:UIControlStateNormal];
    [confiBtn addTarget:self action:@selector(pressConfirmation) forControlEvents:UIControlEventTouchUpInside];
    [informationV addSubview:confiBtn];
 
    [confiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(160, 40));
        make.top.equalTo(openTF.mas_bottom).with.offset(15);
        make.left.equalTo(informationV.mas_left).with.offset(135);
    }];
}

- (void)pressConfirmation
{
    
}

@end
