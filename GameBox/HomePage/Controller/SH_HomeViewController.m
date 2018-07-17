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
#import "SH_PlayerCenterView.h"
#import "SH_SecurityCenterView.h"
#import "SH_CardRecordView.h"
#import "SH_GameItemModel.h"
#import "SH_GameItemView.h"
#import "SH_DZGameItemView.h"
#import "SH_UserInformationView.h"
#import "SH_AlertView.h"
#import "SH_SettingView.h"
#import "SH_NetWorkService+RegistAPI.h"
#import "SH_WKGameViewController.h"
#import "SH_NoAccessViewController.h"
#import "SH_PrifitOutCoinView.h"
#import "SH_PromoDetailView.h"
#import "SH_NetWorkService+Profit.h"
#import "SH_ProfitModel.h"
#import "SH_AnnouncementView.h"

@interface SH_HomeViewController () <SH_CycleScrollViewDataSource, SH_CycleScrollViewDelegate, GamesListScrollViewDataSource, GamesListScrollViewDelegate,PlayerCenterViewDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;
@property (weak, nonatomic) IBOutlet UILabel *userAccountLB;
@property (weak, nonatomic) IBOutlet UIButton *upLevelBT;
@property (weak, nonatomic) IBOutlet UIImageView *dzGameMarkImg;
@property (weak, nonatomic) IBOutlet UIImageView *runLBBGImg;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (strong, nonatomic) SH_CycleScrollView *cycleAdView;
@property (nonatomic, strong) SH_PlayerCenterView *pcv;
@property (nonatomic, strong) UIView *backV;
@property (nonatomic, strong) SH_WelfareView *welfareV;
@property (nonatomic, strong) UIView *welBackV;
@property (strong, nonatomic) SH_GamesListScrollView *topGamesListScrollView;
@property (strong, nonatomic) SH_GamesListScrollView *midGamesListScrollView;
@property (strong, nonatomic) SH_GamesListScrollView *lastGamesListScrollView;
@property (nonatomic, strong) NSMutableArray *bannerArr;
@property (nonatomic, strong) NSMutableArray *siteApiRelationArr;
@property (nonatomic, strong) SH_GameItemModel *currentGameItemModel;
@property (nonatomic, assign) int currentLevel;
@property (nonatomic, strong) NSString *currentDZGameTypeId;
@property (nonatomic, assign) BOOL enterDZGameLevel;
@property (nonatomic, strong) SH_AnnouncementView *announcementView;
@property (weak, nonatomic) IBOutlet UILabel *suishenFuLiLab;


@end

@implementation SH_HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self fetchCookie];
    [self initAdScroll];
    [self refreshAnnouncement];
//    [self refreshHomeInfo];
    [[NSNotificationCenter  defaultCenter] addObserver:self selector:@selector(didRegistratedSuccessful) name:@"didRegistratedSuccessful" object:nil];
    [self  configUI];
    [self  autoLoginIsRegist:false];
}

#pragma mark - 记着密码启动自动登录
#pragma mark - 自动登录

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
                [self autoLoginSuccess:httpURLResponse isRegist:isRegist];
            }
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            [[RH_UserInfoManager  shareUserManager] updateIsLogin:false];
        }];
    }else if ([defaults boolForKey:@"isRememberPwd"]) {
        if ([RH_UserInfoManager  shareUserManager].isLogin) {
            return;
        }
        [SH_NetWorkService  login:account psw:password verfyCode:@"" complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
            NSDictionary *result = ConvertToClassPointer(NSDictionary, response) ;
            if ([result boolValueForKey:@"success"]){
                [[RH_UserInfoManager shareUserManager] updateLoginInfoWithUserName:account
                                                                         LoginTime:dateStringWithFormatter([NSDate date], @"yyyy-MM-dd HH:mm:ss")] ;
                [self autoLoginSuccess:httpURLResponse isRegist:isRegist];
            }
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            [[RH_UserInfoManager  shareUserManager] updateIsLogin:false];
        }];
    }
}

#pragma mark - 登录成功之后 获取用户信息

