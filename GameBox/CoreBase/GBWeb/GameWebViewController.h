//
//  GameWebViewController.h
//  GameBox
//
//  Created by shin on 2018/6/27.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SH_BaseViewController.h"

typedef void(^GameWebViewControllerClose)(void);//游戏页面关闭
typedef void(^GameWebViewControllerCloseAndShowLogin)(void);//游戏页面关闭并展示登录

@interface GameWebViewController : SH_BaseViewController

@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) BOOL hideMenuView;//是否隐藏工具视图

- (void)close:(GameWebViewControllerClose)closeBlock;
- (void)closeAndShowLogin:(GameWebViewControllerClose)closeAndShowLoginBlock;

@end
