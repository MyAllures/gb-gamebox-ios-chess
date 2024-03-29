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
#import "IPsCacheManager.h"
#import "SH_WebPImageView.h"
#import "UIImage+SH_WebPImage.h"
#import "SH_LineCheckErrManager.h"

@interface LineCheckViewController ()
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *statusLB;
@property (weak, nonatomic) IBOutlet UIView *progressMarkView;
@property (weak, nonatomic) IBOutlet UILabel *progressNumLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressMarkLeading;
@property (weak, nonatomic) IBOutlet UIImageView *animationStartImg;
@property (weak, nonatomic) IBOutlet SH_WebPImageView *animationProgressImg;
@property (weak, nonatomic) IBOutlet UIView *checkLineErrView;

@property (nonatomic, assign) CGFloat progress;//线路检测进度
@property (nonatomic, strong) NSString *lineCheckStatus;//线路检测提示语
@property (strong, nonatomic) NSString *currentErrCode;//线路检测错误代码

@end

@implementation LineCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self starsAnimation];
    [self progressAnimation];
    [self doLineCheck];
}

- (void)doLineCheck
{
    __weak typeof(self) weakSelf = self;
    self.progress = 0.05;//默认给个5%的进度
    //先检查缓存的ips是否还有效
    BOOL isIPsValid = [[IPsCacheManager sharedManager] isIPsValid];
    if (isIPsValid) {
        //有效直接check
        NSDictionary *cacheIPSInfo = [[IPsCacheManager sharedManager] ips];
        NSDictionary *ips = [cacheIPSInfo objectForKey:@"ips"];
        [self checkIPS:ips complete:^(NSDictionary *ips) {
            [weakSelf enterHomePage];
        } failed:^{
            NSLog(@"全部ip check失败");
            weakSelf.progress = 0;
            weakSelf.currentErrCode = @"003";
        }];
    }
    else
    {
        NSLog(@"sid == %@",SID);
        if ([SID isEqualToString:@"21"] || [SID isEqualToString:@"18"]) {
            [SH_NetWorkService fetchIPSFromBossAPIGroup:@[@"http://boss.ampinplayopt0matrix.com/boss-api"] host:@"" oneTurn:^(NSString *bossapi, BOOL success) {
                NSLog(@">>>%@检测结果:%i",bossapi,success);
                weakSelf.progress += 0.1;
                weakSelf.lineCheckStatus = @"正在匹配服务器，请稍后...";
            } complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
                NSLog(@"检测完毕:%@",response);
                
                NSLog(@"第三步：check-ip");
                [weakSelf checkIPS:response complete:^(NSDictionary *ips) {
                    //check成功 更新缓存
                    [[IPsCacheManager sharedManager] updateIPsList:ips];
                    [weakSelf enterHomePage];
                } failed:^{
                    NSLog(@"全部ip check失败");
                    weakSelf.progress = 0;
                    weakSelf.currentErrCode = @"003";
                }];
            } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
                NSLog(@"从bossAPI获取IPS失败:%@",err);
                weakSelf.progress = 0;
                weakSelf.currentErrCode = @"002";
            }];
        }
        else
        {
            //第一步
            NSLog(@"第一步：从DNS获取bossAPI");
            [SH_NetWorkService fetchBossAPIFromDNSGroup:^(NSString *dns, BOOL success) {
                NSLog(@">>>%@检测结果:%i",dns,success);
                weakSelf.progress += 0.1;
                weakSelf.lineCheckStatus = @"正在匹配服务器，请稍后...";
            } complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
                NSLog(@"检测完毕:%@",response);
                //缓存boss-api
                [[IPsCacheManager sharedManager] updateBossApiList:response];
                
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
                    [weakSelf checkIPS:response complete:^(NSDictionary *ips) {
                        //check成功 更新缓存
                        [[IPsCacheManager sharedManager] updateIPsList:ips];
                        [weakSelf enterHomePage];
                    } failed:^{
                        NSLog(@"全部ip check失败");
                        weakSelf.progress = 0;
                        weakSelf.currentErrCode = @"003";
                    }];
                } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
                    NSLog(@"从bossAPI获取IPS失败:%@",err);
                    weakSelf.progress = 0;
                    weakSelf.currentErrCode = @"002";
                }];
            } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
                NSLog(@"DNS检测失败:%@",err);
                weakSelf.progress = 0;
                weakSelf.currentErrCode = @"001";
            }];
        }
    }
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    self.progressView.progress = _progress;
    self.progressNumLB.text = [NSString stringWithFormat:@"%.0f%%",_progress*100];
    self.progressMarkLeading.constant = -34+_progress*277;
    
    self.statusLB.hidden = _progress == 0;
    self.checkLineErrView.hidden = _progress != 0;
}

