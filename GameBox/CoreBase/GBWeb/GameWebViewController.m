//
//  GameWebViewController.m
//  GameBox
//
//  Created by shin on 2018/6/27.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "GameWebViewController.h"
#import "NetWorkLineMangaer.h"

@interface GameWebViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation GameWebViewController

- (void)dealloc
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.webview.delegate = self;
    //开始加载网页内容
    //我们自己的游戏需要传入SID
    //第三方游戏不需要传入SID
    
    NSString *preUrl = [NSString stringWithFormat:@"%@://%@%@",[NetWorkLineMangaer sharedManager].currentHttpType,[NetWorkLineMangaer sharedManager].currentHost,[[NetWorkLineMangaer sharedManager].currentPort isEqualToString:@""] ? @"" : [NSString stringWithFormat:@":%@",[NetWorkLineMangaer sharedManager].currentPort]];
    
//    if ([self.url.absoluteString hasPrefix:preUrl] && ([RH_UserInfoManager shareUserManager].sidString != nil && ![[RH_UserInfoManager shareUserManager].sidString isEqualToString:@""])) {
//        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
//        [cookieProperties setObject:self.appDelegate.headerDomain forKey:NSHTTPCookieDomain];
//        [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
//        [cookieProperties setObject:@"SID" forKey:NSHTTPCookieName];
//        NSArray *sidStringCompArr = [[RH_UserInfoManager shareUserManager].sidString componentsSeparatedByString:@";"];
//        NSArray *sidInfoArr = [[sidStringCompArr firstObject] componentsSeparatedByString:@"="];
//        [cookieProperties setObject:sidInfoArr[1] forKey:NSHTTPCookieValue];
//        NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookieProperties];
//        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser];
//        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.webURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
//        [request setValue:self.appDelegate.headerDomain forHTTPHeaderField:@"Host"];
//
//        [self.webView loadRequest:request];
//    }
//    else
//    {
//        NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
//        [cookieProperties setObject:self.appDelegate.headerDomain forKey:NSHTTPCookieDomain];
//        NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookieProperties];
//        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser];
//        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.webURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
//
//        [self.webView loadRequest:request];
//    }

    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
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
