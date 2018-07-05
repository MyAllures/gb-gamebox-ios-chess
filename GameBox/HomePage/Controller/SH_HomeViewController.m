//
//  SH_HomeViewController.m
//  GameBox
//
//  Created by shin on 2018/7/4.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_HomeViewController.h"
#import "SH_NetWorkService+Login.h"
#import "NetWorkLineMangaer.h"
#import "GameWebViewController.h"
#import "AppDelegate.h"

@interface SH_HomeViewController ()

@end

@implementation SH_HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self fetchSID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    [SH_NetWorkService login:@"Shin" psw:@"h123123" verfyCode:@"" complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSString *setCookie = [httpURLResponse.allHeaderFields objectForKey:@"Set-Cookie"];
        NSUInteger startLocation = [setCookie rangeOfString:@"GMT, "].location +4;
        NSUInteger endLocation = [setCookie rangeOfString:@" rememberMe=deleteMe"].location;
        NSUInteger lenth = endLocation - startLocation;
        NSString *cookie = [setCookie substringWithRange:NSMakeRange(startLocation, lenth)];
        [NetWorkLineMangaer sharedManager].currentCookie = cookie;
        
        [SH_NetWorkService fetchUserInfo:^(NSHTTPURLResponse *httpURLResponse, id response) {
            //
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            //
        }];
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        //
    }];
}

- (IBAction)enterGame:(id)sender {
    GameWebViewController *gameVC = [[GameWebViewController alloc] initWithNibName:@"GameWebViewController" bundle:nil];
    gameVC.url = @"https://imes-mcasino.roshan88.com/mobile.aspx?id=262&token=010b04f8-87c9-4692-bb82-5fcb90c75f0d&LanguageCode=1";
    [self presentViewController:gameVC animated:YES completion:nil];
}

/**
 * 获取SID
 */
- (void)fetchSID
{
    [SH_NetWorkService fetchHttpCookie:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSString *setCookie = [httpURLResponse.allHeaderFields objectForKey:@"Set-Cookie"];
        [NetWorkLineMangaer sharedManager].currentCookie = setCookie;
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        //
    }];
}

@end
