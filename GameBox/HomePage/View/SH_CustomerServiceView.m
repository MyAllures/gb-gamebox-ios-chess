//
//  SH_CustomerServiceView.m
//  GameBox
//
//  Created by shin on 2018/7/31.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_CustomerServiceView.h"
#import "SH_GameWebView.h"

@interface SH_CustomerServiceView ()

@property (nonatomic, strong) SH_GameWebView *gameWebView;

@end

@implementation SH_CustomerServiceView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = colorWithRGB(42, 53, 138);
    }
    return self;
}

- (SH_GameWebView *)gameWebView
{
    if (_gameWebView == nil) {
        _gameWebView = [[[NSBundle mainBundle] loadNibNamed:@"SH_GameWebView" owner:nil options:nil] lastObject];
        [self addSubview:_gameWebView];
        [_gameWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.right.mas_equalTo(-8);
            make.top.mas_equalTo(8);
            make.bottom.mas_equalTo(-8);
        }];
    }
    return _gameWebView;
}

- (void)setUrl:(NSString *)url
{
    _url = url;
    self.gameWebView.url = _url;
    self.gameWebView.hideMenuView = YES;
}

@end
