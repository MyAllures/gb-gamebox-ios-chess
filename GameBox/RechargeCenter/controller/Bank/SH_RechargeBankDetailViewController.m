//
//  SH_RechargeBankDetailViewController.m
//  GameBox
//
//  Created by jun on 2018/7/11.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_RechargeBankDetailViewController.h"
#import "SH_RechargeBankDetailView.h"
@interface SH_RechargeBankDetailViewController ()

@end

@implementation SH_RechargeBankDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configNavigationWithTitle:@"柜台机付款"];
    [self configUI];
}
-(void)configUI{
    SH_RechargeBankDetailView *detailMainView = [[SH_RechargeBankDetailView alloc]init];
    [self.bgScrollView addSubview:detailMainView];
    [detailMainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.bgScrollView);
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
