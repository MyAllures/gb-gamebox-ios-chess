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
@property (weak, nonatomic) IBOutlet UILabel *siteMaintainTipLabel;
@property (weak, nonatomic) IBOutlet UIImageView *loginImg;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (strong, nonatomic) NSString *customerUrl;
@property (strong, nonatomic) NSString *siteMaintainTip;
@end

@implementation SH_MaintainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customerUrl = @"";
    [self.btn ButtonPositionStyle:ButtonPositionStyleDefault spacing:5];
    NSString *domain = [NSString stringWithFormat:@"%@://%@",[NetWorkLineMangaer sharedManager].currentHttpType,[NetWorkLineMangaer sharedManager].currentHost];
    NSString *urlStr = [domain stringByAppendingString:@"/__error_/608info.html"];
    NSLog(@"urlStr===%@",urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //3.获得会话对象
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSString *mobileCustomerServiceUrl = dict[@"mobileCustomerServiceUrl"];
            NSString *logoUrl = dict[@"logoUrl"];
            self.siteMaintainTip = dict[@"siteMaintainTip"];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.customerUrl = mobileCustomerServiceUrl;
                [self.loginImg sd_setImageWithURL:[NSURL URLWithString:logoUrl]];
            });
            NSLog(@"mobileCustomerServiceUrl==%@",mobileCustomerServiceUrl);
            NSLog(@"logoUrl==%@",logoUrl);
        } else {
            self.btn.hidden = YES;
        }
    }];
    //5.执行任务
    [dataTask resume];
}
- (IBAction)contactServiceBtnClick:(id)sender {
    if (![self.customerUrl isEqualToString:@""]) {
        self.siteMaintainTipLabel.text = self.siteMaintainTip;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.customerUrl]];
    }
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
