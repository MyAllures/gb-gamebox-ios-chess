//
//  RH_UserInfoManager.m
//  TaskTracking
//
//  Created by apple pro on 2017/2/19.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "RH_UserInfoManager.h"
#import "CLDocumentCachePool.h"
#import "MacroDef.h"
//#import "RH_ServiceRequest.h"
//#import "coreLib.h"
//#import "RH_APPDelegate.h"
#import "SAMKeychain.h"

#define  key_languageOption                             @"appLanguage"
#define  key_voiceSwitchFlag                             @"key_voiceSwitchFlag"
#define  key_screenlockFlag                              @"key_screenlockFlag"
#define  key_screenlockPassword                          @"key_screenlockPassword"
#define  key_lastLoginUserName                           @"key_lastLoginUserName"
#define  key_lastLoginTime                               @"key_lastLoginTime"
#define  key_updateUserVeifyCode                         @"key_updateUserVeifyCode"

@interface RH_UserInfoManager ()

@property(nonatomic,copy)  AutoLoginCompletation autoLoginCompletation ;
@property(nonatomic,strong) id netStatusObserverForUpdateUserSessionInfo ;
@end

@implementation RH_UserInfoManager

@synthesize userSafetyInfo = _userSafetyInfo ;
@synthesize mineSettingInfo = _mineSettingInfo ;
//@synthesize bankList = _bankList ;
//@synthesize userWithDrawInfo = _userWithDrawInfo ;
@synthesize domainCheckErrorList = _domainCheckErrorList ;
@synthesize sidString = _sidString ;
@synthesize updateUserVeifyCode = _updateUserVeifyCode ;
@synthesize isSetSafetySecertPwd = _isSetSafetySecertPwd ;
@synthesize isBindBitCoin = _isBindBitCoin ;

+(instancetype)shareUserManager
{
    static RH_UserInfoManager * _shareUserManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareUserManager = [[RH_UserInfoManager alloc] init];
        
    });
    
    return _shareUserManager ;
}

-(instancetype)init
{
    self = [super init] ;
    if (self){
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(handleLoginChangedNotification:)
//                                                     name:NT_LoginStatusChangedNotification
//                                                   object:nil] ;
    }
    
    return self ;
}

-(void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self] ;
}

/*
#pragma mark -
-(void)handleLoginChangedNotification:(NSNotification*)nt
{
    if ([nt.name isEqualToString:NT_LoginStatusChangedNotification]){
        [self updateSession] ;
    }
}

-(void)updateSession
{
    if (NetworkAvailable()){
        if ([self hasLogin]){
            //取消先前服务
            [self.serviceRequest cancleServiceWithType:ServiceRequestTypeV3RefreshSession] ;
            [self.serviceRequest startV3RereshUserSessin] ;
        }
    }else{//无网络情况
        if (!self.netStatusObserverForUpdateUserSessionInfo){
            self.netStatusObserverForUpdateUserSessionInfo = [[NSNotificationCenter defaultCenter] addObserverForName:NT_NetReachabilityChangedNotification object:nil
                                                                                                                queue:[NSOperationQueue mainQueue]
                                                                                                           usingBlock:^(NSNotification * _Nonnull note) {
                [[NSNotificationCenter defaultCenter] removeObserver:self.netStatusObserverForUpdateUserSessionInfo] ;
                self.netStatusObserverForUpdateUserSessionInfo = nil ;
                [self updateSession] ;
            }] ;
        }
    }
}



-(void)updateTimeZone:(NSString*)timeZone
{
    if (timeZone.length){
        NSString *timeStr = [timeZone stringByReplacingOccurrencesOfString:@":" withString:@""] ;
        _timeZone = timeStr ;
    }
}
#pragma mark -
-(RH_UserSafetyCodeModel *)userSafetyInfo
{
    return _userSafetyInfo ;
}

-(void)setUserSafetyInfo:(RH_UserSafetyCodeModel *)userSafetyInfo
{
    _userSafetyInfo = userSafetyInfo ;
}

-(RH_MineInfoModel *)mineSettingInfo
{
    return _mineSettingInfo ;
}

-(void)setMineSettingInfo:(RH_MineInfoModel *)mineSettingInfo
{
    _mineSettingInfo = mineSettingInfo ;
    [[NSNotificationCenter defaultCenter] postNotificationName:RHNT_UserInfoManagerMineGroupChangedNotification object:nil] ;
}
/*
-(NSArray<RH_BankInfoModel *> *)bankList
{
    return _bankList ;
}

-(void)setBankList:(NSArray<RH_BankInfoModel *> *)bankList
{
    _bankList = bankList ;
}
-(BOOL)hasLogin
{
    RH_APPDelegate *appDelegate = ConvertToClassPointer(RH_APPDelegate, [UIApplication sharedApplication].delegate) ;
    return appDelegate.isLogin ;
}

-(RH_WithDrawModel *)userWithDrawInfo
{
    return _userWithDrawInfo ;
}

-(void)setUserWithDrawInfo:(RH_WithDrawModel *)userWithDrawInfo
{
    _userWithDrawInfo = userWithDrawInfo ;
}

-(NSMutableArray *)domainCheckErrorList
{
    if (!_domainCheckErrorList){
        _domainCheckErrorList = [[NSMutableArray alloc] init] ;
    }
    
    return _domainCheckErrorList ;
}

#pragma mark- 通过bank code 取bank name
-(NSString*)bankNameWithCode:(NSString*)bankCode
{
    for (RH_BankInfoModel *bankInfo in _bankList) {
        if ([bankInfo.mBankName isEqualToString:bankCode]){
            return bankInfo.mBankName ;
        }
    }
    
    return nil ;
}
/*
#pragma mark -
-(CLLanguageOption)languageOption
{
    NSString *language = [[NSUserDefaults standardUserDefaults] objectForKey:key_languageOption];
    if (language){
        return language.integerValue ;
    }
    
    return CLLanguageOptionZHhant ;
}

-(void)updatelanguageOption:(CLLanguageOption)languageOption
{
    NSString *value = [NSString stringWithFormat:@"%ld",languageOption] ;
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key_languageOption] ;
}
*/
-(BOOL)isVoiceSwitch
{
    NSString *bFlag = [[CLDocumentCachePool shareTempCachePool] cacheKeyedUnArchiverRootObjectForKey:key_voiceSwitchFlag expectType:[NSString class]] ;
    return [bFlag boolValue] ;
}

