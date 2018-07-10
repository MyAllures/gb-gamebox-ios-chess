//
//  UIViewController+Instance.m
//  CoreLib
//
//  Created by apple pro on 2016/11/22.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import "UIViewController+Instance.h"
#import "ScreenAdaptation.h"

@implementation UIViewController(Instance)
+ (instancetype)viewController {
    return [self viewControllerWithNibName:nil bundle:nil context:nil];
}

+ (instancetype)viewControllerWithContext:(id)context {
    return [self viewControllerWithNibName:nil bundle:nil context:context];
}

+ (instancetype)viewControllerWithNibName:(NSString *)nibNameOrNil
                                   bundle:(NSBundle *)bundleOrNil
                                  context:(id)context
{
    nibNameOrNil = validAdaptationNibName(nibNameOrNil ?: NSStringFromClass([self class]),bundleOrNil);

    id viewController =nibNameOrNil.length ? [[self alloc] initWithNibName:nibNameOrNil bundle:bundleOrNil] : [[self alloc] init];
    [viewController setupViewContext:context];

    return viewController;
}

- (void)setupViewContext:(id)context {
    //do nothing
}

@end
