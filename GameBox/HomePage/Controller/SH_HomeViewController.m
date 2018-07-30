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
#import "AlertViewController.h"
#import "SH_LoginView.h"
#import "SH_GamesListScrollView.h"
#import "SH_NetWorkService+Home.h"
#import "SH_HomeBannerModel.h"
#import "SH_RingManager.h"
#import "SH_RingButton.h"
#import "SH_GameItemModel.h"
#import "SH_GameItemView.h"
#import "SH_DZGameItemView.h"
#import "SH_UserInformationView.h"
#import "SH_NetWorkService+RegistAPI.h"
#import "SH_WKGameViewController.h"
#import "SH_NoAccessViewController.h"
#import "SH_PrifitOutCoinView.h"
#import "SH_NetWorkService+Profit.h"
#import "SH_ProfitModel.h"
#import "SH_AnnouncementView.h"
#import "YFAnimationManager.h"
#import "SH_GamesHomeViewController.h"
#import "SH_PromoDeatilViewController.h"
#import "SH_ShareView.h"
#import "SH_PromoListModel.h"
#import "UIImage+SH_WebPImage.h"
#import "SH_PromoWindowViewController.h"
#import "SH_WaitingView.h"
#import "SH_TimeZoneManager.h"

@interface SH_HomeViewController () <SH_CycleScrollViewDataSource, SH_CycleScrollViewDelegate, GamesListScrollViewDataSource, GamesListScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *avatarImg;
@property (weak, nonatomic) IBOutlet UILabel *userAccountLB;
@property (weak, nonatomic) IBOutlet UIButton *upLevelBT;
@property (weak, nonatomic) IBOutlet UIImageView *dzGameMarkImg;
@property (weak, nonatomic) IBOutlet UIImageView *runLBBGImg;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UIImageView *snowBGImg;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UILabel *suishenFuLiLab;

@property (strong, nonatomic) SH_CycleScrollView *cycleAdView;
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
@property (nonatomic, strong) NSMutableArray *searchResultArr;
@property (nonatomic, assign) BOOL isSearchStatus;
@property (nonatomic, strong) NSTimer *keepAliveTimer;

@property (nonatomic, strong) SH_GamesHomeViewController * vc;

@end

@implementation SH_HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.searchTF addTarget:self action:@selector(searchingTextChange:) forControlEvents:UIControlEventEditingChanged];

    [self dealTimeZone];
    [self fetchCookie];
    [self initAdScroll];
    [self refreshAnnouncement];
    [self refreshHomeInfo];
        
    [[YFAnimationManager shareInstancetype] showAnimationInView:self.snowBGImg withAnimationStyle:YFAnimationStyleOfSnow];

    [[NSNotificationCenter  defaultCenter] addObserver:self selector:@selector(didRegistratedSuccessful) name:@"didRegistratedSuccessful" object:nil];
    [[NSNotificationCenter  defaultCenter] addObserver:self selector:@selector(logoutAction) name:@"didLogOut" object:nil];
    if (iPhoneX) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(statusBarOrientationChange:)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:nil];
    }
    [self  configUI];
    [self  autoLoginIsRegist:false];
}

- (void)searchingTextChange:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) {
        self.isSearchStatus = NO;
        [self.lastGamesListScrollView reloaData];
    }
    else
    {
        self.isSearchStatus = YES;
    }
}

- (void)dealTimeZone
{
    //默认东八区
    [SH_NetWorkService fetchTimeZone:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (response && [response[@"code"] intValue] == 0) {
            [SH_TimeZoneManager sharedManager].timeZone = [response objectForKey:@"data"];
        }
        else
        {
            [SH_TimeZoneManager sharedManager].timeZone = @"GMT+08:00";
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        [SH_TimeZoneManager sharedManager].timeZone = @"GMT+08:00";
    }];
}

- (void)logoutAction
{
    [self.keepAliveTimer invalidate];
    self.keepAliveTimer = nil;
    [[RH_UserInfoManager  shareUserManager] updateIsLogin:NO];
    [[RH_UserInfoManager  shareUserManager] setMineSettingInfo:nil];
    [self configUI];
}

