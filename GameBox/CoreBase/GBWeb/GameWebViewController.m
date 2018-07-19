//
//  GameWebViewController.m
//  GameBox
//
//  Created by shin on 2018/6/27.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "GameWebViewController.h"
#import "SH_GameWebView.h"

@interface GameWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) SH_GameWebView *gameWebView;
@property (nonatomic, copy) GameWebViewControllerClose closeBlock;
@property (nonatomic, copy) GameWebViewControllerCloseAndShowLogin closeAndShowLoginBlock;

@end

@implementation GameWebViewController

- (void)dealloc
{
    
}

- (UIInterfaceOrientationMask)orientation
{
    return UIInterfaceOrientationMaskAll;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    __weak typeof(self) weakSelf = self;
    self.gameWebView.url = self.url;
    self.gameWebView.hideMenuView = self.hideMenuView;
    [self.gameWebView close:^{
        [weakSelf.navigationController popViewControllerAnimated:NO];
        if (weakSelf.closeBlock) {
            weakSelf.closeBlock();
        }
    }];
}

- (SH_GameWebView *)gameWebView
{
    if (_gameWebView == nil) {
        _gameWebView = [[[NSBundle mainBundle] loadNibNamed:@"SH_GameWebView" owner:nil options:nil] lastObject];
        [self.view addSubview:_gameWebView];
        [_gameWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _gameWebView;
}

- (void)close:(GameWebViewControllerClose)closeBlock
{
    self.closeBlock = closeBlock;
}

- (void)closeAndShowLogin:(GameWebViewControllerClose)closeAndShowLoginBlock
{
    self.closeAndShowLoginBlock = closeAndShowLoginBlock;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
