

//
//  PlayerCenterViewController.m
//  GameBox
//
//  Created by egan on 2018/7/6.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "PlayerCenterViewController.h"
#import "UIImageView+RadioImageView.h"
#import "Masonry.h"

@interface PlayerCenterViewController ()
//用户信息视图
@property (nonatomic, strong) UIView *informationV;
//用户记录视图
@property (nonatomic, strong) UIView *recordV;
//背景视图
@property (nonatomic, strong) UIView *backgroundV;
//用户头像
@property (nonatomic, strong) UIImageView *headImage;
//用户id
@property (nonatomic, strong) UILabel *idLabel;
//欢迎光临
@property (nonatomic, strong) UILabel *welcomLbl;
//当前福利
@property (nonatomic, strong) UILabel *welfareLbl;
//福利数额
@property (nonatomic, strong) UILabel *amountLBL;
//返回按钮
@property (nonatomic, strong) UIButton *backBtn;
//福利视图窗口
@property (nonatomic, strong) UIView *welfareV;
//关闭窗口按钮
@property (nonatomic, strong) UIButton *closeBtn;


@end

@implementation PlayerCenterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //创建背景图
    [self createBackgroundV];
    //创建用户信息视图
    [self createInformationV];
    //创建用户记录视图
    [self createRecordV];

}

//创建背景图
- (void)createBackgroundV
{
    self.backgroundV = [[UIView alloc] init];
    self.backgroundV.backgroundColor = [UIColor blackColor];
    self.backgroundV.alpha = 0.5;
    [self.view addSubview:self.backgroundV];
    
    [self.backgroundV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
}

- (void)createInformationV
{
    //用户信息视图
    self.informationV = [[UIView alloc] init];
    self.informationV.backgroundColor = [UIColor blueColor];
    [self.backgroundV addSubview:self.informationV];

    [self.informationV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(45));
        make.width.mas_equalTo(@(80));
        make.top.equalTo(self.backgroundV.mas_top);
        make.right.equalTo(self.backgroundV.mas_right);
        make.bottom.equalTo(self.backgroundV.mas_bottom);
    }];
    
    //用户头像
    self.headImage = [[UIImageView alloc] init];
    [self.headImage addCorner:30.0];
    [self.informationV addSubview:self.headImage];
    
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.equalTo(self.informationV.mas_top).with.mas_equalTo(@(-5));
        make.left.equalTo(self.informationV.mas_left).with.mas_equalTo(@(18));
        make.bottom.equalTo(self.informationV.mas_bottom).with.mas_equalTo(@(25));
        make.right.equalTo(self.informationV.mas_right).with.mas_equalTo(@(-85));
    }];
 
    //用户ID
    self.idLabel = [[UILabel alloc] init];
    self.idLabel.font = [UIFont systemFontOfSize:13.0];
    [self.informationV addSubview:self.idLabel];
    self.idLabel.text = [NSString stringWithFormat:@"ID:%d",123456789];
    
    [self.idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(90, 25));
        make.top.equalTo(self.informationV.mas_top).with.mas_equalTo(@(-7));
        make.left.equalTo(self.informationV.mas_left).with.mas_equalTo(@(20));
        make.bottom.equalTo(self.headImage.mas_bottom).with.mas_equalTo(@(25));
    }];

    //欢迎光临
    self.welcomLbl = [[UILabel alloc] init];
    [self.informationV addSubview:self.welcomLbl];
    self.welcomLbl.font = [UIFont systemFontOfSize:12.0];
    self.welcomLbl.textColor = [UIColor whiteColor];
    self.welcomLbl.text = @"欢迎光临!";
    [self.informationV addSubview:self.welcomLbl];
    [self.welcomLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 10));
        make.top.equalTo(self.informationV.mas_top).with.mas_equalTo(@(25));
        make.bottom.equalTo(self.informationV.mas_bottom).with.mas_equalTo(@(10));
        make.centerY.equalTo(self.informationV.mas_centerY);
        make.left.equalTo(self.informationV.mas_left).with.mas_equalTo(@(30));
        make.right.equalTo(self.informationV.mas_right).with.mas_equalTo(@(30));
    }];

    //当前福利
    self.welcomLbl = [[UILabel alloc] init];
    [self.informationV addSubview:self.welcomLbl];
    self.welcomLbl.text = @"当前福利";
    self.welcomLbl.font = [UIFont systemFontOfSize:14.0];
    self.welcomLbl.textColor = [UIColor whiteColor];
    
    [self.welcomLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.informationV.mas_left).with.mas_equalTo(@(8));
        make.right.equalTo(self.informationV.mas_right).with.mas_equalTo(@(90));
        make.top.equalTo(self.informationV.mas_top).with.mas_equalTo(@(80));
        make.bottom.equalTo(self.informationV.mas_bottom).with.mas_equalTo(@(3));
    }];

    //福利数额
    self.amountLBL = [[UILabel alloc] init];
    [self.informationV addSubview:self.amountLBL];
    self.amountLBL.font = [UIFont systemFontOfSize:14.0];
    self.amountLBL.text = [NSString stringWithFormat:@"%d G",1000000000];
    self.amountLBL.textColor = [UIColor redColor];
    [self.amountLBL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.informationV.mas_left).with.mas_equalTo(@(65));
        make.right.equalTo(self.informationV.mas_right).with.mas_equalTo(@(-9));
        make.top.equalTo(self.informationV.mas_top).with.mas_equalTo(@(30));
        make.bottom.equalTo(self.informationV.mas_bottom).with.mas_equalTo(@(5));
    }];
}

