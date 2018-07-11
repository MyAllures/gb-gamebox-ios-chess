//
//  UIViewController+Instance.h
//  CoreLib
//
//  Created by apple pro on 2016/11/22.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController(Instance)
+ (instancetype)viewController;
+ (instancetype)viewControllerWithContext:(id)context;
+ (instancetype)viewControllerWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)bundleOrNil context:(id)context;

- (void)setupViewContext:(id)context;

@end