-(void)autoLoginSuccess:(NSHTTPURLResponse *)httpURLResponse isRegist:(BOOL)isRegist{
    
    NSString * setCookie = [httpURLResponse.allHeaderFields objectForKey:@"Set-Cookie"];
    NSString *cookie;
    if (isRegist) {
        NSUInteger startLocation = [setCookie rangeOfString:@"GMT, "].location +4;
        NSUInteger endLocation = [setCookie rangeOfString:@" rememberMe=deleteMe"].location;
        NSUInteger lenth = endLocation - startLocation;
        cookie = [setCookie substringWithRange:NSMakeRange(startLocation, lenth)];
    }else{
        cookie = setCookie;
    }
    [NetWorkLineMangaer sharedManager].currentCookie = cookie;
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
        [[RH_UserInfoManager  shareUserManager] updateIsLogin:false];
    }];
}

#pragma mark - 更新用户信息

-(void)configUI{
    self.userAccountLB.text = [RH_UserInfoManager shareUserManager].mineSettingInfo.username?:@"登录/注册";
    
    if ([RH_UserInfoManager  shareUserManager].isLogin) {
        self.avatarImg.image = [UIImage  imageNamed:@"photo_male"];
        //刷新随身福利
        self.suishenFuLiLab.text = [NSString stringWithFormat:@"%.2f",[RH_UserInfoManager shareUserManager].mineSettingInfo.walletBalance];        
    }else{
        self.avatarImg.image = [UIImage  imageNamed:@"avatar"];
    }
}

- (NSMutableArray *)bannerArr
{
    if (_bannerArr == nil) {
        _bannerArr = [NSMutableArray array];
    }
    return _bannerArr;
}

- (NSMutableArray *)siteApiRelationArr
{
    if (_siteApiRelationArr == nil) {
        _siteApiRelationArr = [NSMutableArray array];
    }
    return _siteApiRelationArr;
}

- (void)setCurrentLevel:(int)currentLevel
{
    _currentLevel = currentLevel;
    self.upLevelBT.hidden = _currentLevel == 0;
}

- (void)setCurrentDZGameTypeId:(NSString *)currentDZGameTypeId
{
    _currentDZGameTypeId = currentDZGameTypeId;
    int typeId = [_currentDZGameTypeId intValue];
    
    switch (typeId) {
        case 28:
        {
            //GG捕鱼
            self.dzGameMarkImg.image = [UIImage imageNamed:@""];
        }
            break;
        case 35:
        {
            //MW电子
            self.dzGameMarkImg.image = [UIImage imageNamed:@"logo11"];
        }
            break;
        case 15:
        {
            //HB电子
            self.dzGameMarkImg.image = [UIImage imageNamed:@""];
        }
            break;
        case 26:
        {
            //PNG电子
            self.dzGameMarkImg.image = [UIImage imageNamed:@"logo06"];
        }
            break;
        case 20:
        {
            //BSG电子
            self.dzGameMarkImg.image = [UIImage imageNamed:@"logo03"];
        }
            break;
        case 27:
        {
            //DT电子
            self.dzGameMarkImg.image = [UIImage imageNamed:@"logo10"];
        }
            break;
        case 6:
        {
            //PT电子
            self.dzGameMarkImg.image = [UIImage imageNamed:@"logo04"];
        }
            break;
        case 25:
        {
            //新霸电子
            self.dzGameMarkImg.image = [UIImage imageNamed:@"logo05"];
        }
            break;
        case 3:
        {
            //MG电子
            self.dzGameMarkImg.image = [UIImage imageNamed:@"logo01"];
        }
            break;
        case 9:
        {
            //AG电子
            self.dzGameMarkImg.image = [UIImage imageNamed:@"logo08"];
        }
            break;
        case 10:
        {
            //BB电子
            self.dzGameMarkImg.image = [UIImage imageNamed:@"logo09"];
        }
            break;
        case 44:
        {
            //NT电子
            self.dzGameMarkImg.image = [UIImage imageNamed:@""];
        }
            break;
        case 38:
        {
            //新PP电子
            self.dzGameMarkImg.image = [UIImage imageNamed:@""];
        }
            break;
        case 45:
        {
            //PG老虎机
            self.dzGameMarkImg.image = [UIImage imageNamed:@""];
        }
            break;
        case 14:
        {
            //NYX电子
            self.dzGameMarkImg.image = [UIImage imageNamed:@""];
        }
            break;
        case 32:
        {
            //PP电子
            self.dzGameMarkImg.image = [UIImage imageNamed:@"logo02"];
        }
            break;
        default:
            break;
    }
}

