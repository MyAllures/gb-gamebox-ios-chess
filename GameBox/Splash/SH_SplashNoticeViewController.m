//
//  SH_SplashNoticeViewController.m
//  GameBox
//
//  Created by shin on 2018/7/26.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_SplashNoticeViewController.h"
#import "LineCheckViewController.h"

@interface SH_SplashNoticeViewController ()

@end

@implementation SH_SplashNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LineCheckViewController *lineCheckViewController = [mainSB instantiateViewControllerWithIdentifier:@"LineCheckViewController"];
        [self presentViewController:lineCheckViewController animated:NO completion:nil];
    });
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
