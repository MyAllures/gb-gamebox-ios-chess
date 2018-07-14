//
//  SH_HomeViewController.m
//  GameBox
//
//  Created by shin on 2018/7/4.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "SH_HomeViewController.h"
#import "SH_NetWorkService+Login.h"
#import "NetWorkLineMangaer.h"
#import "GameWebViewController.h"
#import "AppDelegate.h"
#import "SH_RechargeCenterViewController.h"
#import "View+MASAdditions.h"
#import "SH_CycleScrollView.h"
#import "SH_PlayerCenterView.h"
#import "SH_WelfareView.h"
#import "AlertViewController.h"
#import "SH_LoginView.h"
#import "SH_PromoContentView.h"
#import "PopTool.h"
#import "SH_GamesListScrollView.h"
#import "SH_NetWorkService+Home.h"
#import "SH_HomeBannerModel.h"
#import "SH_RingManager.h"
#import "SH_RingButton.h"

#import "SH_UserInformationView.h"
#import "SH_AlertView.h"
#import "SH_SettingView.h"
#import "SH_NetWorkService+RegistAPI.h"
@interface SH_HomeViewController ()<SH_CycleScrollViewDataSource, SH_CycleScrollViewDelegate, GamesListScrollViewDataSource, GamesListScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;
@property (weak, nonatomic) IBOutlet UILabel *userAccountLB;
@property (strong, nonatomic) SH_CycleScrollView *cycleAdView;
@property (nonatomic, strong) UIView *backV;
@property (nonatomic, strong) SH_PlayerCenterView *pcv;
@property (nonatomic, strong) SH_WelfareView *welfareV;
@property (nonatomic, strong) UIView *welBackV;
@property (strong, nonatomic) SH_GamesListScrollView *gamesListScrollView;
@property (nonatomic, strong) NSMutableArray *bannerArr;

@end

