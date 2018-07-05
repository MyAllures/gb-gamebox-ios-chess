//
//  LineCheckViewController.m
//  GameBox
//
//  Created by shin on 2018/7/4.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "LineCheckViewController.h"
#import "SH_NetWorkService+LineCheck.h"
#import "SH_HomeViewController.h"
#import "NetWorkLineMangaer.h"

@interface LineCheckViewController ()
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *statusLB;
@property (weak, nonatomic) IBOutlet UIView *progressMarkView;
@property (weak, nonatomic) IBOutlet UILabel *progressNumLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressMarkLeading;

@property (nonatomic, assign) CGFloat progress;//线路检测进度
@property (nonatomic, strong) NSString *lineCheckStatus;//线路检测提示语

@end

@implementation LineCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //第一步
    __weak typeof(self) weakSelf = self;

    NSLog(@"第一步：从DNS获取bossAPI");
    [SH_NetWorkService fetchBossAPIFromDNSGroup:^(NSString *dns, BOOL success) {
        NSLog(@">>>%@检测结果:%i",dns,success);
        weakSelf.progress += 0.1;
        weakSelf.lineCheckStatus = @"正在匹配服务器，请稍后...";
    } complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSLog(@"检测完毕:%@",response);
        //第二步
        NSLog(@"第二步：从bossAPI获取IPS");
        NSString *host = [response objectForKey:@"host"];
        NSArray *ips = [response objectForKey:@"ips"];
        NSMutableArray *bossApiArr = [NSMutableArray array];
        for (NSString *bossApi in ips) {
            NSString *url = [NSString stringWithFormat:@"https://%@:1344/boss-api",bossApi];
            [bossApiArr addObject:url];
        }

        [SH_NetWorkService fetchIPSFromBossAPIGroup:bossApiArr host:host oneTurn:^(NSString *bossapi, BOOL success) {
            NSLog(@">>>%@检测结果:%i",bossapi,success);
            weakSelf.progress += 0.1;
            weakSelf.lineCheckStatus = @"正在匹配服务器，请稍后...";
        } complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
            NSLog(@"检测完毕:%@",response);
            
            NSLog(@"第三步：check-ip");
            NSString *host = [response objectForKey:@"domain"];
            NSArray *ips = [response objectForKey:@"ips"];
            [SH_NetWorkService checkIPFromIPGroup:ips host:host oneTurn:^(NSString *ip, NSString *checkType, BOOL success) {
                NSLog(@"check ip:%@ type:%@ success:%i",ip, checkType, success);
                if (success) {
                    static dispatch_once_t onceToken;
                    dispatch_once(&onceToken, ^{
                        weakSelf.progress = 1.0;
                        weakSelf.lineCheckStatus = @"匹配服务器完成，即将进入...";
                        //将数据存入单利
                        NSArray *checkTypeComp = [checkType componentsSeparatedByString:@"+"];
                        [NetWorkLineMangaer sharedManager].currentHost = host;
                        [NetWorkLineMangaer sharedManager].currentIP = ip;
                        [NetWorkLineMangaer sharedManager].currentHttpType = checkTypeComp[0];
                        [NetWorkLineMangaer sharedManager].currentPort = checkTypeComp.count == 2 ? checkTypeComp[1] : @"";
                        [NetWorkLineMangaer sharedManager].currentPreUrl = [NSString stringWithFormat:@"%@://%@%@",[NetWorkLineMangaer sharedManager].currentHttpType,[NetWorkLineMangaer sharedManager].currentIP,[[NetWorkLineMangaer sharedManager].currentPort isEqualToString:@""] ? @"" : [NSString stringWithFormat:@":%@",[NetWorkLineMangaer sharedManager].currentPort]];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            SH_HomeViewController *homeVC =[[SH_HomeViewController alloc] initWithNibName:@"SH_HomeViewController" bundle:nil];
                            [weakSelf.navigationController pushViewController:homeVC animated:NO];
                        });
                    });
                }
                else
                {
                    weakSelf.progress = (weakSelf.progress+0.05)>1.0 ? 1.0 : weakSelf.progress+0.05;
                    weakSelf.lineCheckStatus = weakSelf.progress == 1.0 ? @"匹配服务器完成，即将进入..." : @"正在匹配服务器，请稍后...";
                }
            }  failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
                NSLog(@"%@",err);
            }];
        } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
            NSLog(@"检测失败:%@",err);
        }];
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        NSLog(@"检测失败:%@",err);
    }];
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    self.progressView.progress = _progress;
    self.progressNumLB.text = [NSString stringWithFormat:@"%.0f%%",_progress*100];
    self.progressMarkLeading.constant = -34+_progress*277;
}

- (void)setLineCheckStatus:(NSString *)lineCheckStatus
{
    _lineCheckStatus = lineCheckStatus;
    self.statusLB.text = _lineCheckStatus;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
