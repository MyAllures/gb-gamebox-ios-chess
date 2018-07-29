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
#import "SH_BankListModel.h"
#import "coreLib.h"


#define HasLogin                    [[RH_UserInfoManager shareUserManager] hasLogin]
#define UserSafetyInfo              [RH_UserInfoManager shareUserManager].userSafetyInfo
#define MineSettingInfo             [RH_UserInfoManager shareUserManager].mineSettingInfo
#define BankList                    [RH_UserInfoManager shareUserManager].bankList
#define UserWithDrawInfo            [RH_UserInfoManager shareUserManager].userWithDrawInfo

typedef void(^AutoLoginCompletation)(BOOL result) ;

@interface RH_UserInfoManager : NSObject
+(instancetype)shareUserManager ;
@property(nonatomic,strong,readonly) RH_UserSafetyCodeModel *userSafetyInfo ;
@property(nonatomic,strong) RH_MineInfoModel *mineSettingInfo ;
@property(nonatomic,strong,readonly) NSArray<SH_BankListModel *> *bankList ;
@property(nonatomic,assign,readonly) BOOL  isLogin;

-(void)setMineSettingInfo:(RH_MineInfoModel *)mineSettingInfo ;
-(void)setUserSafetyInfo:(RH_UserSafetyCodeModel *)userSafetyInfo;
-(void)setBankList:(NSArray<SH_BankListModel *> *)bankList ;
///----app 层 相关开关


//记录最后一次登录的用户名，及时间
@property(nonatomic,strong,readonly) NSString *loginUserName    ;
@property(nonatomic,strong,readonly) NSString *loginTime        ;

-(void)updateIsLogin:(BOOL)isLogin;

-(void)updateLoginInfoWithUserName:(NSString*)userName LoginTime:(NSString*)loginTime ; 


@end