- (void)setLineCheckStatus:(NSString *)lineCheckStatus
{
    _lineCheckStatus = lineCheckStatus;
    self.statusLB.text = _lineCheckStatus;
}

- (void)checkIPS:(NSDictionary *)ipsInfo complete:(SHCheckIPSSuccess)complete failed:(SHCheckIPSFailed)failed
{
    __weak typeof(self) weakSelf = self;

    NSArray *ips = [ipsInfo objectForKey:@"ips"];
    NSString *host = [ipsInfo objectForKey:@"domain"];
    __block int totalCheckTimes = 0;//总的check次数 用于观察是否全部ip、全部类型都check完毕
    
    [SH_NetWorkService checkIPFromIPGroup:ips host:host oneTurn:^(NSHTTPURLResponse *httpURLResponse, NSString *err, NSString *ip, NSString *checkType, BOOL success) {
        NSLog(@"check ip:%@ type:%@ success:%i",ip, checkType, success);
        totalCheckTimes++;
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
                
                if (complete) {
                    complete(ipsInfo);
                }
            });
        }
        else
        {
            weakSelf.progress = (weakSelf.progress+0.05)>1.0 ? 1.0 : weakSelf.progress+0.05;
            weakSelf.lineCheckStatus = weakSelf.progress == 1.0 ? @"匹配服务器完成，即将进入..." : @"正在匹配服务器，请稍后...";
            //收集错误信息
            [[SH_LineCheckErrManager sharedManager] collectErrInfo:@{RH_SP_COLLECTAPPERROR_DOMAIN:host,RH_SP_COLLECTAPPERROR_CODE:@([httpURLResponse statusCode]),RH_SP_COLLECTAPPERROR_ERRORMESSAGE:err}];
        }
        if (totalCheckTimes == ips.count*4) {
            //所有ip 所有类型都check完毕了
            //发送check错误信息
            NSLog(@"ips check完毕");
            [[SH_LineCheckErrManager sharedManager] send];
        }
    }  failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        NSLog(@"%@",err);
        //全部ip-check失败
        //清空IPS缓存
        [[IPsCacheManager sharedManager] clearCaches];
        if (failed) {
            failed();
        }
    }];
}

- (void)starsAnimation
{
    NSArray *images=[NSArray arrayWithObjects:[UIImage imageWithWebPImageName:@"effects_star"],[UIImage imageWithWebPImageName:@"effects_star2"],[UIImage imageWithWebPImageName:@"effects_star3"], nil];
    self.animationStartImg.animationImages = images;
    self.animationStartImg.contentMode = UIViewContentModeScaleAspectFit;
    self.animationStartImg.animationDuration = 0.9;
    self.animationStartImg.animationRepeatCount = 0;
    [self.animationStartImg startAnimating];
}

- (void)progressAnimation
{
    NSArray *images=[NSArray arrayWithObjects:[UIImage imageWithWebPImageName:@"loading_eaIcon"],[UIImage imageWithWebPImageName:@"loading_eaIcon2"],[UIImage imageWithWebPImageName:@"loading_eaIcon3"], nil];
    self.animationProgressImg.animationImages = images;
    self.animationProgressImg.contentMode = UIViewContentModeScaleAspectFit;
    self.animationProgressImg.animationDuration = 0.5;
    self.animationProgressImg.animationRepeatCount = 0;
    [self.animationProgressImg startAnimating];
}

