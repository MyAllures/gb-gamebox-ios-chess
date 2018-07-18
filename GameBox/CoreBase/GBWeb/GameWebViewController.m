//
//  GameWebViewController.m
//  GameBox
//
//  Created by shin on 2018/6/27.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "GameWebViewController.h"
#import "NetWorkLineMangaer.h"
#import "SH_DragableMenuView.h"
#import "NJKWebViewProgress.h"

@interface GameWebViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (nonatomic, strong) SH_DragableMenuView *dragableMenuView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) NJKWebViewProgress *progressProxy;

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
    self.webview.delegate = self;
    //开始加载网页内容
    //我们自己的游戏需要传入SID
    //第三方游戏不需要传入SID
    __weak typeof(self) weakSelf = self;
    if (iPhoneX) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(statusBarOrientationChange:)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:nil];
    }

    NSString *preUrl = [NSString stringWithFormat:@"%@://%@%@",[NetWorkLineMangaer sharedManager].currentHttpType,[NetWorkLineMangaer sharedManager].currentHost,[[NetWorkLineMangaer sharedManager].currentPort isEqualToString:@""] ? @"" : [NSString stringWithFormat:@":%@",[NetWorkLineMangaer sharedManager].currentPort]];
    
    if ([self.url hasPrefix:preUrl] && ([NetWorkLineMangaer sharedManager].currentSID != nil && ![[NetWorkLineMangaer sharedManager].currentSID isEqualToString:@""])) {
        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
        [cookieProperties setObject:[NetWorkLineMangaer sharedManager].currentHost forKey:NSHTTPCookieDomain];
        [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
        [cookieProperties setObject:@"SID" forKey:NSHTTPCookieName];
        [cookieProperties setObject:[NetWorkLineMangaer sharedManager].currentSID forKey:NSHTTPCookieValue];
        NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookieProperties];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
        [request setValue:[NetWorkLineMangaer sharedManager].currentHost forHTTPHeaderField:@"Host"];

        [self.webview loadRequest:request];
    }
    else
    {
        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
        [cookieProperties setObject:[NetWorkLineMangaer sharedManager].currentHost forKey:NSHTTPCookieDomain];
        NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookieProperties];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
        [self.webview loadRequest:request];
    }
    
    _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    _progressView.trackTintColor = [UIColor clearColor];
    _progressView.progressTintColor = colorWithRGB(39, 61, 157);
    [_progressView setProgress:0.05 animated:YES];
    [self.view addSubview:_progressView];
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(4);
    }];

    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webview.delegate = _progressProxy;
    _progressProxy.progressBlock = ^(float progress) {
        weakSelf.progressView.hidden = progress == 1.0;
        [weakSelf.progressView setProgress:progress animated:NO];
    };

    _dragableMenuView = [[[NSBundle mainBundle] loadNibNamed:@"SH_DragableMenuView" owner:nil options:nil] lastObject];
    [self.view addSubview:_dragableMenuView];
    UIInterfaceOrientation oriention = [UIApplication sharedApplication].statusBarOrientation;

    [_dragableMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(iPhoneX && oriention == UIInterfaceOrientationLandscapeLeft ? -30 :  0);
        make.top.mas_equalTo(HEIGHT/2.0);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(67);
    }];
    [_dragableMenuView closeAction:^{
        [weakSelf.navigationController popViewControllerAnimated:NO];
    }];
    
    [_dragableMenuView gobackAction:^{
        [weakSelf.webview goBack];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)statusBarOrientationChange:(NSNotification *)notification
{
    UIInterfaceOrientation oriention = [UIApplication sharedApplication].statusBarOrientation;
    if (oriention == UIInterfaceOrientationLandscapeLeft) {
        [self.dragableMenuView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(iPhoneX && oriention == UIInterfaceOrientationLandscapeLeft ? -30 :  0);
            make.top.mas_equalTo(HEIGHT/2.0);
            make.width.mas_equalTo(32);
            make.height.mas_equalTo(67);
        }];
    }
    else
    {
        [self.dragableMenuView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(HEIGHT/2.0);
            make.width.mas_equalTo(32);
            make.height.mas_equalTo(67);
        }];
    }
}

@end
