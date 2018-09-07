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
#import "SH_UpdatedVersionModel.h"
#import "RH_WebsocketManagar.h"
#import "SH_BigWindowViewController.h"
#import "SH_SmallWindowViewController.h"
#import "SH_NetWorkService+SaftyCenter.h"
#import "SH_WelfareWarehouse.h"
#import "SH_MaintainViewController.h"
#import "SH_NoAccessViewController.h"
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
@property (nonatomic, strong) SH_GameItemModel *localSearchGameModel;
@property (nonatomic, assign) int currentLevel;
@property (nonatomic, strong) NSString *currentDZGameTypeId;
@property (nonatomic, assign) BOOL enterDZGameLevel;
@property (nonatomic, strong) SH_AnnouncementView *announcementView;
@property (nonatomic, strong) NSMutableArray *searchResultArr;
@property (nonatomic, assign) BOOL isSearchStatus;
@property (nonatomic, strong) NSTimer *keepAliveTimer;

@property (nonatomic, strong) SH_GamesHomeViewController * vc;
@property (nonatomic, strong) SH_BigWindowViewController *acr;

@end

@implementation SH_HomeViewController

-(void)viewWillAppear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"" forKey:@"saftyKoken"];
    [defaults synchronize];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configSearchTF];
    [self dealTimeZone];
    [self fetchCookie];
    [self initAdScroll];
    [self refreshAnnouncement];
    [self refreshHomeInfo];
    [self checkUpdate];

    [[YFAnimationManager shareInstancetype] showAnimationInView:self.snowBGImg withAnimationStyle:YFAnimationStyleOfSnow];

    [[NSNotificationCenter  defaultCenter] addObserver:self selector:@selector(didRegistratedSuccessful) name:@"didRegistratedSuccessful" object:nil];
    [[NSNotificationCenter  defaultCenter] addObserver:self selector:@selector(refreshBalance) name:@"refreshBalance" object:nil];
    [[NSNotificationCenter  defaultCenter] addObserver:self selector:@selector(didLoginSuccess) name:@"SH_LOGIN_SUCCESS" object:nil];
    [[NSNotificationCenter  defaultCenter] addObserver:self selector:@selector(logoutAction) name:@"didLogOut" object:nil];
    [[NSNotificationCenter  defaultCenter] addObserver:self selector:@selector(close) name:@"close" object:nil];
    [[NSNotificationCenter  defaultCenter] addObserver:self selector:@selector(configUI) name:@"configUI" object:nil];
    if (iPhoneX) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(statusBarOrientationChange:)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:nil];
    }
    [self  configUI];
    [self  autoLoginIsRegist:false];
}
-(void)refreshBalance {
    [self  configUI];
}
- (void)configSearchTF
{
    NSString *holderText = @"搜索游戏";
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholder addAttribute:NSForegroundColorAttributeName
                        value:colorWithRGB(170, 170, 170)
                        range:NSMakeRange(0, holderText.length)];
    [placeholder addAttribute:NSFontAttributeName
                        value:[UIFont boldSystemFontOfSize:12]
                        range:NSMakeRange(0, holderText.length)];
    self.searchTF.attributedPlaceholder = placeholder;
    [self.searchTF addTarget:self action:@selector(searchingTextChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)searchingTextChange:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) {
//        self.isSearchStatus = NO;
        [self.searchResultArr removeAllObjects];
        [self.searchResultArr addObjectsFromArray:self.localSearchGameModel.relation];
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

    //每五分钟调用一次保活
    self.keepAliveTimer = [NSTimer timerWithTimeInterval:5*60 target:self selector:@selector(refreshUserSessin) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.keepAliveTimer forMode:NSDefaultRunLoopMode];
}

- (void)refreshUserSessin
{
    [SH_NetWorkService refreshUserSessin:^(NSHTTPURLResponse *httpURLResponse, id response) {
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        //
    }];
}

