//
//  SH_RechargeDetailViewController.m
//  GameBox
//
//  Created by jun on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_RechargeDetailViewController.h"
#import "SH_RechargeDetailMainView.h"
#import "SH_NetWorkService+RechargeCenter.h"
#import "SH_PreferentialPopView.h"
#import "SH_BitCoinSuccessView.h"
@interface SH_RechargeDetailViewController ()<SH_RechargeDetailMainViewDelegate,SH_PreferentialPopViewDelegate>
@property(nonatomic,copy)NSString *realName;
@property(nonatomic,copy)NSString *accountNum;
@property(nonatomic,copy)NSString *orderNum;
@end

@implementation SH_RechargeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configNavigationWithTitle:[NSString stringWithFormat:@"%@付款",self.platformModel.name]];
    [self configUI];
}
-(void)configUI{

    SH_RechargeDetailMainView *detailMainView = [[SH_RechargeDetailMainView alloc]init];
    detailMainView.delegate = self;
    [self.bgScrollView addSubview:detailMainView];
    [detailMainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.bgScrollView);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    [detailMainView updateWithChannelModel:self.channelModel PaywayModel:self.paywayModel PlatformModel:self.platformModel];
}
#pragma mark--
#pragma mark-- 提交按钮
- (void)SH_RechargeDetailMainViewSubmitRealName:(NSString *)realName AccountNum:(NSString *)accountNum OrderNum:(NSString *)orderNum{
    self.realName = realName;
    self.accountNum = accountNum;
    self.orderNum = orderNum;
     
    //请求优惠
    [SH_NetWorkService getNormalDepositeNum:self.money Payway:self.channelModel.depositWay PayAccountId:self.channelModel.searchId Complete:^(SH_BitCoinSaleModel *model) {
        SH_PreferentialPopView *popView = [[SH_PreferentialPopView alloc]initWithFrame:CGRectMake(0, 0, screenSize().width, screenSize().height)];
        popView.delegate  =  self;
        [popView popViewShow];
        [popView updateUIWithSaleModel:model Money:self.money];
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];

}
#pragma mark--
#pragma mark--popView 代理
- (void)popViewSelectedActivityId:(NSString *)activityId{
    [SH_NetWorkService normalPayDepositWithRechargeAmount:self.money RechargeType:self.channelModel.rechargeType Account:self.channelModel.searchId BankOrder:self.orderNum PayerName:self.realName PayerBankcard:self.accountNum ActivityId:activityId Complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if ([[response objectForKey:@"data"] isKindOfClass:[NSNull class]]) {
            showMessage(self.view, [NSString stringWithFormat:@"%@",response[@"message"]], nil);
        }else{
            SH_BitCoinSuccessView *popView = [[SH_BitCoinSuccessView alloc]initWithFrame:CGRectMake(0, 0, screenSize().width, screenSize().height)];
            [popView popViewShow];
        }
        
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
