//
//  SH_WKGameViewController.h
//  GameBox
//
//  Created by shin on 2018/7/15.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_BaseViewController.h"

typedef void(^SH_WKGameViewControllerClose)(void);//游戏页面关闭

@interface SH_WKGameViewController : SH_BaseViewController

@property (nonatomic, strong) NSString *url;

- (void)close:(SH_WKGameViewControllerClose)closeBlock;

@end
