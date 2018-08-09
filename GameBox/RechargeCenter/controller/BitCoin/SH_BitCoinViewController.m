//
//  SH_BitCoinViewController.m
//  GameBox
//
//  Created by jun on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_BitCoinViewController.h"
#import "SH_BitCoinView.h"
#import "SH_NetWorkService+BitCoin.h"
#import "SH_PreferentialPopView.h"
#import "SH_BitCoinSuccessView.h"
@interface SH_BitCoinViewController ()<SH_BitCoinViewDelegate,SH_PreferentialPopViewDelegate>
@property(nonatomic,copy)NSString *num;//比特币数量
@property(nonatomic,copy)NSString *date;//交易时间
@property(nonatomic,copy)NSString *address;//比特币地址
@property(nonatomic,copy)NSString *txid;
@end

@implementation SH_BitCoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavigationWithTitle:@"比特币支付"];
    [self configUI];
}
-(void)configUI{
    SH_BitCoinView *bitCoinView = [[SH_BitCoinView alloc]init];
    bitCoinView.delegate = self;
    [self.bgScrollView addSubview:bitCoinView];
    [bitCoinView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.left.bottom.right.equalTo(self.bgScrollView);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    [bitCoinView updateUIWithChannelModel:self.channelModel];
    
}
#pragma mark--
#pragma mark--bitCoinView代理
- (void)SH_BitCoinViewAdress:(NSString *)address Txid:(NSString *)txid BitCoinNum:(NSString *)num date:(NSString *)date{
    self.address = address;
    self.txid = txid;
    self.num = num;
    self.date = date;
    //输入的地址 txid等
    //请求优惠接口
    [SH_NetWorkService getSaleWithCoinNum:num Payway:self.channelModel.depositWay Txid:txid PayAccountId:self.channelModel.searchId Complete:^(SH_BitCoinSaleModel *model) {
        SH_PreferentialPopView *popView = [[SH_PreferentialPopView alloc]initWithFrame:CGRectMake(0, 0, screenSize().width, screenSize().height)];
        popView.delegate  =  self;
        [popView popViewShow];
        [popView updateUIWithSaleModel:model Money:@""];
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
}
#pragma mark--
#pragma mark-- popView马上付款按钮
- (void)popViewSelectedActivityId:(NSString *)activityId{
    [SH_NetWorkService bitCoinPayWithRechargeType:self.channelModel.rechargeType PayAccountId:self.channelModel.searchId ActivityId:activityId ReturnTime:self.date Adrress:self.address BitCoinNum:self.num Txid:self.txid Complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
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