- (void)keepAlive
{
    [self.keepAliveTimer invalidate];
    self.keepAliveTimer = nil;

    self.keepAliveTimer = [NSTimer timerWithTimeInterval:5*60 target:self selector:@selector(refreshUserSessin) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.keepAliveTimer forMode:NSDefaultRunLoopMode];
    [self.keepAliveTimer fire];
}

- (void)refreshUserSessin
{
    [SH_NetWorkService refreshUserSessin:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSString *code = response[@"code"];
        if ([code isEqualToString:@"1001"]) {
            [[NSNotificationCenter  defaultCenter] postNotificationName:@"didLogOut" object:nil];
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if(vc.presentedViewController) {
                    [vc dismissViewControllerAnimated:NO completion:nil];
                }
            }
            [self login];
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        //
    }];
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
                                                                         LoginTime:[[SH_TimeZoneManager sharedManager] timeStringFrom:[[NSDate date] timeIntervalSince1970] format:@"yyyy-MM-dd HH:mm:ss"]] ;
                [self autoLoginSuccess:httpURLResponse isRegist:isRegist];
            }else{
                 [[RH_UserInfoManager  shareUserManager] updateIsLogin:false];
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
                                                                         LoginTime:[[SH_TimeZoneManager sharedManager] timeStringFrom:[[NSDate date] timeIntervalSince1970] format:@"yyyy-MM-dd HH:mm:ss"]];
                [self autoLoginSuccess:httpURLResponse isRegist:isRegist];
            }else{
                 [[RH_UserInfoManager  shareUserManager] updateIsLogin:false];
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
        if ([dict[@"code"] isEqualToString:@"0"]) {
            RH_MineInfoModel * model = [[RH_MineInfoModel alloc] initWithDictionary:[dict[@"data"] objectForKey:@"user"] error:nil];
            [[RH_UserInfoManager  shareUserManager] setMineSettingInfo:model];            
            [self  configUI];
        }else{
             [[RH_UserInfoManager  shareUserManager] updateIsLogin:false];
        }
        
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        //
        [[RH_UserInfoManager  shareUserManager] updateIsLogin:false];
    }];
    
    [self keepAlive];
}

#pragma mark - 更新用户信息

-(void)configUI{
    self.userAccountLB.text = [RH_UserInfoManager shareUserManager].mineSettingInfo.username?:@"登录/注册";
    
    if ([RH_UserInfoManager  shareUserManager].isLogin) {
        self.avatarImg.image = [UIImage imageWithWebPImageName:@"photo_male"];
        //刷新随身福利
        self.suishenFuLiLab.text = [NSString stringWithFormat:@"%.2f",[RH_UserInfoManager shareUserManager].mineSettingInfo.walletBalance];        
    }else{
        self.avatarImg.image = [UIImage imageWithWebPImageName:@"avatar"];
        self.suishenFuLiLab.text = @"0";
    }
}

