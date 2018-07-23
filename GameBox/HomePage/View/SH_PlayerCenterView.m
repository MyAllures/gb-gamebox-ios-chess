//
//  SH_PlayerCenterView.m
//  GameBox
//
//  Created by egan on 2018/7/9.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_PlayerCenterView.h"
#import "Masonry.h"
#import "UIImage+SH_WebPImage.h"

@interface SH_PlayerCenterView ()
//用户信息视图
@property (nonatomic, strong) UIImageView *informationV;
//用户记录视图
@property (nonatomic, strong) UIImageView *recordV;
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
////福利视图窗口
//@property (nonatomic, strong) UIView *welfareV;
//关闭窗口按钮
//@property (nonatomic, strong) UIButton *closeBtn;
//按钮
@property (nonatomic, strong) UIButton *btn;
//按钮标题
@property (nonatomic, strong) NSArray *titleArr;
@end

@implementation SH_PlayerCenterView

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self createInformationV];
        [self createRecordV];
    }
    return self;
}

- (void)createInformationV
{
    //用户信息视图
    self.informationV = [[UIImageView alloc] init];
    self.informationV.image = [UIImage imageNamed:@"top-bg"];
    self.informationV.userInteractionEnabled = YES;
    [self addSubview:self.informationV];
    
    [self.informationV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(95);
        make.right.mas_equalTo(0);
    }];
    
    //用户头像
    self.headImage = [[UIImageView alloc] init];
    self.headImage.image = [UIImage imageWithWebPImageName:@"avatar"];
    self.headImage.contentMode = UIViewContentModeCenter;
    [self.informationV addSubview:self.headImage];
    
    
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.equalTo(self.mas_top).with.mas_equalTo(10);
        make.bottom.mas_equalTo(-500);
        make.right.equalTo(self.informationV.mas_left).with.offset(50);
    }];


    //用户ID
    self.idLabel = [[UILabel alloc] init];
    self.idLabel.font = [UIFont systemFontOfSize:13.0];
    [self.informationV addSubview:self.idLabel];
    self.idLabel.text = [NSString stringWithFormat:@"ID:%d",123456789];
    self.idLabel.textColor = [UIColor yellowColor];
    
    [self.idLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(180, 9));
        make.top.equalTo(self.informationV.mas_top).with.offset(10);
        make.left.equalTo(self.informationV.mas_left).with.offset(60);
        make.bottom.equalTo(self.informationV.mas_bottom).with.offset(-55);
    }];


    //欢迎光临
    self.welcomLbl = [[UILabel alloc] init];
    [self.informationV addSubview:self.welcomLbl];
    self.welcomLbl.font = [UIFont systemFontOfSize:10.0];
    self.welcomLbl.textColor = [UIColor whiteColor];
    self.welcomLbl.text = @"欢迎光临!";
    
    [self.welcomLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.informationV.mas_top).with.offset(58);
        make.left.equalTo(self.informationV.mas_left).with.offset(75);

    }];

    //当前福利
    self.welcomLbl = [[UILabel alloc] init];
    [self.informationV addSubview:self.welcomLbl];
    self.welcomLbl.text = @"当前福利:";
    self.welcomLbl.font = [UIFont systemFontOfSize:12.0];
    self.welcomLbl.textColor = [UIColor whiteColor];
    
    [self.welcomLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.informationV.mas_top).with.offset(72);
        make.left.equalTo(self.informationV.mas_left).with.offset(10);
    }];

    
    //福利数额
    self.amountLBL = [[UILabel alloc] init];
    [self.informationV addSubview:self.amountLBL];
    self.amountLBL.font = [UIFont systemFontOfSize:11.0];
    self.amountLBL.text = [NSString stringWithFormat:@"%d G",1000000000];
    self.amountLBL.textColor = [UIColor yellowColor];
    
    [self.amountLBL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.informationV.mas_left).with.offset(70);
        make.top.equalTo(self.informationV.mas_top).with.offset(73);
    }];

}

//创建用户记录视图
- (void)createRecordV
{
    self.recordV = [[UIImageView alloc] init];
    self.recordV.image = [UIImage imageNamed:@"menu-bg"];
    self.recordV.userInteractionEnabled = YES;
    [self addSubview:self.recordV];
    
    [self.recordV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.informationV.mas_bottom).with.offset(0);
        make.bottom.equalTo(self.mas_bottom);
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];


    self.titleArr = [NSArray arrayWithObjects:@"福利记录",@"牌局记录",@"安全中心",@"联系客服", nil];

    int count = 4;
    
    NSMutableArray * btnArray = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        self.btn = [[UIButton alloc] init];
        [self.btn setTitle:[self.titleArr objectAtIndex:i] forState:UIControlStateNormal];
        [self.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btn setBackgroundImage:[UIImage imageNamed:@"login_button"] forState:UIControlStateNormal];
        [self.btn addTarget:self action:@selector(playerBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [self.recordV addSubview:self.btn];
        [btnArray addObject:self.btn];
        
        [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                 make.top.equalTo(self.recordV.mas_top).with.offset(12);
            } else {
                 UIButton *button = btnArray[i-1];
                 make.top.equalTo(button.mas_bottom).with.offset(12);
            }
           
            make.left.equalTo(self.recordV.mas_left).with.offset(35);
            make.height.mas_equalTo(40);
        }];

    }

    self.backBtn = [[UIButton alloc] init];
    [self.recordV addSubview:self.backBtn];
    [self.backBtn addTarget:self action:@selector(pressBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.backBtn setBackgroundImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 40));
        make.top.equalTo(self.recordV.mas_top).with.mas_equalTo(220);
        make.left.equalTo(self.recordV.mas_left).with.offset(50);
    }];

}

//返回视图
- (void)pressBackBtn
{
    if ([self.delegate respondsToSelector:@selector(removeView)]) {
        [self.delegate removeView];
    }
}

- (void)playerBtn:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(popView:)]) {
        [self.delegate popView:btn];
    }
}

@end
