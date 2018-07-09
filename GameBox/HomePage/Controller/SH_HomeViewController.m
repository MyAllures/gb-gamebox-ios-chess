//
//  SH_HomeViewController.m
//  GameBox
//
//  Created by shin on 2018/7/4.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <Masonry/Masonry.h>
#import "SH_HomeViewController.h"
#import "SH_NetWorkService+Login.h"
#import "NetWorkLineMangaer.h"
#import "GameWebViewController.h"
#import "AppDelegate.h"
#import "SH_RechargeCenterViewController.h"
#import "View+MASAdditions.h"
#import "SH_CycleScrollView.h"
#import "SH_PromoViewController.h"
#import "LoginViewController.h"
#import "SH_PromoContentView.h"
#import "PopTool.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface SH_HomeViewController ()<SH_CycleScrollViewDataSource, SH_CycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;
@property (weak, nonatomic) IBOutlet UILabel *userAccountLB;
@property (strong, nonatomic) SH_CycleScrollView *cycleAdView;

@end

@implementation SH_HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self fetchSID];
    [self initAdScroll];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    [SH_NetWorkService login:@"Shin" psw:@"h123123" verfyCode:@"" complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSString *setCookie = [httpURLResponse.allHeaderFields objectForKey:@"Set-Cookie"];
        NSUInteger startLocation = [setCookie rangeOfString:@"GMT, "].location +4;
        NSUInteger endLocation = [setCookie rangeOfString:@" rememberMe=deleteMe"].location;
        NSUInteger lenth = endLocation - startLocation;
        NSString *cookie = [setCookie substringWithRange:NSMakeRange(startLocation, lenth)];
        [NetWorkLineMangaer sharedManager].currentCookie = cookie;
        
        [SH_NetWorkService fetchUserInfo:^(NSHTTPURLResponse *httpURLResponse, id response) {
            //
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            //
        }];
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        //
    }];
}

- (IBAction)enterGame:(id)sender {
    __weak typeof(self) weakSelf = self;
    
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/origin/getGameLink.html?apiId=10&apiTypeId=2&gameId=100303&gameCode=5902"];
    NSDictionary *header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost,@"Cookie":[NetWorkLineMangaer sharedManager].currentCookie};
    [SH_NetWorkService post:url parameter:nil header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSString *gameUrl = [[response objectForKey:@"data"] objectForKey:@"gameLink"];
        GameWebViewController *gameVC = [[GameWebViewController alloc] initWithNibName:@"GameWebViewController" bundle:nil];
        gameVC.url = gameUrl;
        [weakSelf presentViewController:gameVC animated:YES completion:nil];
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        //
    }];
}

- (IBAction)rechargeAction:(id)sender {
    //    SH_PromoView *promoView = [[SH_PromoView alloc]initWithFrame:CGRectZero];
    //    [[UIApplication sharedApplication].keyWindow addSubview:promoView];
    //    UIEdgeInsets padding = UIEdgeInsetsMake(10, 80, 20, 80);
    //    [promoView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.edges.equalTo(self.view).with.insets(padding);
    ////        make.top.equalTo(self.view.mas_top).with.offset(padding.top);
    ////        make.bottom.equalTo(self.view.mas_bottom).with.offset(-padding.bottom);
    ////        make.left.equalTo(self.view.mas_left).with.offset(padding.left);
    ////        make.right.equalTo(self.view.mas_right).with.offset(-padding.right);
    //    }];
}

/**
 * 获取SID
 */
- (void)fetchSID
{
    [SH_NetWorkService fetchHttpCookie:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSString *setCookie = [httpURLResponse.allHeaderFields objectForKey:@"Set-Cookie"];
        [NetWorkLineMangaer sharedManager].currentCookie = setCookie;
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        //
    }];
}

- (IBAction)avatarClick:(id)sender {
    [[LoginViewController new] show];
}

- (IBAction)rechargeClick:(id)sender {
    [self presentViewController:[[SH_RechargeCenterViewController alloc]init] animated:YES completion:nil];
}
#pragma 优惠
- (IBAction)activitiesClick:(id)sender {
    SH_PromoContentView *promoContentView = [[[NSBundle mainBundle] loadNibNamed:@"SH_PromoContentView" owner:nil options:nil] lastObject];
    
    [[PopTool sharedInstance] showWithPresentView:promoContentView withLeading:80 withTop:20 subTitle:@"优惠活动" AnimatedType:AnimationTypeScale AnimationDirectionType:AnimationDirectionFromLeft];

}

- (IBAction)userCenterClick:(id)sender {
}

- (IBAction)incomeClick:(id)sender {
}

- (IBAction)shareClick:(id)sender {
}

- (void)initAdScroll
{
    //广告轮播
    _cycleAdView = [SH_CycleScrollView new];
    _cycleAdView.datasource = self;
    _cycleAdView.delegate = self;
    _cycleAdView.continuous = YES;
    _cycleAdView.autoPlayTimeInterval = 5;
    [self.view addSubview:_cycleAdView];
    [_cycleAdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(18);
        make.top.mas_equalTo(88);
        make.width.mas_equalTo(190);
        make.height.mas_equalTo(224);
    }];
}

#pragma mark - SH_CycleScrollViewDataSource

- (NSArray *)numberOfCycleScrollView:(SH_CycleScrollView *)bannerView
{
    return @[[UIImage imageNamed:@"banner"],
             [UIImage imageNamed:@"banner"],
             [UIImage imageNamed:@"banner"],
             [UIImage imageNamed:@"banner"]];
}

- (UIViewContentMode)contentModeForImageIndex:(NSUInteger)index {
    return UIViewContentModeScaleAspectFill;
}

- (UIImage *)placeHolderImageOfZeroBannerView {
    return [UIImage imageNamed:@"banner"];
}

#pragma mark - SH_CycleScrollViewDelegate

- (void)cycleScrollView:(SH_CycleScrollView *)scrollView didScrollToIndex:(NSUInteger)index
{}

- (void)cycleScrollView:(SH_CycleScrollView *)scorllView didSelectedAtIndex:(NSUInteger)index
{}

@end