- (NSMutableArray *)searchResultArr
{
    if (_searchResultArr == nil) {
        _searchResultArr = [NSMutableArray array];
    }
    return _searchResultArr;
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
    if (self.currentLevel == 0)
    {
        self.topGamesListScrollView.hidden = NO;
        self.midGamesListScrollView.hidden = YES;
        self.lastGamesListScrollView.hidden = YES;
    }
    else if (self.currentLevel == 1) {
        self.topGamesListScrollView.hidden = YES;
        self.midGamesListScrollView.hidden = NO;
        self.lastGamesListScrollView.hidden = YES;
    }
    else if (self.currentLevel == 2) {
        self.topGamesListScrollView.hidden = YES;
        self.midGamesListScrollView.hidden = YES;
        self.lastGamesListScrollView.hidden = NO;
    }

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
            self.dzGameMarkImg.image = [UIImage imageWithWebPImageName:@"logo12"];
        }
            break;
        case 35:
        {
            //MW电子
            self.dzGameMarkImg.image = [UIImage imageWithWebPImageName:@"logo11"];
        }
            break;
        case 15:
        {
            //HB电子
            self.dzGameMarkImg.image = [UIImage imageWithWebPImageName:@"logo07"];
        }
            break;
        case 26:
        {
            //PNG电子
            self.dzGameMarkImg.image = [UIImage imageWithWebPImageName:@"logo06"];
        }
            break;
        case 20:
        {
            //BSG电子
            self.dzGameMarkImg.image = [UIImage imageWithWebPImageName:@"logo03"];
        }
            break;
        case 27:
        {
            //DT电子
            self.dzGameMarkImg.image = [UIImage imageWithWebPImageName:@"logo10"];
        }
            break;
        case 6:
        {
            //PT电子
            self.dzGameMarkImg.image = [UIImage imageWithWebPImageName:@"logo04"];
        }
            break;
        case 25:
        {
            //新霸电子
            self.dzGameMarkImg.image = [UIImage imageWithWebPImageName:@"logo05"];
        }
            break;
        case 3:
        {
            //MG电子
            self.dzGameMarkImg.image = [UIImage imageWithWebPImageName:@"logo01"];
        }
            break;
        case 9:
        {
            //AG电子
            self.dzGameMarkImg.image = [UIImage imageWithWebPImageName:@"logo08"];
        }
            break;
        case 10:
        {
            //BB电子
            self.dzGameMarkImg.image = [UIImage imageWithWebPImageName:@"logo09"];
        }
            break;
        case 44:
        {
            //NT电子
            self.dzGameMarkImg.image = [UIImage imageWithWebPImageName:@"logo13"];
        }
            break;
        case 38:
        {
            //新PP电子
            self.dzGameMarkImg.image = [UIImage imageWithWebPImageName:@"logo02"];
        }
            break;
        case 45:
        {
            //PG老虎机
            self.dzGameMarkImg.image = [UIImage imageWithWebPImageName:@"logo14"];
        }
            break;
        case 14:
        {
            //NYX电子
            self.dzGameMarkImg.image = nil;//[UIImage imageWithWebPImageName:@""];
        }
            break;
        case 32:
        {
            //PP电子
            self.dzGameMarkImg.image = [UIImage imageWithWebPImageName:@"logo02"];
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
    self.isSearchStatus = NO;
    self.searchTF.text = @"";
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
    __weak typeof(self) weakSelf = self;

    SH_LoginView *login = [SH_LoginView InstanceLoginView];
    AlertViewController * cvc = [[AlertViewController  alloc] initAlertView:login viewHeight:[UIScreen mainScreen].bounds.size.height-60 titleImageName:@"title01" alertViewType:AlertViewTypeLong];
    login.targetVC = cvc;
    login.dismissBlock = ^{
        [cvc  close];
        [self  configUI];
    };
    login.changeChannelBlock = ^(NSString *string) {
      [cvc setImageName:string];
        
    };
    login.loginSuccessBlock = ^{
        //登录成功后每5分钟调用一次保活接口
        [weakSelf keepAlive];
    };
    [self presentViewController:cvc addTargetViewController:self];
}

- (IBAction)welfareClick:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"尚未开放，敬请期待" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}

