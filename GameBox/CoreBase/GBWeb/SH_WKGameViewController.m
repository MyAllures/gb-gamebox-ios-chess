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

@interface SH_WKGameViewController ()

@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) SH_DragableMenuView *dragableMenuView;
@property (nonatomic, strong) UIProgressView *progressView;

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

    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    _wkWebView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:config];
    [self.view addSubview:_wkWebView];
    [_wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    
    // KVO，监听webView属性值得变化(estimatedProgress)
    [_wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    _progressView.trackTintColor = [UIColor clearColor];
    _progressView.progressTintColor = [UIColor blueColor];
    [_progressView setProgress:0.05 animated:YES];
    [self.view addSubview:_progressView];
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(2);
    }];
    
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
        [weakSelf.wkWebView goBack];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
    
@end