- (IBAction)upToLastLevel:(id)sender {
    self.currentLevel --;
    if (self.enterDZGameLevel && self.currentLevel == 0) {
        self.enterDZGameLevel = NO;
    }
    self.dzGameMarkImg.image = nil;
    self.searchView.hidden = YES;
    if (self.currentLevel == 1) {
        self.cycleAdView.hidden = YES;
        self.topGamesListScrollView.hidden = YES;
        self.midGamesListScrollView.hidden = NO;
        self.lastGamesListScrollView.hidden = YES;
    }
    else if (self.currentLevel == 0)
    {
        self.cycleAdView.hidden = NO;
        self.topGamesListScrollView.hidden = NO;
        self.midGamesListScrollView.hidden = YES;
        self.lastGamesListScrollView.hidden = YES;
    }
    
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

/**
 * 获取Cookie
 */
- (void)fetchCookie
{
    __weak typeof(self) weakSelf = self;

    [SH_NetWorkService fetchHttpCookie:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSString *setCookie = [httpURLResponse.allHeaderFields objectForKey:@"Set-Cookie"];
        [NetWorkLineMangaer sharedManager].currentCookie = setCookie;
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        if (httpURLResponse.statusCode == 605) {
            [weakSelf showNoAccess];
        }
    }];
}

#pragma mark - 用户登录

-(void)login{
    SH_LoginView *login = [SH_LoginView  InstanceLoginView];
    //AlertViewController * cvc = [[AlertViewController  alloc] initAlertView:login viewHeight:260 viewWidth:494 titleImageName:@"title01"];
    AlertViewController * cvc = [[AlertViewController  alloc] initAlertView:login viewHeight:260 titleImageName:@"title01" alertViewType:AlertViewTypeLong];
    login.dismissBlock = ^{
        [cvc  close];
        [self  configUI];
    };
    login.changeChannelBlock = ^(NSString *string) {
      [cvc setImageName:string];
        
    };
    [self presentViewController:cvc addTargetViewController:self];
}

#pragma mark - 个人设置

