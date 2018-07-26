//
//  SH_GameWebView.m
//  GameBox
//
//  Created by shin on 2018/7/19.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_GameWebView.h"
#import "NetWorkLineMangaer.h"
#import "SH_DragableMenuView.h"
#import "NJKWebViewProgress.h"
#import <JavaScriptCore/JavaScriptCore.h>

//忽略证书访问
@interface NSURLRequest (IgnoreSSL)
+(BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
@end
@implementation NSURLRequest (IgnoreSSL)
+(BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host {return YES;}
@end

@interface SH_GameWebView () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (nonatomic, strong) SH_DragableMenuView *dragableMenuView;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) NJKWebViewProgress *progressProxy;

@property (nonatomic, copy) SH_GameWebViewClose closeBlock;

@end

@implementation SH_GameWebView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc
{
    [self.webview stopLoading];
    [self.webview removeFromSuperview];
    self.webview = nil;
    self.webview.delegate = nil;
}


- (void)close:(SH_GameWebViewClose)closeBlock
{
    self.closeBlock = closeBlock;
}

- (void)setUrl:(NSString *)url
{
    _url = url;
    
    __weak typeof(self) weakSelf = self;
    if (iPhoneX) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(statusBarOrientationChange:)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:nil];
    }
    
    [self loadWithUrl:self.url];
    
    _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    _progressView.trackTintColor = [UIColor clearColor];
    _progressView.progressTintColor = colorWithRGB(39, 61, 157);
    [_progressView setProgress:0.05 animated:YES];
    [self addSubview:_progressView];
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(4);
    }];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webview.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    
    _progressProxy.progressBlock = ^(float progress) {
        weakSelf.progressView.hidden = progress == 1.0;
        [weakSelf.progressView setProgress:progress animated:NO];
    };
    
    _dragableMenuView = [[[NSBundle mainBundle] loadNibNamed:@"SH_DragableMenuView" owner:nil options:nil] lastObject];
    [self addSubview:_dragableMenuView];
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
    }];
    
    [_dragableMenuView gobackAction:^{
        if (weakSelf.webview.canGoBack) {
            [weakSelf.webview goBack];
        }
        else
        {
            if (weakSelf.closeBlock) {
                weakSelf.closeBlock();
            }
        }
    }];

}

- (void)setHideMenuView:(BOOL)hideMenuView
{
    _hideMenuView = hideMenuView;
    _dragableMenuView.hidden = _hideMenuView;
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

#pragma mark - UIWebViewDelegate M

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    JSContext *jsContext = [_webview valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    [self setupJSCallBackOC:jsContext] ;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

#pragma mark - Private M

- (void)loadWithUrl:(NSString *)url
{
    NSString *preUrl = [NSString stringWithFormat:@"%@://%@",[NetWorkLineMangaer sharedManager].currentHttpType,[NetWorkLineMangaer sharedManager].currentHost];
    
    if ([url hasPrefix:preUrl] && ([NetWorkLineMangaer sharedManager].currentSID != nil && ![[NetWorkLineMangaer sharedManager].currentSID isEqualToString:@""])) {
        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
        [cookieProperties setObject:[NetWorkLineMangaer sharedManager].currentHost forKey:NSHTTPCookieDomain];
        [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
        [cookieProperties setObject:@"SID" forKey:NSHTTPCookieName];
        [cookieProperties setObject:[NetWorkLineMangaer sharedManager].currentSID forKey:NSHTTPCookieValue];
        NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookieProperties];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
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
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
        [self.webview loadRequest:request];
    }
}

-(void)setupJSCallBackOC:(JSContext*)jsContext
{
    __weak typeof(self) weakSelf = self;
    
    jsContext[@"nativeGoBackPage"] = ^(){
        //返回按钮
        if ([weakSelf.webview canGoBack]) {
            [weakSelf.webview goBack];
        }
        else
        {
            if (weakSelf.closeBlock) {
                weakSelf.closeBlock();
            }
        }
    };
    
    jsContext[@"nativeGotoPromoRecordPage"] = ^(){
        //跳到我的优惠记录界面
        //        if (weakSelf.appDelegate.isLogin) {
        //            [weakSelf.navigationController pushViewController:[RH_PromoListController viewController] animated:YES];
        //        }else
        //        {
        //            [weakSelf loginButtonItemHandle] ;
        //        }
    };
    
    jsContext[@"nativeGotoDepositPage"] = ^(){
        //跳入存款页面
        //        [weakSelf.navigationController popToRootViewControllerAnimated:NO];
        //        weakSelf.myTabBarController.selectedIndex = 1 ;
    };
    
    jsContext[@"nativeGoToCustomerPage"] = ^(){
        //跳转客服页面
        //        [weakSelf.navigationController pushViewController:[RH_CustomServiceSubViewController viewController] animated:YES];
    };
    
    jsContext[@"nativeGoToRegisterPage"] = ^(){
        //注册页面
        //        [weakSelf.navigationController pushViewController:[RH_RegistrationViewController viewController] animated:YES];
    };
    
    jsContext[@"gotoHomePage"] = ^(){
        //        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        //        weakSelf.myTabBarController.selectedIndex = 0 ;
    };
    
    jsContext[@"nativeLogin"] = ^(){
        //跳到login界面
        //        [weakSelf loginButtonItemHandle] ;
    };
    
    jsContext[@"gotoCustom"] = ^(){
        NSArray *args = [JSContext currentArguments];
        JSValue *customUrl;
        for (JSValue *jsVal in args) {
            customUrl = jsVal;
            NSLog(@"%@", jsVal.toString);
        }
        
        if (args[0] != NULL) {
            NSString *url = customUrl.toString;
            if ([url containsString:@"/login/commonLogin.html"]) {
                //回到首页并展示登录界面
//                [weakSelf.navigationController popViewControllerAnimated:NO];
//                if (weakSelf.closeAndShowLoginBlock) {
//                    weakSelf.closeAndShowLoginBlock();
//                }
            }
            else if ([url containsString:@"/mainIndex.html"])
            {
                //回到首页
//                [weakSelf.navigationController popViewControllerAnimated:NO];
//                if (weakSelf.closeBlock) {
//                    weakSelf.closeBlock();
//                }
            }
            else
            {
                [weakSelf loadWithUrl:[NSString stringWithFormat:@"%@://%@%@",[NetWorkLineMangaer sharedManager].currentHttpType,[NetWorkLineMangaer sharedManager].currentHost,url]];
            }
        }
    } ;
}
@end
