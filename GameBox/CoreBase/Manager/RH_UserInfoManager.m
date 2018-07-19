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
@synthesize isLogin = _isLogin;
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

    }
    
    return self ;
}


-(void)setMineSettingInfo:(RH_MineInfoModel *)mineSettingInfo
{
    _mineSettingInfo = mineSettingInfo ;
}
- (void)setUserSafetyInfo:(RH_UserSafetyCodeModel *)userSafetyInfo{
    _userSafetyInfo = userSafetyInfo;
}
-(void)setBankList:(NSArray<SH_BankListModel *> *)bankList {
    _bankList = bankList;
}
-(void)updateIsLogin:(BOOL)isLogin{
    _isLogin = isLogin;
}
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

-(void)updateLoginInfoWithUserName:(NSString*)userName LoginTime:(NSString*)loginTime
{
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userName?:@""  forKey:key_lastLoginUserName];
    [userDefaults setObject:loginTime?:@""  forKey:key_lastLoginTime];
}

-(void)dealloc
{
    
}
@end
