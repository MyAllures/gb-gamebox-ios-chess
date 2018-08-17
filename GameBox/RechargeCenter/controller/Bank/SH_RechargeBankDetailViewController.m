//
//  SH_RechargeBankDetailViewController.m
//  GameBox
//
//  Created by jun on 2018/7/11.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_RechargeBankDetailViewController.h"
#import "SH_RechargeBankDetailView.h"
#import "SH_NetWorkService+RechargeCenter.h"
#import "SH_NetWorkService+Bank.h"
#import "SH_PreferentialPopView.h"
#import "SH_BitCoinSuccessView.h"
@interface SH_RechargeBankDetailViewController ()<SH_RechargeBankDetailViewDelegate,SH_PreferentialPopViewDelegate>
@property(nonatomic,copy)NSString *depositeWay;
@property(nonatomic,copy)NSString *personName;
@property(nonatomic,copy)NSString *address;
@end

@implementation SH_RechargeBankDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configNavigationWithTitle:self.platformModel.name];
    [self configUI];
}
-(void)configUI{
    SH_RechargeBankDetailView *detailMainView = [[SH_RechargeBankDetailView alloc]init];
    detailMainView.delegate = self;
    [self.bgScrollView addSubview:detailMainView];
    [detailMainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.bgScrollView);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    [detailMainView updateWithChannelModel:self.channelModel PlatformModel:self.platformModel PaywayModel:self.paywayModel];
}
#pragma mark--
#pragma mark--提交事件
- (void)SH_RechargeBankDetailViewSubmitDepositeWay:(NSString *)depositeWay Person:(NSString *)person Address:(NSString *)address{
    self.depositeWay = depositeWay;
    self.personName = person;
    self.address = address;
    [SH_NetWorkService getNormalDepositeNum:self.money Payway:depositeWay PayAccountId:self.channelModel.searchId Complete:^(SH_BitCoinSaleModel *model) {
        SH_PreferentialPopView *popView = [[SH_PreferentialPopView alloc]initWithFrame:CGRectMake(0, 0, screenSize().width, screenSize().height)];
        popView.delegate  =  self;
        [popView popViewShow];
        [popView updateUIWithSaleModel:model Money:self.money];
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
}
#pragma mark--
#pragma mark-- popView马上付款按钮
- (void)popViewSelectedActivityId:(NSString *)activityId{
    [SH_NetWorkService bankDepositeyWithRechargeAmount:self.money rechargeType:self.depositeWay payAccountId:self.channelModel.searchId payerName:self.personName rechargeAddress:self.address activityId:activityId Complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if ([[response objectForKey:@"data"] isKindOfClass:[NSNull class]]) {
            showMessage(self.view, [NSString stringWithFormat:@"%@",response[@"message"]], nil);
        }else{
            SH_BitCoinSuccessView *popView = [[SH_BitCoinSuccessView alloc]initWithFrame:CGRectMake(0, 0, screenSize().width, screenSize().height)];
            [popView popViewShow];
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        showMessage(self.view, @"存款失败", nil);
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
