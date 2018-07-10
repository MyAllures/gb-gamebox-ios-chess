//
//  AppDelegate.h
//  GameBox
//
//  Created by shin on 2018/7/4.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>
//UIKIT_EXTERN NSString  *NT_LoginStatusChangedNotification ;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) BOOL forceLandscape;//强制横屏
@property (nonatomic, assign) BOOL forcePortrait;//强制竖屏

@property(nonatomic,readonly,strong)  NSString *apiDomain ;//获取子域名list 的api 域名
@property(nonatomic,readonly,strong)  NSString *domain  ;
@property(nonatomic,readonly,strong)  NSString *headerDomain;
@property(nonatomic,readonly,strong)  NSString *servicePath ;//客服url ;
@property(strong,nonatomic)  NSString *customUrl;
@property(strong,nonatomic)  NSString *logoutUrl ;
@property(strong,nonatomic)  NSString *goBackURL;
//mine
@property (strong,nonatomic) NSString *gotoIndexUrl;
@property (nonatomic,assign,readonly) BOOL isLogin;
//是否有新的系统信息
@property (nonatomic,strong)NSString *whetherNewSystemNotice;

//wkweb cookie
@property (nonatomic,strong) NSDictionary *dictUserAgent ;
//check type
@property (nonatomic,strong)NSString *checkType;

-(void)updateApiDomain:(NSString*)apiDomain ;
-(void)updateDomain:(NSString*)domain ;
-(void)updateServicePath:(NSString*)servicePath ;
-(void)updateLoginStatus:(BOOL)loginStatus ;
-(void)updateHeaderDomain:(NSString *)headerDomain;

@end