@implementation SH_HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self fetchCookie];
    [self initAdScroll];
    [self.gamesListScrollView reloaData];
    [[NSNotificationCenter  defaultCenter] addObserver:self selector:@selector(didRegistratedSuccessful) name:@"didRegistratedSuccessful" object:nil];
    [self  configUI];
    [self  autoLoginIsRegist:YES];
}
#pragma mark --- 记着密码启动自动登录
#pragma  mark --- 自动登录
-(void)autoLoginIsRegist:(BOOL)isRegist{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *account = [defaults objectForKey:@"account"];
    NSString *password = [defaults objectForKey:@"password"];
    
    if(account.length==0 || password.length ==0){
        return;
    }
    if (isRegist) {
        [SH_NetWorkService  fetchAutoLoginWithUserName:account Password:password complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
            NSDictionary *result = ConvertToClassPointer(NSDictionary, response) ;
            if ([result boolValueForKey:@"success"]){
                [[RH_UserInfoManager shareUserManager] updateLoginInfoWithUserName:account
                                                                         LoginTime:dateStringWithFormatter([NSDate date], @"yyyy-MM-dd HH:mm:ss")] ;
                [self autoLoginSuccess:httpURLResponse];
            }
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            
        }];
    }else if ([defaults boolForKey:@"isRememberPwd"]) {
        [SH_NetWorkService  login:account psw:password verfyCode:@"" complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
            NSDictionary *result = ConvertToClassPointer(NSDictionary, response) ;
            if ([result boolValueForKey:@"success"]){
                [[RH_UserInfoManager shareUserManager] updateLoginInfoWithUserName:account
                                                                         LoginTime:dateStringWithFormatter([NSDate date], @"yyyy-MM-dd HH:mm:ss")] ;
                [self autoLoginSuccess:httpURLResponse];
            }
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            
        }];
    }
}
#pragma mark --- 登录成功之后 获取用户信息
-(void)autoLoginSuccess:(NSHTTPURLResponse *)httpURLResponse{
    
    NSString *setCookie = [httpURLResponse.allHeaderFields objectForKey:@"Set-Cookie"];
    NSString *cookie;
    if ([setCookie rangeOfString:@"GMT, "].location !=NSNotFound) {
//        NSUInteger startLocation = [setCookie rangeOfString:@"GMT, "].location +4;
//        NSUInteger endLocation = [setCookie rangeOfString:@" rememberMe=deleteMe"].location;
//        NSUInteger lenth = endLocation - startLocation;
//        cookie = [setCookie substringWithRange:NSMakeRange(startLocation, lenth)];
        NSString *responseStr = httpURLResponse.allHeaderFields[@"Set-Cookie"] ;
        NSMutableArray *mArr = [NSMutableArray array] ;
        if (isSidStr(responseStr)) {
            [mArr addObjectsFromArray:matchLongString(responseStr)] ;
        }
        if (mArr.count>0) {
             [NetWorkLineMangaer sharedManager].currentCookie  = [NSString stringWithFormat:@"SID=%@",[mArr firstObject]] ;
        }
    }else{
        cookie = setCookie;
    }
    
//    [NetWorkLineMangaer sharedManager].currentCookie = cookie;
    [[RH_UserInfoManager  shareUserManager] updateIsLogin:YES];
    [SH_NetWorkService fetchUserInfo:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary * dict = ConvertToClassPointer(NSDictionary, response);
        if ([dict  boolValueForKey:@"success"]) {
            RH_MineInfoModel * model = [[RH_MineInfoModel alloc] initWithDictionary:[dict[@"data"] objectForKey:@"user"] error:nil];
            [[RH_UserInfoManager  shareUserManager] setMineSettingInfo:model];
            [self  configUI];
        }
        
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        //
    }];
}
#pragma  mark --- 配置UI
-(void)configUI{
    self.userAccountLB.text = [RH_UserInfoManager shareUserManager].mineSettingInfo.username?:@"sjjaid09";
}
- (NSMutableArray *)bannerArr
{
    if (_bannerArr == nil) {
        _bannerArr = [NSMutableArray array];
    }
    return _bannerArr;
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
#pragma   mark ---   test  code
- (IBAction)enterGame:(id)sender {
    
    /*
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
    }];*/
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
 * 获取Cookie
 */
- (void)fetchCookie
{
    [SH_NetWorkService fetchHttpCookie:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSString *setCookie = [httpURLResponse.allHeaderFields objectForKey:@"Set-Cookie"];
        [NetWorkLineMangaer sharedManager].currentCookie = setCookie;
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        //
    }];
}
#pragma  mark --- 用户登录
- (IBAction)avaterClick:(id)sender {
    [self login];
}
-(void)login{
    SH_LoginView *login = [SH_LoginView  InstanceLoginView];
    AlertViewController * cvc = [[AlertViewController  alloc] initAlertView:login viewHeight:260 viewWidth:494];
    login.dismissBlock = ^{
        [cvc  close];
        [self  configUI];
    };
    login.changeChannelBlock = ^(NSString *string) {
        [cvc  setSubTitle:string];
    };
    cvc.title = @"登录";
    cvc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    cvc.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    [self presentViewController:cvc animated:YES completion:nil];
}
#pragma  mark --- 个人设置
- (IBAction)avatarClick:(id)sender {
    if (![RH_UserInfoManager  shareUserManager].isLogin) {
        [self login];
        return;
    }
    SH_UserInformationView * inforView = [SH_UserInformationView  instanceInformationView];
    AlertViewController * cvc = [[AlertViewController  alloc] initAlertView:inforView viewHeight:200 viewWidth:322];
    cvc.title = @"个人信息";
    inforView.buttonClickBlock = ^(NSInteger tag) {
        if (tag==100) {
            SH_AlertView * alert = [SH_AlertView  instanceAlertView];
            AlertViewController * vc = [[AlertViewController  alloc] initAlertView:alert viewHeight:174 viewWidth:288];
            alert.btnClickBlock = ^(NSInteger tag) {
                if (tag==100) {
                    [vc close];
                }else{
                    [SH_NetWorkService  fetchUserLoginOut:^(NSHTTPURLResponse *httpURLResponse, id response) {
                        [[RH_UserInfoManager  shareUserManager] updateIsLogin:false];
                        [[RH_UserInfoManager  shareUserManager] setMineSettingInfo:nil];
                        [self configUI];
                        showMessage([UIApplication  sharedApplication].keyWindow, @"已成功退出", nil);
                        if ([vc respondsToSelector:@selector(presentingViewController)]){
                            [vc.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
                        }else {
                            [vc.parentViewController.parentViewController dismissViewControllerAnimated:NO completion:nil];
                        }
                    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
                        showMessage([UIApplication  sharedApplication].keyWindow, @"退出失败", nil);
                    }];
                    
                }
            };
            vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            vc.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
            [cvc presentViewController:vc animated:YES completion:nil];
        }else{
            SH_SettingView * settingView = [SH_SettingView instanceSettingView];
            AlertViewController * setVC = [[AlertViewController  alloc] initAlertView:settingView viewHeight:130 viewWidth:251];
            setVC.subTitle = @"设置";
            setVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            setVC.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
            [cvc presentViewController:setVC animated:YES completion:nil];
        }
    };
    cvc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    cvc.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    [self presentViewController:cvc animated:YES completion:nil];
}

- (IBAction)rechargeClick:(id)sender {    
    [self presentViewController:[[SH_RechargeCenterViewController alloc]init] animated:YES completion:nil];
}
#pragma mark 优惠
- (IBAction)activitiesClick:(id)sender {
    SH_PromoContentView *promoContentView = [[[NSBundle mainBundle] loadNibNamed:@"SH_PromoContentView" owner:nil options:nil] lastObject];
    AlertViewController * cvc = [[AlertViewController  alloc] initAlertView:promoContentView viewHeight:[UIScreen mainScreen].bounds.size.height-60 viewWidth:[UIScreen mainScreen].bounds.size.width-160];
    //    cvc.imageName = @"progress_bar_icon";
    cvc.title = @"优惠活动";
    cvc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    cvc.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    [self presentViewController:cvc animated:YES completion:nil];
}

//玩家中心
- (IBAction)userCenterClick:(id)sender
{
    self.backV = [[UIView alloc] init];
    self.backV.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.5];
    [self.view addSubview:self.backV];

    self.pcv = [[SH_PlayerCenterView alloc] init];
    self.pcv.backgroundColor = [UIColor greenColor];
    self.pcv.delegate = self;
    [self.backV addSubview:self.pcv];
    
 
    [UIView animateWithDuration:3.0 animations:^{
        [self.backV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.equalTo(self.view);
        }];

        [self.pcv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.backV).mas_equalTo(0);
            make.width.mas_equalTo(202);
            make.bottom.equalTo(self.backV).mas_equalTo(0);
            make.top.equalTo(self.backV.mas_top);
        }];
    
        
        
    }];
}

