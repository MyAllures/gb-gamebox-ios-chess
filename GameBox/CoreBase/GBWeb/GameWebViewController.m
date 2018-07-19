//
//  GameWebViewController.m
//  GameBox
//
//  Created by shin on 2018/6/27.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "GameWebViewController.h"
#import "SH_GameWebView.h"

//#import "NetWorkLineMangaer.h"
//#import "SH_DragableMenuView.h"
//#import "NJKWebViewProgress.h"
//#import <JavaScriptCore/JavaScriptCore.h>

////忽略证书访问
//@interface NSURLRequest (IgnoreSSL)
//+(BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
//@end
//@implementation NSURLRequest (IgnoreSSL)
//+(BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host {return YES;}
//@end

@interface GameWebViewController () <UIWebViewDelegate>
//@property (weak, nonatomic) IBOutlet UIWebView *webview;
//@property (nonatomic, strong) SH_DragableMenuView *dragableMenuView;
//@property (nonatomic, strong) UIProgressView *progressView;
//@property (nonatomic, strong) NJKWebViewProgress *progressProxy;

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
    }];
}

- (SH_GameWebView *)gameWebView
{
    if (_gameWebView == nil) {
        _gameWebView = [[[NSBundle mainBundle] loadNibNamed:@"SH_GameWebView" owner:nil options:nil] lastObject];
        [self.view addSubview:_gameWebView];
        [_gameWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).mas_offset(0);
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