- (IBAction)searchAction:(id)sender {
    [self.searchResultArr removeAllObjects];
    if ([[self.searchTF.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        return;
    }
    
    for (SH_GameItemModel *gameItemModel in self.currentGameItemModel.relation) {
        if ([gameItemModel.name containsString:self.searchTF.text]) {
            [self.searchResultArr addObject:gameItemModel];
        }
    }
    
    [self.lastGamesListScrollView reloaData];
}

#pragma mark--
#pragma mark--一键回收按钮
- (IBAction)oneKeyReciveBtnClick:(id)sender {
    if (![RH_UserInfoManager  shareUserManager].isLogin) {
        [self login];
        return;
    }
      __weak typeof(self) weakSelf = self;
    [SH_NetWorkService onekeyrecoveryApiId:nil Success:^(NSHTTPURLResponse *httpURLResponse, id response) {
        //刷新用户余额
        if (![[response objectForKey:@"data"] isKindOfClass:[NSNull class]]) {
            weakSelf.suishenFuLiLab.text = response[@"data"][@"assets"];
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
}

#pragma mark - 个人设置

- (IBAction)avatarClick:(id)sender {
    if (![RH_UserInfoManager  shareUserManager].isLogin) {
        [self login];
        return;
    }
    SH_UserInformationView * inforView = [SH_UserInformationView  instanceInformationView];
    AlertViewController * cvc = [[AlertViewController  alloc] initAlertView:inforView viewHeight:204 titleImageName:@"title04" alertViewType:AlertViewTypeShort];
    inforView.vc = cvc;
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
    if (![RH_UserInfoManager  shareUserManager].isLogin) {
        [self login];
        return;
    }
    SH_PromoWindowViewController *vc = [[SH_PromoWindowViewController alloc] initWithNibName:@"SH_PromoWindowViewController" bundle:nil];
    [self presentViewController:vc addTargetViewController:self];
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
    if (![[RH_UserInfoManager shareUserManager] isLogin]) {
        [self login];
        return;
    }
    SH_PrifitOutCoinView *view = [[NSBundle mainBundle]loadNibNamed:@"SH_PrifitOutCoinView" owner:nil options:nil].lastObject;
    AlertViewController *acr  = [[AlertViewController  alloc] initAlertView:view viewHeight:[UIScreen mainScreen].bounds.size.height-75 titleImageName:@"title07" alertViewType:AlertViewTypeLong];
    acr.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    acr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:acr animated:YES completion:nil];
    [SH_NetWorkService getBankInforComplete:^(SH_ProfitModel *model) {
        [view updateUIWithBalance:model.totalBalance BankNum:[model.bankcardMap objectForKey:@"1"][@"bankcardNumber"] TargetVC:acr Token:model.token];
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
}

#pragma mark --- 玩家中心

//玩家中心
- (IBAction)userCenterClick:(id)sender
{
    
    [SH_NetWorkService refreshUserSessin:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSString *code = response[@"code"];
        if ([code isEqualToString:@"1001"]) {
            
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
    
    if ([RH_UserInfoManager shareUserManager].isLogin) {
         self.vc = [SH_GamesHomeViewController new];
        
        [self presentViewController:self.vc addTargetViewController:self];
    }else{
        [self login];
    }
   
    
   
}

#pragma mark - SH_PlayerCenterViewDelegate


- (IBAction)shareClick:(id)sender {
    if ([RH_UserInfoManager shareUserManager].isLogin) {
          SH_ShareView * share = [SH_ShareView instanceShareView];
        AlertViewController *vc  = [[AlertViewController  alloc] initAlertView:share viewHeight:260 titleImageName:@"title08" alertViewType:AlertViewTypeShort];
        share.targetVC = vc;
        [self presentViewController:vc addTargetViewController:self];
    }else{
        [self login];
    }
    
  
    
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
    UIInterfaceOrientation oriention = [UIApplication sharedApplication].statusBarOrientation;
    [_cycleAdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(oriention == UIInterfaceOrientationLandscapeLeft ? 18 : (iPhoneX ? 18+30 : 18));
        make.top.mas_equalTo(self.topGamesListScrollView.mas_top);
        make.bottom.mas_equalTo(self.topGamesListScrollView.mas_bottom);
        make.height.mas_equalTo(self->_cycleAdView.mas_width).multipliedBy(224/190.0);
        make.right.equalTo(self.topGamesListScrollView.mas_left).mas_offset(-10);
    }];
}

- (SH_GamesListScrollView *)topGamesListScrollView
{
    if (_topGamesListScrollView == nil) {
        _topGamesListScrollView = [[SH_GamesListScrollView alloc] init];
        _topGamesListScrollView.dataSource = self;
        _topGamesListScrollView.delegate = self;
        [self.view addSubview:_topGamesListScrollView];
        UIInterfaceOrientation oriention = [UIApplication sharedApplication].statusBarOrientation;

        [_topGamesListScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.cycleAdView.mas_right).mas_offset(10);
            make.top.mas_equalTo(80);
            make.bottom.mas_equalTo(-53.5);
            make.right.mas_equalTo(oriention == UIInterfaceOrientationLandscapeLeft ? (iPhoneX ? -30 : 0) : 0);
        }];
    }
    return _topGamesListScrollView;
}

- (SH_GamesListScrollView *)midGamesListScrollView
{
    if (_midGamesListScrollView == nil) {
        _midGamesListScrollView = [[SH_GamesListScrollView alloc] init];
        _midGamesListScrollView.hidden = YES;
        _midGamesListScrollView.dataSource = self;
        _midGamesListScrollView.delegate = self;
        [self.view addSubview:_midGamesListScrollView];
        UIInterfaceOrientation oriention = [UIApplication sharedApplication].statusBarOrientation;
        [_midGamesListScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(oriention == UIInterfaceOrientationLandscapeLeft ? 0 : (iPhoneX ? 30 : 0));
            make.top.mas_equalTo(80);
            make.bottom.mas_equalTo(-53.5);
            make.right.mas_equalTo(oriention == UIInterfaceOrientationLandscapeLeft ? (iPhoneX ? -30 : 0) : 0);
        }];
    }
    return _midGamesListScrollView;
}

- (SH_GamesListScrollView *)lastGamesListScrollView
{
    if (_lastGamesListScrollView == nil) {
        _lastGamesListScrollView = [[SH_GamesListScrollView alloc] init];
        _lastGamesListScrollView.hidden = YES;
        _lastGamesListScrollView.dataSource = self;
        _lastGamesListScrollView.delegate = self;
        [self.view addSubview:_lastGamesListScrollView];
        UIInterfaceOrientation oriention = [UIApplication sharedApplication].statusBarOrientation;
        [_lastGamesListScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(oriention == UIInterfaceOrientationLandscapeLeft ? 0 : (iPhoneX ? 30 : 0));
            make.top.mas_equalTo(80);
            make.bottom.mas_equalTo(-53.5);
            make.right.mas_equalTo(oriention == UIInterfaceOrientationLandscapeLeft ? (iPhoneX ? -30 : 0) : 0);
        }];
    }
    return _lastGamesListScrollView;
}

- (void)refreshHomeInfo
{
    __weak typeof(self) weakSelf = self;
    
    [SH_WaitingView showOn:self.view];
    [SH_NetWorkService fetchHomeInfo:^(NSHTTPURLResponse *httpURLResponse, id response) {
        [weakSelf.bannerArr removeAllObjects];
        [weakSelf.siteApiRelationArr removeAllObjects];

        if (response && [[response objectForKey:@"code"] intValue] == 0) {
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
        [SH_WaitingView hide:weakSelf.view];
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        if (httpURLResponse.statusCode == 605) {
            [weakSelf showNoAccess];
        }
        [SH_WaitingView hide:weakSelf.view];
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
    return [UIImage imageWithWebPImageName:@"banner"];
}

- (UIImage *)placeHolderImageOfZeroBannerView {
    return [UIImage imageWithWebPImageName:@"banner"];
}

#pragma mark - SH_CycleScrollViewDelegate

- (void)cycleScrollView:(SH_CycleScrollView *)scrollView didScrollToIndex:(NSUInteger)index
{}

- (void)cycleScrollView:(SH_CycleScrollView *)scorllView didSelectedAtIndex:(NSUInteger)index
{}

#pragma mark - SH_WelfareViewDelegate
- (void)welfareViewDisappear
{
//    [self.welfareV removeFromSuperview];
}

#pragma mark - GamesListScrollViewDataSource M

- (NSInteger)numberOfItemsOfGamesListScrollView:(SH_GamesListScrollView *)scrollView
{
    if (self.currentLevel == 0) {
        return self.siteApiRelationArr.count;
    }
    else
    {
        if (self.isSearchStatus) {
            return self.searchResultArr.count;
        }
        else
        {
            return self.currentGameItemModel.relation.count;
        }
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
        if (self.isSearchStatus) {
            dataArr = self.searchResultArr;
        }
        else
        {
            dataArr = [NSMutableArray arrayWithArray:self.currentGameItemModel.relation];
        }
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
        if ([[RH_UserInfoManager shareUserManager] isLogin]) {
            [SH_WaitingView showOn:self.view];
            [SH_NetWorkService fetchGameLink:model.gameLink complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
                NSString *gameMsg = [[response objectForKey:@"data"] objectForKey:@"gameMsg"];
                if (IS_EMPTY_STRING(gameMsg)) {
                    NSString *gameLink = [[response objectForKey:@"data"] objectForKey:@"gameLink"];
                    SH_WKGameViewController *gameVC = [[SH_WKGameViewController alloc] init];
                    gameVC.url = gameLink;
                    [weakSelf.navigationController pushViewController:gameVC animated:NO];
                }
                else
                {
                    showErrorMessage([UIApplication sharedApplication].keyWindow, nil, gameMsg);
                }
                [SH_WaitingView hide:weakSelf.view];
            } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
                showErrorMessage([UIApplication sharedApplication].keyWindow, nil, @"连接游戏失败");
                [SH_WaitingView hide:weakSelf.view];
            }];
        }else{
            [self login];
        }
        
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

- (void)statusBarOrientationChange:(NSNotification *)notification
{
    UIInterfaceOrientation oriention = [UIApplication sharedApplication].statusBarOrientation;
    if (oriention == UIInterfaceOrientationLandscapeLeft) {
        [self.cycleAdView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(18);
            make.top.mas_equalTo(self.topGamesListScrollView.mas_top);
            make.bottom.mas_equalTo(self.topGamesListScrollView.mas_bottom);
            make.height.mas_equalTo(self->_cycleAdView.mas_width).multipliedBy(224/190.0);
            make.right.equalTo(self.topGamesListScrollView.mas_left).mas_offset(-10);
        }];

        [self.topGamesListScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.cycleAdView.mas_right).mas_offset(10);
            make.top.mas_equalTo(80);
            make.bottom.mas_equalTo(-53.5);
            make.right.mas_equalTo(iPhoneX ? -30 : 0);
        }];
        
        [self.midGamesListScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(80);
            make.bottom.mas_equalTo(-53.5);
            make.right.mas_equalTo(iPhoneX ? -30 : 0);
        }];
        
        [self.lastGamesListScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(80);
            make.bottom.mas_equalTo(-53.5);
            make.right.mas_equalTo(iPhoneX ? -30 : 0);
        }];
    }
    else if (oriention == UIInterfaceOrientationLandscapeRight)
    {
        [self.cycleAdView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iPhoneX ? 18+30 : 18);
            make.top.mas_equalTo(self.topGamesListScrollView.mas_top);
            make.bottom.mas_equalTo(self.topGamesListScrollView.mas_bottom);
            make.height.mas_equalTo(self->_cycleAdView.mas_width).multipliedBy(224/190.0);
            make.right.equalTo(self.topGamesListScrollView.mas_left).mas_offset(-10);
        }];
        
        [self.topGamesListScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.cycleAdView.mas_right).offset(10);
            make.top.mas_equalTo(80);
            make.bottom.mas_equalTo(-53.5);
            make.right.mas_equalTo(0);
        }];
        
        [self.midGamesListScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iPhoneX ? 30 : 0);
            make.top.mas_equalTo(80);
            make.bottom.mas_equalTo(-53.5);
            make.right.mas_equalTo(0);
        }];
        
        [self.lastGamesListScrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iPhoneX ? 30 : 0);
            make.top.mas_equalTo(80);
            make.bottom.mas_equalTo(-53.5);
            make.right.mas_equalTo(0);
        }];
    }
}
@end

