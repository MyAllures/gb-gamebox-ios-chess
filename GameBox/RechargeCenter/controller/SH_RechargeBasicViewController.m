//
//  SH_RechargeBasicViewController.m
//  GameBox
//
//  Created by jun on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_RechargeBasicViewController.h"
#import "SH_NavigationView.h"
@interface SH_RechargeBasicViewController ()<SH_NavigationViewDelegate>

@end
@implementation SH_RechargeBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
   
}

-(UIInterfaceOrientationMask)orientation{
    return UIInterfaceOrientationMaskPortrait;
}
- (void)configNavigationWithTitle:(NSString *)title{
    SH_NavigationView *navi = [[NSBundle mainBundle]loadNibNamed:@"SH_NavigationView" owner:self options:nil].firstObject;
    navi.delegate = self;
    [self.view addSubview:navi];
    [navi updateUIWithTitle:title];
    [navi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(NavigationBarHeight));
    }];
}
#pragma mark--
#pragma mark--navi back
-(void)SH_NavigationViewBackBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (UIScrollView *)bgScrollView{
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc]init];
        _bgScrollView.contentSize = CGSizeZero;
        [self.view addSubview:_bgScrollView];
        [_bgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.view);
            make.top.equalTo(self.view).offset(NavigationBarHeight);
        }];
    }
    return _bgScrollView;
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
