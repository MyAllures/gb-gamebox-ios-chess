//
//  SH_SmallWindowViewController.h
//  GameBox
//
//  Created by shin on 2018/8/8.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_BaseViewController.h"

typedef void(^SH_SmallWindowViewControllerDismissBlock)(void);

@interface SH_SmallWindowViewController : SH_BaseViewController

@property (nonatomic, strong) UIView *customView;
@property (nonatomic, strong) NSString *titleImageName;
@property (nonatomic, assign) CGFloat contentHeight;

- (void)close:(SH_SmallWindowViewControllerDismissBlock)closeBlock;
- (void)close;
@end
