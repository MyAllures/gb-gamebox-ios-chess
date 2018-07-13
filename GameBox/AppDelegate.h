//
//  AppDelegate.h
//  GameBox
//
//  Created by shin on 2018/7/4.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) BOOL forceLandscape;//强制横屏
@property (nonatomic, assign) BOOL forcePortrait;//强制竖屏

@property (nonatomic,assign) BOOL isLogin;

@end