- (void)enterHomePage
{
    //每五分钟从boss-api获取一些ips 并check
    //从而更新线路
    [NSTimer scheduledTimerWithTimeInterval:5*60 target:self selector:@selector(refreshLineCheck) userInfo:nil repeats:YES];
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        SH_HomeViewController *homeVC =[[SH_HomeViewController alloc] initWithNibName:@"SH_HomeViewController" bundle:nil];
        weakSelf.rootNav = [[UINavigationController alloc] initWithRootViewController:homeVC];
        weakSelf.rootNav.navigationBarHidden = YES;
        [weakSelf presentViewController:weakSelf.rootNav animated:NO completion:nil];
    });
}


- (void)refreshLineCheck
{
    __weak typeof(self) weakSelf = self;

    //从缓存读取bossApi
    NSDictionary *bossApiCache = [[IPsCacheManager sharedManager] bossApis];
    NSLog(@"refreshLineCheck：从bossAPI获取IPS");
    NSString *host = [bossApiCache objectForKey:@"host"];
    NSArray *ips = [bossApiCache objectForKey:@"ips"];
    NSMutableArray *bossApiArr = [NSMutableArray array];
    for (NSString *bossApi in ips) {
        NSString *url = [NSString stringWithFormat:@"https://%@:1344/boss-api",bossApi];
        [bossApiArr addObject:url];
    }
    
    //
    //区分测试站
    //
    if ([SID isEqualToString:@"18"] || [SID isEqualToString:@"21"]) {
        bossApiArr = [NSMutableArray arrayWithObject:@"http://boss-api-test.gbboss.com/boss-api"];
        host = @"";
    }
    
    [SH_NetWorkService fetchIPSFromBossAPIGroup:bossApiArr host:host oneTurn:^(NSString *bossapi, BOOL success) {
        //
    } complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        [weakSelf checkIPS:response complete:^(NSDictionary *ips) {
            //check成功 更新缓存
            [[IPsCacheManager sharedManager] updateIPsList:ips];
        } failed:^{
            //
        }];
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        //
    }];
}

- (void)showErrAlertWithErrCode:(NSString *)code otherInfo:(NSDictionary *)otherInfo
{
    NSString *appVersion = GB_CURRENT_APPVERSION;
    NSString *appBuildVersion = GB_CURRENT_APPBUILD;

    NSString *ip = [self localIPAddress];
    NSString *title;
    NSString *msg ;
    if ([code isEqualToString:@"001"]) {
        title = @"网络连接失败";
        msg = [NSString stringWithFormat:@"\n网络连接失败，请确认您的网络连接正常后再次尝试！"];
    } else if ([code isEqualToString:@"002"]) {
        title = @"线路获取失败";
        msg = [NSString stringWithFormat:@"\n线路获取失败，请确认您的网络连接正常后再次尝试！"];
    } else if ([code isEqualToString:@"003"]) {
        title = @"服务器连接失败";
        msg = [NSString stringWithFormat:@"\n出现未知错误，请联系在线客服并提供以下信息:\n\n当前ip:%@\n版本号:%@", ip, [NSString stringWithFormat:@"iOS %@.%@",appVersion,appBuildVersion]];
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableAttributedString *messageText = [[NSMutableAttributedString alloc] initWithString:msg];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    [messageText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, msg.length)];
    [alert setValue:messageText forKey:@"attributedMessage"];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

//获取设备IP地址
- (NSString *)localIPAddress
{
    NSError *error;
    NSURL *ipURL = [NSURL URLWithString:@"http://pv.sohu.com/cityjson?ie=utf-8"];
    NSMutableString *ip = [NSMutableString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
    //判断返回字符串是否为所需数据
    if ([ip hasPrefix:@"var returnCitySN = "]) {
        //对字符串进行处理，然后进行json解析
        //删除字符串多余字符串
        NSRange range = NSMakeRange(0, 19);
        [ip deleteCharactersInRange:range];
        NSString * nowIp =[ip substringToIndex:ip.length-1];
        //将字符串转换成二进制进行Json解析
        NSData * data = [nowIp dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        return dict[@"cip"] ? dict[@"cip"] : @"";
    }
    return @"";
}

- (IBAction)errDetailAction:(id)sender {
    [self showErrAlertWithErrCode:self.currentErrCode otherInfo:nil];
}

- (IBAction)doItAgainAction:(id)sender {
    self.checkLineErrView.hidden = YES;
    [self doLineCheck];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
