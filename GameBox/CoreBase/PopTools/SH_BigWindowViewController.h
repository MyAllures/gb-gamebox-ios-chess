//
//  SH_BigWindowViewController.h
//  GameBox
//
//  Created by shin on 2018/8/7.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_BaseViewController.h"

typedef void(^SH_BigWindowViewControllerDismissBlock)(void);

@interface SH_BigWindowViewController : SH_BaseViewController

@property (nonatomic, strong) UIView *customView;
@property (nonatomic, strong) NSString *titleImageName;

- (void)close:(SH_BigWindowViewControllerDismissBlock)closeBlock;

@end