- (IBAction)avatarClick:(id)sender {
    if (![RH_UserInfoManager  shareUserManager].isLogin) {
        [self login];
        return;
    }
    SH_UserInformationView * inforView = [SH_UserInformationView  instanceInformationView];
    AlertViewController * cvc = [[AlertViewController  alloc] initAlertView:inforView viewHeight:204 titleImageName:@"title04" alertViewType:AlertViewTypeShort];
    __weak  typeof(self) weakSelf = self;
    inforView.buttonClickBlock = ^(NSInteger tag) {
        if (tag==100) {
            SH_AlertView * alert = [SH_AlertView  instanceAlertView];
             AlertViewController * vc = [[AlertViewController  alloc] initAlertView:alert viewHeight:174 titleImageName:@"title03" alertViewType:AlertViewTypeShort];
            alert.btnClickBlock = ^(NSInteger tag) {
                if (tag==100) {
                    [vc close];
                }else{
                    [SH_NetWorkService  fetchUserLoginOut:^(NSHTTPURLResponse *httpURLResponse, id response) {
                        [[RH_UserInfoManager  shareUserManager] updateIsLogin:false];
                        [[RH_UserInfoManager  shareUserManager] setMineSettingInfo:nil];
                      /*  [[NSUserDefaults  standardUserDefaults] setObject:@"" forKey:@"password"];
                        [[NSUserDefaults  standardUserDefaults] synchronize];*/
                        [weakSelf configUI];
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
            [weakSelf  presentViewController:vc addTargetViewController:cvc];
        }else{
            SH_SettingView * settingView = [SH_SettingView instanceSettingView];
             AlertViewController * setVC = [[AlertViewController  alloc] initAlertView:settingView viewHeight:130 titleImageName:@"title05" alertViewType:AlertViewTypeShort];
            [weakSelf  presentViewController:setVC addTargetViewController:cvc];
        }
    };
    [self presentViewController:cvc addTargetViewController:self];
}
#pragma mark --- 模态弹出viewController
-(void)presentViewController:(UIViewController*)viewController addTargetViewController:(UIViewController*)targetVC{
    viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    viewController.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    [targetVC presentViewController:viewController animated:YES completion:nil];
}

#pragma mark - 优惠活动
- (IBAction)activitiesClick:(id)sender {
    SH_PromoContentView *promoContentView = [[[NSBundle mainBundle] loadNibNamed:@"SH_PromoContentView" owner:nil options:nil] lastObject];
    AlertViewController  * cvc = [[AlertViewController  alloc] initAlertView:promoContentView viewHeight:[UIScreen mainScreen].bounds.size.height-80 titleImageName:@"progress_bar_icon" alertViewType:AlertViewTypeLong];
    //    cvc.imageName = @"progress_bar_icon";
    cvc.title = @"优惠活动";
    cvc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    cvc.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    [self presentViewController:cvc animated:YES completion:nil];
}

#pragma mark - 优惠活动详情
-(void)gotoPromoDetail {
    SH_PromoDetailView *promoDetailView = [[[NSBundle mainBundle] loadNibNamed:@"SH_PromoDetailView" owner:nil options:nil] lastObject];
  
    AlertViewController * cvc = [[AlertViewController  alloc] initAlertView:promoDetailView viewHeight:[UIScreen mainScreen].bounds.size.height-60 titleImageName:@"" alertViewType:AlertViewTypeLong];
    cvc.title = @"优惠活动";
    cvc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    cvc.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    [self presentViewController:cvc animated:YES completion:nil];
}
#pragma mark--
#pragma mark--充值中心

- (IBAction)recharegeBtnClick:(id)sender {
    if (![[RH_UserInfoManager shareUserManager] isLogin]) {
        [self login];
        return;
    }
    [self.navigationController pushViewController:[[SH_RechargeCenterViewController alloc]init] animated:YES];
}
#pragma mark--
#pragma mark--收益按钮
- (IBAction)profitBtnClick:(id)sender {
    SH_PrifitOutCoinView *view = [[NSBundle mainBundle]loadNibNamed:@"SH_PrifitOutCoinView" owner:nil options:nil].lastObject;
    AlertViewController *acr  = [[AlertViewController  alloc] initAlertView:view viewHeight:[UIScreen mainScreen].bounds.size.height-75 titleImageName:@"profitTitle" alertViewType:AlertViewTypeLong];
    acr.title = @"牌局记录";
    acr.modalPresentationStyle = UIModalPresentationCurrentContext;
    acr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:acr animated:YES completion:nil];
    
    [SH_NetWorkService getBankInforComplete:^(SH_ProfitModel *model) {
        [view updateUIWithBalance:model.totalBalance BankNum:[model.bankcardMap objectForKey:@"1"][@"bankcardNumber"] TargetVC:acr];
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
}

#pragma mark - 玩家中心

//玩家中心
- (IBAction)userCenterClick:(id)sender
{
    self.backV = [[UIView alloc] init];
    self.backV.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.5];
    [self.view addSubview:self.backV];

    self.pcv = [[SH_PlayerCenterView alloc] init];
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
    
    if ([btn.currentTitle isEqualToString:@"福利记录"]) {
        
        self.welBackV = [[UIView alloc] init];
        self.welBackV.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.5];
        [self.view addSubview:self.welBackV];
        
        //福利记录
        self.welfareV = [[SH_WelfareView alloc] init];
        self.welfareV.backgroundColor = [UIColor whiteColor];
        self.welfareV.layer.cornerRadius = 4.5;
        [self.welBackV addSubview:self.welfareV];
        
        AlertViewController *cvc  = [[AlertViewController  alloc] initAlertView:self.welfareV viewHeight:303 titleImageName:@"title06" alertViewType:AlertViewTypeLong];
        
        cvc.title = @"福利记录";
        cvc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        cvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:cvc animated:YES completion:nil];
    }
    
    else if ([btn.currentTitle isEqualToString:@"安全中心"]) {
        
        //安全中心
        UIView *securityBackV = [[UIView alloc] init];
        securityBackV.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.5];
        [self.view addSubview:securityBackV];
        
        SH_SecurityCenterView *securityView = [[SH_SecurityCenterView alloc] init];
        securityView.backgroundColor = [UIColor whiteColor];
        securityView.layer.cornerRadius = 4.5;
        [securityBackV addSubview:securityView];
    
      AlertViewController *avc  = [[AlertViewController  alloc] initAlertView:securityView viewHeight:[UIScreen mainScreen].bounds.size.height-60 titleImageName:@"" alertViewType:AlertViewTypeLong];
        avc.title = @"安全中心";
        avc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        avc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:avc animated:YES completion:nil];
    }

    else if ([btn.currentTitle isEqualToString:@"牌局记录"]) {
        
        //牌局记录
        UIView *cardBackV = [[UIView alloc] init];
        cardBackV.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.5];
        [self.view addSubview:cardBackV];
        
        SH_CardRecordView *crv = [[SH_CardRecordView alloc] init];
        crv.backgroundColor = [UIColor whiteColor];
        crv.layer.cornerRadius = 4.5;
        [cardBackV addSubview:crv];
        
        AlertViewController *acr  = [[AlertViewController  alloc] initAlertView:crv viewHeight:[UIScreen mainScreen].bounds.size.height-60 titleImageName:@"" alertViewType:AlertViewTypeLong];
        acr.title = @"牌局记录";
        acr.modalPresentationStyle = UIModalPresentationCurrentContext;
        acr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:acr animated:YES completion:nil];
    }
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