//创建用户记录视图
- (void)createRecordV
{
    self.recordV = [[UIView alloc] init];
    [self.backgroundV addSubview:self.recordV];
    [self.recordV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.informationV.mas_bottom);
        make.bottom.equalTo(self.backgroundV.mas_bottom);
        make.width.mas_equalTo(@(100));
        make.right.equalTo(self.backgroundV.mas_right);
        make.centerY.equalTo(self.informationV.mas_centerY);
    }];

    NSArray *titleArr = [NSArray arrayWithObjects:@"福利记录",@"牌局记录",@"安全中心",@"联系客服", nil];
    
    int count = 4;
    int padding = 4;
    for (int i = 0; i < count; i++) {
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:[titleArr objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self.recordV addSubview:btn];
    
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(55, 25));
            make.centerY.equalTo(self.recordV.mas_centerY);
            make.height.mas_equalTo(@(25 + padding * i));
        }];
    }

    self.backBtn = [[UIButton alloc] init];
    [self.recordV addSubview:self.backBtn];
    [self.backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
    self.backBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.recordV.mas_top).with.mas_equalTo(@(120));
        make.centerY.equalTo(self.recordV.mas_centerY);
    }];
}

//弹出视图
- (void)popView
{
    if ([self.backBtn.titleLabel.text isEqualToString:@"福利记录"]) {
        [UIView animateWithDuration:2.0 animations:^{

            self.welfareV = [[UIView alloc] init];
            [self.backgroundV addSubview:self.welfareV];
            [self.welfareV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.backgroundV.mas_top).with.mas_equalTo(@(10));
                make.bottom.equalTo(self.backgroundV.mas_bottom).with.mas_equalTo(@(-10));
                make.left.equalTo(self.backgroundV.mas_left).with.mas_equalTo(@(30));
                make.right.equalTo(self.backgroundV.mas_right).with.mas_equalTo(@(-30));
            }];
        }];
    
        self.closeBtn = [[UIButton alloc] init];
        [self.backgroundV addSubview:self.closeBtn];
        [self.closeBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.top.equalTo(self.backgroundV.mas_top).with.mas_equalTo(@(8));
            make.right.equalTo(self.backgroundV.mas_right).with.mas_equalTo(@(50));
            make.left.equalTo(self.backgroundV.mas_left).with.mas_equalTo(@(200));
            make.bottom.equalTo(self.backgroundV.mas_bottom).with.mas_equalTo(@(-280));
        }];
    }
}

- (void)closeView
{
    NSLog(@"关闭视图");
    
    [UIView animateWithDuration:1.0 animations:^{
        [self.welfareV removeFromSuperview];
        [self.closeBtn removeFromSuperview];
    }];
}


@end
