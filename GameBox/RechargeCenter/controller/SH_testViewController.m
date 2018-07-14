//
//  SH_testViewController.m
//  GameBox
//
//  Created by jun on 2018/7/14.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_testViewController.h"

@interface SH_testViewController ()

@end

@implementation SH_testViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configNavigationWithTitle:@"测试"];
    [self configUI];
}
-(void)configUI{
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 200,500)];
    lab.numberOfLines = 0;
    lab.font = [UIFont systemFontOfSize:18];
    lab.backgroundColor = [UIColor greenColor];
    [self.view addSubview:lab];
    [lab setTextWithFirstString:@"如出现充值失败或充值后未到账等情况，请联系在线客服获取帮助。点击联系在线客服" SecondString:@"点击联系在线客服" FontSize:18 Color:[UIColor redColor]];
    [lab addAttributeTapActionWithStrings:@[@"点击联系在线客服"] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
        NSLog(@"点击了");
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