- (SH_GamesListScrollView *)topGamesListScrollView
{
    if (_topGamesListScrollView == nil) {
        _topGamesListScrollView = [[SH_GamesListScrollView alloc] init];
        _topGamesListScrollView.dataSource = self;
        _topGamesListScrollView.delegate = self;
        [self.view addSubview:_topGamesListScrollView];
        [_topGamesListScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(18+190);
            make.top.mas_equalTo(88);
            make.height.mas_equalTo(224);
            make.right.equalTo(self.view.mas_right);
        }];
    }
    return _topGamesListScrollView;
}

- (SH_GamesListScrollView *)midGamesListScrollView
{
    if (_midGamesListScrollView == nil) {
        _midGamesListScrollView = [[SH_GamesListScrollView alloc] init];
        _midGamesListScrollView.dataSource = self;
        _midGamesListScrollView.delegate = self;
        [self.view addSubview:_midGamesListScrollView];
        [_midGamesListScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(88);
            make.height.mas_equalTo(224);
            make.right.equalTo(self.view.mas_right);
        }];
    }
    return _midGamesListScrollView;
}

- (SH_GamesListScrollView *)lastGamesListScrollView
{
    if (_lastGamesListScrollView == nil) {
        _lastGamesListScrollView = [[SH_GamesListScrollView alloc] init];
        _lastGamesListScrollView.dataSource = self;
        _lastGamesListScrollView.delegate = self;
        [self.view addSubview:_lastGamesListScrollView];
        [_lastGamesListScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(88);
            make.height.mas_equalTo(224);
            make.right.equalTo(self.view.mas_right);
        }];
    }
    return _lastGamesListScrollView;
}

- (void)refreshHomeInfo
{
    __weak typeof(self) weakSelf = self;
    [self.bannerArr removeAllObjects];
    [self.siteApiRelationArr removeAllObjects];
    
    [SH_NetWorkService fetchHomeInfo:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary * result = ConvertToClassPointer(NSDictionary, response);
        if ([result  boolValueForKey:@"success"]) {
            NSDictionary *data = [response objectForKey:@"data"];
            
            //获取banner数据并更新UI
            NSArray *banner = [data objectForKey:@"banner"];
            for (NSDictionary *bannerDic in banner) {
                SH_HomeBannerModel *homeBannerModel = [[SH_HomeBannerModel alloc] initWithDictionary:bannerDic error:nil];
                [weakSelf.bannerArr addObject:homeBannerModel.cover];
            }
            [weakSelf.cycleAdView reloadDataWithCompleteBlock:nil];
            
            NSArray *siteApiRelation = [data objectForKey:@"siteApiRelation"];
            for (NSDictionary *siteApiRelationDic in siteApiRelation) {
                NSError *err;
                SH_GameItemModel *gameItemModel = [[SH_GameItemModel alloc] initWithDictionary:siteApiRelationDic error:&err];
                [weakSelf.siteApiRelationArr addObject:gameItemModel];
            }
            [weakSelf.topGamesListScrollView reloaData];
        }
       
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        if (httpURLResponse.statusCode == 605) {
            [weakSelf showNoAccess];
        }
    }];
}

- (void)refreshAnnouncement
{
    __weak typeof(self) weakSelf = self;
    if (_announcementView == nil) {
        _announcementView = [[SH_AnnouncementView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_announcementView];
        [_announcementView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.runLBBGImg).mas_equalTo(8);
            make.right.equalTo(self.runLBBGImg).mas_equalTo(-8);
            make.top.bottom.equalTo(self.runLBBGImg).mas_equalTo(0);
        }];
    }

    [SH_NetWorkService fetchAnnouncement:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary *data = [response objectForKey:@"data"];
        NSArray *announcementArr = [data objectForKey:@"announcement"];
        NSString *announcementStr = [NSString string];
        for (NSDictionary *announcementDic in announcementArr) {
            NSString *content = [announcementDic objectForKey:@"content"];
            announcementStr = [announcementStr stringByAppendingString:[NSString stringWithFormat:@"     %@",content]];
        }
        weakSelf.announcementView.string = announcementStr;
        [weakSelf.announcementView start];
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        //
    }];
}

