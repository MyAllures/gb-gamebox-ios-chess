//
//  SH_BitCoinViewController.m
//  GameBox
//
//  Created by jun on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_BitCoinViewController.h"
#import "SH_BitCoinView.h"

@interface SH_BitCoinViewController ()

@end

@implementation SH_BitCoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavigationWithTitle:@"比特币支付"];
    [self configUI];
}
-(void)configUI{
    UIScrollView *bgScrollView = [[UIScrollView alloc]init];
    bgScrollView.contentSize = CGSizeZero;
    [self.view addSubview:bgScrollView];
    [bgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(NavigationBarHeight);
    }];
    SH_BitCoinView *bitCoinView = [[SH_BitCoinView alloc]init];
    [bgScrollView addSubview:bitCoinView];
    bitCoinView.targetVC = self;
    [bitCoinView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.left.bottom.right.equalTo(bgScrollView);
        make.width.mas_equalTo(SCREEN_WIDTH);
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
