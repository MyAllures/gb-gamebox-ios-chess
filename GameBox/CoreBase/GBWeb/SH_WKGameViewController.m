//
//  SH_WKGameViewController.h.m
//  GameBox
//
//  Created by shin on 2018/7/15.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_WKGameViewController.h"
#import <WebKit/WebKit.h>
#import "SH_DragableMenuView.h"

@interface SH_WKGameViewController ()<WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) SH_DragableMenuView *dragableMenuView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, copy) SH_WKGameViewControllerClose closeBlock;

@end

@implementation SH_WKGameViewController

- (void)dealloc
{
    [_wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (UIInterfaceOrientationMask)orientation
{
    return UIInterfaceOrientationMaskAll;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    __weak typeof(self) weakSelf = self;
    if (iPhoneX) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(statusBarOrientationChange:)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:nil];
    }

    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    _wkWebView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:config];
    _wkWebView.navigationDelegate = self;
    _wkWebView.UIDelegate = self;
    [self.view addSubview:_wkWebView];
    [_wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [_wkWebView loadRequest:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60]];
    
    // KVO，监听webView属性值得变化(estimatedProgress)
    [_wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    _progressView.trackTintColor = [UIColor clearColor];
    _progressView.progressTintColor = colorWithRGB(39, 61, 157);
    [_progressView setProgress:0.05 animated:YES];
    [self.view addSubview:_progressView];
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(4);
    }];
    
    _dragableMenuView = [[[NSBundle mainBundle] loadNibNamed:@"SH_DragableMenuView" owner:nil options:nil] lastObject];
    [self.view addSubview:_dragableMenuView];
    UIInterfaceOrientation oriention = [UIApplication sharedApplication].statusBarOrientation;

    [_dragableMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(iPhoneX && oriention == UIInterfaceOrientationLandscapeLeft ? -30 :  0);
        make.top.mas_equalTo(HEIGHT/2.0);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(95);
    }];
    [_dragableMenuView closeAction:^{
        if (weakSelf.closeBlock) {
            weakSelf.closeBlock();
        }
        [weakSelf.navigationController popViewControllerAnimated:NO];
    }];
    
    [_dragableMenuView gobackAction:^{
        if (weakSelf.wkWebView.canGoBack) {
            [weakSelf.wkWebView goBack];
        }
        else
        {
            if (weakSelf.closeBlock) {
                weakSelf.closeBlock();
            }
            [weakSelf.navigationController popViewControllerAnimated:NO];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)close:(SH_WKGameViewControllerClose)closeBlock
{
    self.closeBlock = closeBlock;
}

#pragma mark - WKUIDelegate M

- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    [_wkWebView loadRequest:[NSMutableURLRequest requestWithURL:navigationAction.request.URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60]];
    
    return nil;
}

#pragma mark - WKNavigationDelegate M

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    
}

// 内容开始加载
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    
}

// 页面加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    
}

// 页面加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    
}

// 收到服务器重定向请求
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
    
}

// 在收到响应开始加载后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
    WKNavigationResponsePolicy responsePolicy = WKNavigationResponsePolicyAllow;
    decisionHandler(responsePolicy);
}

// 在请求开始加载之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    WKNavigationActionPolicy Allow = WKNavigationActionPolicyAllow;
    decisionHandler(Allow);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isEqual:self.wkWebView] && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            // 加载完成
            // 首先加载到头
            [self.progressView setProgress:newprogress animated:YES];
            // 之后0.3秒延迟隐藏
            __weak typeof(self) weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                weakSelf.progressView.hidden = YES;
                [weakSelf.progressView setProgress:0 animated:NO];
            });
        }
        else {
            // 加载中
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
    else
    {
        // 其他
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)statusBarOrientationChange:(NSNotification *)notification
{
    UIInterfaceOrientation oriention = [UIApplication sharedApplication].statusBarOrientation;
    if (oriention == UIInterfaceOrientationLandscapeLeft) {
        [self.dragableMenuView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(iPhoneX && oriention == UIInterfaceOrientationLandscapeLeft ? -30 :  0);
            make.top.mas_equalTo(HEIGHT/2.0);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(95);
        }];
    }
    else
    {
        [self.dragableMenuView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(HEIGHT/2.0);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(95);
        }];
    }
}
@end