- (void)checkUpdate
{
    __weak typeof(self) weakSelf = self;

    [SH_NetWorkService checkVersionUpdate:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (httpURLResponse.statusCode == 607) {
            SH_MaintainViewController *maintain = [[SH_MaintainViewController alloc] init];
            [self.navigationController pushViewController:maintain animated:NO];
        } else if (httpURLResponse.statusCode == 605) {
            SH_NoAccessViewController *noAccess = [[SH_NoAccessViewController alloc] init];
            [self.navigationController pushViewController:noAccess animated:NO];
        }else  if (response) {
            NSError *err;
            SH_UpdatedVersionModel *updatedVersionModel = [[SH_UpdatedVersionModel alloc] initWithDictionary:response error:&err];
            if(updatedVersionModel.versionCode <= [GB_CURRENT_APPBUILD integerValue]&&updatedVersionModel.forceVersion <= [GB_CURRENT_APPBUILD integerValue]){
                //本地版本号和强制更新版本号都小于当前版本号 则 直接跳过
                //跳过
            }
            else if (updatedVersionModel.versionCode>[GB_CURRENT_APPBUILD integerValue]&&updatedVersionModel.forceVersion <= [GB_CURRENT_APPBUILD integerValue])
            {
                //本地版本号比线上版本号要小 且
                //本地版本号大于强制更新版本号
                //需要弹框 但可以跳过
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"发现新版本啦" message:updatedVersionModel.memo preferredStyle:UIAlertControllerStyleAlert];
                
                NSMutableAttributedString *messageText = [[NSMutableAttributedString alloc] initWithString:updatedVersionModel.memo];
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                paragraphStyle.alignment = NSTextAlignmentLeft;
                [messageText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, updatedVersionModel.memo.length)];
                [alert setValue:messageText forKey:@"attributedMessage"];
                
                UIAlertAction *downLoadAction = [UIAlertAction actionWithTitle:@"下载更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSString *downLoadIpaUrl = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=https://%@%@/%@/app_%@_%@.plist",updatedVersionModel.appUrl,updatedVersionModel.versionName,CODE,CODE,updatedVersionModel.versionName];
                    NSURL *ipaUrl = [NSURL URLWithString:[downLoadIpaUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    [[UIApplication sharedApplication] openURL:ipaUrl];
                    exit(0);
                }];
                [alert addAction:downLoadAction];

                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"忽略更新" style:UIAlertActionStyleCancel handler:nil];
                [alert addAction:cancelAction];

                [weakSelf presentViewController:alert animated:YES completion:nil];
            }
            else if (updatedVersionModel.versionCode > [GB_CURRENT_APPBUILD integerValue] && updatedVersionModel.forceVersion > [GB_CURRENT_APPBUILD integerValue])
            {
                //本地版本号小于线上版本号 且
                //本地版本号小于线上强制更新版本号
                //需要弹框 不能跳过

                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"发现新版本啦" message:updatedVersionModel.memo preferredStyle:UIAlertControllerStyleAlert];
                
                NSMutableAttributedString *messageText = [[NSMutableAttributedString alloc] initWithString:updatedVersionModel.memo];
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                paragraphStyle.alignment = NSTextAlignmentLeft;
                [messageText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, updatedVersionModel.memo.length)];
                [alert setValue:messageText forKey:@"attributedMessage"];
                
                UIAlertAction *downLoadAction = [UIAlertAction actionWithTitle:@"下载更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSString *downLoadIpaUrl = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=https://%@%@/%@/app_%@_%@.plist",updatedVersionModel.appUrl,updatedVersionModel.versionName,CODE,CODE,updatedVersionModel.versionName];
                    NSURL *ipaUrl = [NSURL URLWithString:[downLoadIpaUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    [[UIApplication sharedApplication] openURL:ipaUrl];
                    exit(0);
                }];
                [alert addAction:downLoadAction];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    exit(0);
                }];
                [alert addAction:cancelAction];
                [weakSelf presentViewController:alert animated:YES completion:nil];
            }
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
    [[NetWorkLineMangaer sharedManager] configCookieAndSid:httpURLResponse];

    [[RH_UserInfoManager  shareUserManager] updateIsLogin:YES];
    [SH_NetWorkService fetchUserInfo:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary * dict = ConvertToClassPointer(NSDictionary, response);
        if ([dict[@"code"] isEqualToString:@"0"]) {
            NSError *err;
            NSArray *arr = [SH_BankListModel arrayOfModelsFromDictionaries:response[@"data"][@"bankList"] error:&err];
            [[RH_UserInfoManager shareUserManager] setBankList:arr];
            NSError *err2;
            RH_MineInfoModel * model = [[RH_MineInfoModel alloc] initWithDictionary:[response[@"data"] objectForKey:@"user"] error:&err2];
            [[RH_UserInfoManager  shareUserManager] setMineSettingInfo:model];

            [self  configUI];
             [[RH_WebsocketManagar instance] SRWebSocketOpenWithURLString:[NetWorkLineMangaer sharedManager].currentPreUrl];
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
    self.userAccountLB.text = [RH_UserInfoManager shareUserManager].mineSettingInfo.username?:@"请先登录";
    
    if ([RH_UserInfoManager  shareUserManager].isLogin) {
        if ([RH_UserInfoManager shareUserManager].mineSettingInfo.userSex.length > 0) {
            if ([[RH_UserInfoManager shareUserManager].mineSettingInfo.userSex isEqualToString:@"male"]) {
                self.avatarImg.image = [UIImage imageWithWebPImageName:@"photo_male"];
            } else  if ([[RH_UserInfoManager shareUserManager].mineSettingInfo.userSex isEqualToString:@"female"]){
                self.avatarImg.image = [UIImage imageWithWebPImageName:@"photo_female"];
            } else {
                self.avatarImg.image = [UIImage imageWithWebPImageName:@"photo_male"];
            }
        } else {
            self.avatarImg.image = [UIImage imageWithWebPImageName:@"photo_male"];
        }
        //刷新随身福利
        self.suishenFuLiLab.text = [NSString stringWithFormat:@"%.2f",[RH_UserInfoManager shareUserManager].mineSettingInfo.walletBalance];        
    }else{
        self.avatarImg.image = [UIImage imageWithWebPImageName:@"visitor"];
        self.suishenFuLiLab.text = @"0.00";
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

- (IBAction)upToLastLevel:(SH_WebPButton *)sender {
    [sender setScale];
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
    [SH_NetWorkService fetchHttpCookie:^(NSHTTPURLResponse *httpURLResponse, id response) {
        [[NetWorkLineMangaer sharedManager] configCookieAndSid:httpURLResponse];
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
    }];
}

#pragma mark - 用户登录

-(void)login{
    SH_LoginView *login = [SH_LoginView InstanceLoginView];
    
    SH_BigWindowViewController *vc = [[SH_BigWindowViewController alloc] initWithNibName:@"SH_BigWindowViewController" bundle:nil];
    vc.titleImageName = @"title01";
    vc.customView = login;
    login.dismissBlock = ^{
        [vc close:nil];
        [self configUI];
    };
    login.changeChannelBlock = ^(NSString *string) {
        vc.titleImageName = string;
    };

    [self presentViewController:vc addTargetViewController:self];
}

- (IBAction)welfareClick:(SH_WebPButton *)sender {
    [sender setScale];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"尚未开放，敬请期待" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    
//    if (![[RH_UserInfoManager shareUserManager] isLogin]) {
//        [self login];
//        return;
//    }
//    SH_WelfareWarehouse *view = [[NSBundle mainBundle]loadNibNamed:@"SH_WelfareWarehouse" owner:nil options:nil].lastObject;
//    self.acr = [SH_BigWindowViewController new];
//    self.acr.titleImageName = @"title06";
//    self.acr.customView = view;
//    self.acr.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    self.acr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [self presentViewController:self.acr animated:YES completion:nil];
    
}

- (IBAction)searchAction:(id)sender {
    [self.searchResultArr removeAllObjects];
    if ([[self.searchTF.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        return;
    }
    
    for (SH_GameItemModel *gameItemModel in self.localSearchGameModel.relation) {
        if ([gameItemModel.name containsString:self.searchTF.text]) {
            [self.searchResultArr addObject:gameItemModel];
        }
    }
    
    [self.lastGamesListScrollView reloaData];
}

#pragma mark--
#pragma mark--一键回收按钮
- (IBAction)oneKeyReciveBtnClick:(id)sender {
    [self recoveryAndRefreshUserInfo:nil];
}

- (void)recoveryAndRefreshUserInfo:(NSString *)apiId
{
    __weak typeof(self) weakSelf = self;
    [SH_NetWorkService onekeyrecoveryApiId:apiId Success:^(NSHTTPURLResponse *httpURLResponse, id response) {
        [SH_NetWorkService fetchUserInfo:^(NSHTTPURLResponse *httpURLResponse, id response) {
            if ([response[@"code"] isEqualToString:@"0"]) {
                NSError *err;
                NSArray *arr = [SH_BankListModel arrayOfModelsFromDictionaries:response[@"data"][@"bankList"] error:&err];
                [[RH_UserInfoManager shareUserManager] setBankList:arr];
                NSError *err2;
                RH_MineInfoModel * model = [[RH_MineInfoModel alloc] initWithDictionary:[response[@"data"] objectForKey:@"user"] error:&err2];
                [[RH_UserInfoManager  shareUserManager] setMineSettingInfo:model];
                [weakSelf  configUI];
                weakSelf.suishenFuLiLab.text = [NSString stringWithFormat:@"%.2f",model.walletBalance];
            }else{
                [[RH_UserInfoManager  shareUserManager] updateIsLogin:false];
            }
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            //
            [[RH_UserInfoManager shareUserManager] updateIsLogin:false];
        }];
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
    SH_SmallWindowViewController *cvc = [[SH_SmallWindowViewController alloc] initWithNibName:@"SH_SmallWindowViewController" bundle:nil];
    cvc.titleImageName = @"title04";
    cvc.customView = inforView;
    cvc.contentHeight = 204;
    [self presentViewController:cvc addTargetViewController:self];
}
#pragma mark --- 模态弹出viewController
-(void)presentViewController:(UIViewController*)viewController addTargetViewController:(UIViewController*)targetVC{
    viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    viewController.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    [targetVC presentViewController:viewController animated:YES completion:nil];
}

#pragma mark - 优惠活动
- (IBAction)activitiesClick:(SH_WebPButton *)sender {
    [sender setScale];
    if (![RH_UserInfoManager  shareUserManager].isLogin) {
        [self login];
        return;
    }
    SH_PromoWindowViewController *vc = [[SH_PromoWindowViewController alloc] initWithNibName:@"SH_PromoWindowViewController" bundle:nil];
   

    [self presentViewController:vc addTargetViewController:self];
}

#pragma mark--
#pragma mark--充值中心

- (IBAction)recharegeBtnClick:(SH_WebPButton *)sender {
    [sender setScale];
    if (![[RH_UserInfoManager shareUserManager] isLogin]) {
        [self login];
        return;
    }
    [self.navigationController pushViewController:[[SH_RechargeCenterViewController alloc]init] animated:YES];
    
}
#pragma mark--
#pragma mark--收益按钮
- (IBAction)profitBtnClick:(SH_WebPButton *)sender {
    [sender setScale];
    if (![[RH_UserInfoManager shareUserManager] isLogin]) {
        [self login];
        return;
    }
    SH_PrifitOutCoinView *view = [[NSBundle mainBundle]loadNibNamed:@"SH_PrifitOutCoinView" owner:nil options:nil].lastObject;
    self.acr = [SH_BigWindowViewController new];
//    self.acr.view.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.acr.titleImageName = @"title07";
    self.acr.customView = view;
    self.acr.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.acr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:self.acr animated:YES completion:nil];
    [SH_NetWorkService getBankInforComplete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary * dict = ConvertToClassPointer(NSDictionary, response);
        // ts333 账号返回的是json字符串 ，所以判断下
        if (dict) {
            NSDictionary *dic = [(NSDictionary *)response objectForKey:@"data"];
            SH_ProfitModel *model = [[SH_ProfitModel alloc]initWithDictionary:dic error:nil];
            NSString *code = response[@"code"];
            NSString *message = response[@"message"];
            [self refreshBalance:model.totalBalance];
            [view updateUIWithBalance:model BankNum:[model.bankcardMap objectForKey:@"1"][@"bankcardNumber"] TargetVC:nil Token:model.token Code:code Message:message];
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
}

-(void)refreshBalance: (NSString *)balance {
    if (![self.suishenFuLiLab.text isEqualToString:balance]) {
        self.suishenFuLiLab.text =  [NSString stringWithFormat:@"%.2f",[balance floatValue]];
    }
}

-(void) close {
    [self.acr close:nil];
}

#pragma mark --- 玩家中心

//玩家中心
- (IBAction)userCenterClick:(SH_WebPButton *)sender
{
    [sender setScale];
    if ([RH_UserInfoManager shareUserManager].isLogin) {
         self.vc = [SH_GamesHomeViewController new];
        //这里用户要请求有没有设置过安全密码接口
        [SH_NetWorkService initUserSaftyInfoSuccess:^(NSHTTPURLResponse *httpURLResponse, id response) {
            if (![response[@"data"] isKindOfClass:[NSNull class]]) {
                NSError *err;
                RH_UserSafetyCodeModel *model = [[RH_UserSafetyCodeModel alloc]initWithDictionary:response[@"data"] error:&err];
                //更新安全模块
                [[RH_UserInfoManager shareUserManager] setUserSafetyInfo:model];
            }
        } Fail:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            
        }];
        [self presentViewController:self.vc addTargetViewController:self];
    }else{
        [self login];
    }
}

- (IBAction)shareClick:(SH_WebPButton *)sender {
    [sender setScale];
    if ([RH_UserInfoManager shareUserManager].isLogin) {
          SH_ShareView * share = [SH_ShareView instanceShareView];
        SH_SmallWindowViewController * vc = [SH_SmallWindowViewController new];
        vc.contentHeight = 260;
        vc.titleImageName = @"title08";
        vc.customView = share;
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
        make.top.mas_equalTo([UIScreen mainScreen].bounds.size.height/4.2);
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
            make.top.mas_equalTo(85);
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
            make.top.mas_equalTo(85);
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
            make.top.mas_equalTo(85);
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
    [self updateUserInfo];
}

-(void)updateUserInfo {
    [SH_NetWorkService fetchUserInfo:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if ([response[@"code"] isEqualToString:@"0"]) {
            NSError *err;
            NSArray *arr = [SH_BankListModel arrayOfModelsFromDictionaries:response[@"data"][@"bankList"] error:&err];
            [[RH_UserInfoManager shareUserManager] setBankList:arr];
            NSError *err2;
            RH_MineInfoModel * model = [[RH_MineInfoModel alloc] initWithDictionary:[response[@"data"] objectForKey:@"user"] error:&err2];
            [[RH_UserInfoManager  shareUserManager] setMineSettingInfo:model];
        }else{
            [[RH_UserInfoManager  shareUserManager] updateIsLogin:false];
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        //
        [[RH_UserInfoManager shareUserManager] updateIsLogin:false];
    }];
}

- (void)didLoginSuccess
{
    //登录成功后每5分钟调用一次保活接口
    [self configUI];
    [self keepAlive];
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
    if (![model.type isEqualToString:@"game"]) {
        self.localSearchGameModel = model;
    }
    self.currentGameItemModel = model;
    if (self.enterDZGameLevel == NO) {
        self.enterDZGameLevel = self.currentLevel == 0 && [self.currentGameItemModel.apiTypeId intValue] == 2;
    }
    
    if ([model.type isEqualToString:@"game"]) {
        //进入游戏
        //先获取游戏的url
        if ([[RH_UserInfoManager shareUserManager] isLogin]) {
            [SH_WaitingView showOn:self.view];
            [SH_NetWorkService fetchGameLink:model.gameLink complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
                NSString *gameMsg = [[response objectForKey:@"data"] objectForKey:@"gameMsg"];
                if (IS_EMPTY_STRING(gameMsg)) {
                    //先关闭背景BGM
                    [[SH_RingManager sharedManager] pauseBGM];
                    
                    NSString *gameLink = [[response objectForKey:@"data"] objectForKey:@"gameLink"];
                    SH_WKGameViewController *gameVC = [[SH_WKGameViewController alloc] init];
                    gameVC.url = gameLink;
                    [gameVC close:^{
                        [[SH_RingManager sharedManager] playBGM];
                        [weakSelf recoveryAndRefreshUserInfo:model.apiId];
                    }];
                    [weakSelf.navigationController pushViewController:gameVC animated:NO];
                }
                else
                {
                    showErrorMessage([UIApplication sharedApplication].keyWindow, nil, gameMsg);
                }
                [SH_WaitingView hide:weakSelf.view];
            } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
                showErrorMessage([UIApplication sharedApplication].keyWindow, nil, err);
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