#pragma mark - SH_PlayerCenterViewDelegate
- (void)removeView
{
    [UIView animateWithDuration:2.0 animations:^{
        [self.pcv removeFromSuperview];
        [self.backV removeFromSuperview];
    }];
}

- (void)popView:(UIButton *)btn
{
    [self removeView];
    
    self.welBackV = [[UIView alloc] init];
    self.welBackV.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.5];
    [self.view addSubview:self.welBackV];
    
    
    
    self.welfareV = [[SH_WelfareView alloc] init];
    self.welfareV.backgroundColor = [UIColor whiteColor];
    self.welfareV.delegate = self;
    self.welfareV.layer.cornerRadius = 4.5;
    [self.welBackV addSubview:self.welfareV];
    
    
    if ([btn.currentTitle isEqualToString:@"福利记录"]) {
        [UIView animateWithDuration:2.0 animations:^{
          
            [self.welBackV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.bottom.equalTo(self.view);
            }];
            
            
            [self.welfareV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(470, 380));
                make.top.equalTo(self.view.mas_top).with.offset(25);
                make.left.equalTo(self.view.mas_left).with.offset(105);
                make.bottom.equalTo(self.view.mas_bottom).with.offset(-22);
            }];
        }];
    }
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

- (SH_GamesListScrollView *)gamesListScrollView
{
    if (_gamesListScrollView == nil) {
        _gamesListScrollView = [[SH_GamesListScrollView alloc] init];
        _gamesListScrollView.dataSource = self;
        _gamesListScrollView.delegate = self;
        [self.view addSubview:_gamesListScrollView];
        [_gamesListScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cycleAdView.mas_right).mas_equalTo(0);
            make.top.equalTo(self.cycleAdView.mas_top);
            make.bottom.equalTo(self.cycleAdView.mas_bottom);
            make.right.equalTo(self.view.mas_right);
        }];
    }
    return _gamesListScrollView;
}

