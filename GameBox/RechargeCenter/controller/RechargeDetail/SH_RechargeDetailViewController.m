//
//  SH_RechargeDetailViewController.m
//  GameBox
//
//  Created by jun on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_RechargeDetailViewController.h"
#import "SH_RechargeDetailMainView.h"
@interface SH_RechargeDetailViewController ()

@end

@implementation SH_RechargeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configNavigationWithTitle:@"QQ钱包付款"];
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
    SH_RechargeDetailMainView *detailMainView = [[SH_RechargeDetailMainView alloc]init];
    [bgScrollView addSubview:detailMainView];
    [detailMainView mas_makeConstraints:^(MASConstraintMaker *make) {
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
