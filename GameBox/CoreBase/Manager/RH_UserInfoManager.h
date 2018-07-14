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

@property(nonatomic,strong,readonly) NSString *timeZone ;
@property(nonatomic,assign,readonly) BOOL  isLogin;

///----app 层 相关开关

@property (nonatomic,assign,readonly) BOOL isVoiceSwitch    ; //声音开关

//记录最后一次登录的用户名，及时间
@property(nonatomic,strong,readonly) NSString *loginUserName    ;
@property(nonatomic,strong,readonly) NSString *loginTime        ;

-(void)updateIsLogin:(BOOL)isLogin;

-(void)updateLoginInfoWithUserName:(NSString*)userName LoginTime:(NSString*)loginTime ; 


@end
