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

@interface GameWebViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (nonatomic, strong) SH_DragableMenuView *dragableMenuView;

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
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
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
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
        [self.webview loadRequest:request];
    }
    
    _dragableMenuView = [[[NSBundle mainBundle] loadNibNamed:@"SH_DragableMenuView" owner:nil options:nil] lastObject];
    [self.view addSubview:_dragableMenuView];
    [_dragableMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
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
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

@end