#pragma mark ---注册成功的通知 这里自动登录
-(void)didRegistratedSuccessful{
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
    if (self.currentLevel == 0) {
        return self.siteApiRelationArr.count;
    }
    else
    {
        return self.currentGameItemModel.relation.count;
    }
}

- (UIView *)gamesListScrollView:(SH_GamesListScrollView *)scrollView viewForItem:(NSInteger)index
{
    NSMutableArray *dataArr = [NSMutableArray array];
    if (scrollView == self.topGamesListScrollView) {
        dataArr = self.siteApiRelationArr;
    }
    else
    {
        dataArr = [NSMutableArray arrayWithArray:self.currentGameItemModel.relation];
    }

    if (self.enterDZGameLevel && self.currentLevel == 2) {
        SH_DZGameItemView *gameItemView =[[[NSBundle mainBundle] loadNibNamed:@"SH_DZGameItemView" owner:nil options:nil] lastObject];
        gameItemView.gameItemModel = dataArr[index];
        return gameItemView;
    }
    else
    {
        SH_GameItemView *gameItemView =[[[NSBundle mainBundle] loadNibNamed:@"SH_GameItemView" owner:nil options:nil] lastObject];
        gameItemView.gameItemModel = dataArr[index];
        return gameItemView;
    }
}

#pragma mark - GamesListScrollViewDelegate M

- (void)gamesListScrollView:(SH_GamesListScrollView *)scrollView didSelectItem:(SH_GameItemModel *)model
{
    __weak typeof(self) weakSelf = self;
    
    self.currentGameItemModel = model;
    if (self.enterDZGameLevel == NO) {
        self.enterDZGameLevel = self.currentLevel == 0 && [self.currentGameItemModel.apiTypeId intValue] == 2;
    }
    
    if ([model.type isEqualToString:@"game"]) {
        if (![[RH_UserInfoManager shareUserManager] isLogin]) {
            [self login];
            return;
        }
        //进入游戏
        //先获取游戏的url
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [SH_NetWorkService fetchGameLink:model.gameLink complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
            //
            NSString *gameMsg = [[response objectForKey:@"data"] objectForKey:@"gameMsg"];
            if (IS_EMPTY_STRING(gameMsg)) {
                NSString *gameLink = [[response objectForKey:@"data"] objectForKey:@"gameLink"];
//                GameWebViewController *gameVC = [[GameWebViewController alloc] initWithNibName:@"GameWebViewController" bundle:nil];
                SH_WKGameViewController *gameVC = [[SH_WKGameViewController alloc] init];
                gameVC.url = gameLink;
                [weakSelf.navigationController pushViewController:gameVC animated:NO];
            }
            else
            {
                showErrorMessage([UIApplication sharedApplication].keyWindow, nil, gameMsg);
            }
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            showErrorMessage([UIApplication sharedApplication].keyWindow, nil, @"连接游戏失败");
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        }];
    }
    else
    {
        //进入下级页面
        self.currentLevel ++;
        if (self.enterDZGameLevel == YES && self.currentLevel == 2) {
            self.currentDZGameTypeId = self.currentGameItemModel.apiId;
            self.searchView.hidden = NO;
        }
        if (self.currentLevel == 1) {
            self.cycleAdView.hidden = YES;
            self.topGamesListScrollView.hidden = YES;
            self.midGamesListScrollView.hidden = NO;
            self.lastGamesListScrollView.hidden = YES;

            [self.midGamesListScrollView reloaData];
        }
        else if (self.currentLevel == 2)
        {
            self.cycleAdView.hidden = YES;
            self.topGamesListScrollView.hidden = YES;
            self.midGamesListScrollView.hidden = YES;
            self.lastGamesListScrollView.hidden = NO;

            [self.lastGamesListScrollView reloaData];
        }
    }
}

- (void)showNoAccess
{
    __weak typeof(self) weakSelf = self;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SH_NoAccessViewController *vc = [[SH_NoAccessViewController alloc] initWithNibName:@"SH_NoAccessViewController" bundle:nil];
        [weakSelf.navigationController pushViewController:vc animated:NO];
    });
}

@end

