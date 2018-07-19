//
//  SH_GameWebView.h
//  GameBox
//
//  Created by shin on 2018/7/19.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SH_GameWebViewClose)(void);//游戏页面关闭

@interface SH_GameWebView : UIView

@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) BOOL hideMenuView;//是否隐藏工具视图

- (void)close:(SH_GameWebViewClose)closeBlock;

@end
