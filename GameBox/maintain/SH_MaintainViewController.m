//
//  SH_MaintainViewController.m
//  GameBox
//
//  Created by sam on 2018/8/26.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_MaintainViewController.h"
#import "SH_CustomerServiceManager.h"

@interface SH_MaintainViewController ()
@end

@implementation SH_MaintainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}
- (IBAction)contactServiceBtnClick:(id)sender {
     [[SH_CustomerServiceManager sharedManager] open];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 1;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    SH_MaintainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SH_MaintainTableViewCell"];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.gotoCustomer = ^{
//        [[SH_CustomerServiceManager sharedManager] open];
//    };
//    if (!cell) {
//        cell = [[NSBundle mainBundle] loadNibNamed:@"SH_MaintainTableViewCell" owner:nil options:nil].lastObject;
//    }
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 375;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
