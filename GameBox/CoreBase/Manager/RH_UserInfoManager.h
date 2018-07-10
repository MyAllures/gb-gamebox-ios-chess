//
//  RH_UserInfoManager.h
//  TaskTracking
//
//  Created by apple pro on 2017/2/19.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RH_UserSafetyCodeModel.h"
#import "RH_MineInfoModel.h"
//#import "RH_BankInfoModel.h"
//#import "RH_WithDrawModel.h"
#import "coreLib.h"

#define  RHNT_UserInfoManagerMineGroupChangedNotification         @"UserInfoManagerMineGroupChangedNotification"

#define HasLogin                    [[RH_UserInfoManager shareUserManager] hasLogin]
#define UserSafetyInfo              [RH_UserInfoManager shareUserManager].userSafetyInfo
#define MineSettingInfo             [RH_UserInfoManager shareUserManager].mineSettingInfo
#define BankList                    [RH_UserInfoManager shareUserManager].bankList
#define UserWithDrawInfo            [RH_UserInfoManager shareUserManager].userWithDrawInfo

typedef void(^AutoLoginCompletation)(BOOL result) ;

@interface RH_UserInfoManager : NSObject
+(instancetype)shareUserManager ;
@property(nonatomic,strong,readonly) RH_UserSafetyCodeModel *userSafetyInfo ;
@property(nonatomic,strong,readonly) RH_MineInfoModel *mineSettingInfo ;
//@property(nonatomic,strong,readonly) NSArray<RH_BankInfoModel*> *bankList ;
//@property(nonatomic,strong,readonly) RH_WithDrawModel *userWithDrawInfo ;
@property(nonatomic,strong,readonly) NSMutableArray *domainCheckErrorList ;
@property(nonatomic,strong,readonly) NSString *timeZone ;

-(BOOL)hasLogin ;
-(void)setUserSafetyInfo:(RH_UserSafetyCodeModel *)userSafetyInfo ;
-(void)setMineSettingInfo:(RH_MineInfoModel *)mineSettingInfo ;
//-(void)setBankList:(NSArray<RH_BankInfoModel *> *)bankList ;
//-(void)setUserWithDrawInfo:(RH_WithDrawModel *)userWithDrawInfo ;

///----app 层 相关开关
//@property (nonatomic,assign,readonly) CLLanguageOption languageOption ;
@property (nonatomic,assign,readonly) BOOL isVoiceSwitch    ; //声音开关
@property (nonatomic,assign,readonly) BOOL isScreenLock     ; //锁屏手势开关
@property (nonatomic,strong,readonly) NSString *screenLockPassword ; //锁屏手势密码
@property (nonatomic,assign) BOOL isSetSafetySecertPwd     ; //是否设置安全密码
@property (nonatomic,assign) BOOL isBindBitCoin     ; //是否绑定比特币
//记录最后一次登录的用户名，及时间
@property(nonatomic,strong,readonly) NSString *loginUserName    ;
@property(nonatomic,strong,readonly) NSString *loginTime        ;

//记录用户修改密码是否开启验证码
@property(nonatomic,assign) BOOL updateUserVeifyCode        ;
//记录用户登录后获取SID
@property(nonatomic,strong)NSString *sidString ;

-(void)updatelanguageOption:(CLLanguageOption)languageOption ;
-(void)updateVoickSwitchFlag:(BOOL)bSwitch  ;
-(void)updateScreenLockFlag:(BOOL)lock      ;
-(void)updateScreenLockPassword:(NSString*)lockPassrod ;
-(NSString*)bankNameWithCode:(NSString*)bankCode ;
-(void)updateTimeZone:(NSString*)timeZone ;

-(void)updateLoginInfoWithUserName:(NSString*)userName LoginTime:(NSString*)loginTime ; 


@end
