//
//  ViewController.h
//  GameBox
//
//  Created by shin on 2018/7/4.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SH_BaseViewController.h"

typedef void(^SHCheckIPSSuccess)(NSDictionary *ips);//有一个ip check成功
typedef void(^SHCheckIPSFailed)(void);//所有ip都check失败

@interface LineCheckViewController : SH_BaseViewController

@property (nonatomic, strong) UINavigationController *rootNav;

@end