-(void)updateVoickSwitchFlag:(BOOL)bSwitch
{
        [[CLDocumentCachePool shareTempCachePool] cacheKeyedArchiverDataWithRootObject:bSwitch?@"1":@"0"
                                                                                forKey:key_voiceSwitchFlag
                                                                                 async:YES] ;
}

-(BOOL)isScreenLock
{
    #define RH_updateScreenLockFlag            @"updateScreenLockFlag"
    NSString * bFlag = [SAMKeychain passwordForService:@" "account:RH_updateScreenLockFlag];
    #define RH_GuseterLock            @"RH_GuseterLock"
    NSString * currentGuseterLockStr = [SAMKeychain passwordForService:@" "account:RH_GuseterLock];
    if (currentGuseterLockStr && [bFlag boolValue] == YES) {
        return YES ;
    }
    return NO ;
}

-(void)updateScreenLockFlag:(BOOL)lock
{
    #define RH_updateScreenLockFlag            @"updateScreenLockFlag"
    [SAMKeychain setPassword:lock?@"1":@"0" forService:@" " account:RH_updateScreenLockFlag];
}

#pragma mark-
-(NSString *)screenLockPassword
{
    #define RH_GuseterLock            @"RH_GuseterLock"
    NSString * screenLock = [SAMKeychain passwordForService:@" "account:RH_GuseterLock];
    return screenLock ;
}

-(void)updateScreenLockPassword:(NSString *)lockPassrod
{
    if (lockPassrod){
        #define RH_GuseterLock            @"RH_GuseterLock"
        [SAMKeychain setPassword:lockPassrod forService:@" " account:RH_GuseterLock] ;
    }
}

#pragma mark -
-(NSString *)loginUserName
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey:key_lastLoginUserName] ;
}

-(NSString *)loginTime
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey:key_lastLoginTime] ;
}

-(BOOL)updateUserVeifyCode
{
    return _updateUserVeifyCode ;
}
-(void)setUpdateUserVeifyCode:(BOOL)updateUserVeifyCode
{
    if (updateUserVeifyCode != _updateUserVeifyCode) {
        _updateUserVeifyCode = updateUserVeifyCode ;
    }
}

-(BOOL)isSetSafetySecertPwd
{
    return _isSetSafetySecertPwd ;
}

-(void)setIsSetSafetySecertPwd:(BOOL)isSetSafetySecertPwd
{
    if (isSetSafetySecertPwd != _isSetSafetySecertPwd) {
        _isSetSafetySecertPwd = isSetSafetySecertPwd ;
    }
}

//是否绑定比特币
-(BOOL)isBindBitCoin
{
    return _isBindBitCoin ;
}

-(void)setIsBindBitCoin:(BOOL)isBindBitCoin
{
    if (isBindBitCoin != _isBindBitCoin) {
        _isBindBitCoin = isBindBitCoin ;
    }
}

#pragma mark - SID
-(NSString *)sidString
{
    return _sidString ;
}

-(void)setSidString:(NSString *)sidString
{
    if (![sidString isEqualToString:_sidString]){
        _sidString = sidString ;
        NSLog(@"...SID INFO...parse sid:%@",_sidString) ;
    }
}

-(void)updateLoginInfoWithUserName:(NSString*)userName LoginTime:(NSString*)loginTime
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userName?:@""  forKey:key_lastLoginUserName];
    [userDefaults setObject:loginTime?:@""  forKey:key_lastLoginTime];
}
/*
#pragma mark- serviceRequest
- (RH_ServiceRequest *)serviceRequest
{
    if (!_serviceRequest) {
        _serviceRequest = [[RH_ServiceRequest alloc] init];
        _serviceRequest.delegate = self;
    }
    
    return _serviceRequest;
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didSuccessRequestWithData:(id)data
{
    if (type == ServiceRequestTypeV3RefreshSession) {
        [self performSelector:@selector(updateSession) withObject:self afterDelay:300.0f] ;
    }
}

- (void)serviceRequest:(RH_ServiceRequest *)serviceRequest serviceType:(ServiceRequestType)type didFailRequestWithError:(NSError *)error
{
    if (type == ServiceRequestTypeV3RefreshSession) {
        [self performSelector:@selector(updateSession) withObject:self afterDelay:300.0f] ;
    }
}

#pragma mark-
-(void)autoLogin:(AutoLoginCompletation) completation
{
//    self.autoLoginCompletation = completation ;
//    if (self.hasLogin){
//        if (NetworkAvailable()){
//            [self.serviceRequest startLogin:self.userModel.mUserName Password:self.userModel.mUserPassword] ;
//        }else{
//            self.autoLoginCompletation(TRUE) ;
//        }
//    }else{
//        self.autoLoginCompletation(FALSE) ;
//    }
}
*/
@end