- (void)fetchHomeInfo
{
    __weak typeof(self) weakSelf = self;

    [SH_NetWorkService fetchHomeInfo:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary *data = [response objectForKey:@"data"];
        
        //获取banner数据并更新UI
        NSArray *banner = [data objectForKey:@"banner"];
        for (NSDictionary *bannerDic in banner) {
            SH_HomeBannerModel *homeBannerModel = [[SH_HomeBannerModel alloc] initWithDictionary:bannerDic error:nil];
            [weakSelf.bannerArr addObject:homeBannerModel.cover];
        }
        [weakSelf.cycleAdView reloadDataWithCompleteBlock:nil];
        
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        //
    }];
}

#pragma mark ---注册成功的通知 这里自动登录
-(void)didRegistratedSuccessful{
   /* NSUserDefaults  * defaults = [NSUserDefaults standardUserDefaults];
    [SH_NetWorkService  fetchAutoLoginWithUserName:[defaults objectForKey:@"username"] Password:[defaults objectForKey:@"account"] complete:^(NSHTTPURLResponse *httpURLResponse, id response) {

    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];*/
    [self  autoLoginIsRegist:YES];
}
#pragma mark - SH_CycleScrollViewDataSource

- (NSArray *)numberOfCycleScrollView:(SH_CycleScrollView *)bannerView
{
    return self.bannerArr;
}

- (UIViewContentMode)contentModeForImageIndex:(NSUInteger)index {
    return UIViewContentModeScaleToFill;
}

- (UIImage *)placeHolderImageOfBannerView:(SH_CycleScrollView *)bannerView atIndex:(NSUInteger)index
{
    return [UIImage imageNamed:@"banner"];
}

- (UIImage *)placeHolderImageOfZeroBannerView {
    return [UIImage imageNamed:@"banner"];
}

#pragma mark - SH_CycleScrollViewDelegate

- (void)cycleScrollView:(SH_CycleScrollView *)scrollView didScrollToIndex:(NSUInteger)index
{}

- (void)cycleScrollView:(SH_CycleScrollView *)scorllView didSelectedAtIndex:(NSUInteger)index
{}

#pragma mark - SH_WelfareViewDelegate
- (void)welfareViewDisappear
{
    [self.welfareV removeFromSuperview];
    [self.welBackV removeFromSuperview];
}

#pragma mark - GamesListScrollViewDataSource M

- (NSInteger)numberOfItemsOfGamesListScrollView:(SH_GamesListScrollView *)scrollView
{
    return 23;
}

- (UIView *)gamesListScrollView:(SH_GamesListScrollView *)scrollView viewForItem:(NSInteger)index
{
    return [[[NSBundle mainBundle] loadNibNamed:@"SH_GameItemView" owner:nil options:nil] lastObject];
}

#pragma mark - GamesListScrollViewDelegate M

- (void)gamesListScrollView:(SH_GamesListScrollView *)scrollView didSelectItem:(NSInteger)index
{}

@end

