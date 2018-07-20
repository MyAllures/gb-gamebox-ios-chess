//
//  SH_PromoDeatilViewController.m
//  GameBox
//
//  Created by shin on 2018/7/19.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_PromoDeatilViewController.h"
#import "SH_GameWebView.h"
#import "SH_PromoListModel.h"

@interface SH_PromoDeatilViewController ()
@property (weak, nonatomic) IBOutlet UIView *cornerView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (nonatomic, strong) SH_GameWebView *gameWebView;

@end

@implementation SH_PromoDeatilViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.cornerView.layer.cornerRadius = 10;
    self.titleLB.text = self.model.name;
    _gameWebView = [[[NSBundle mainBundle] loadNibNamed:@"SH_GameWebView" owner:nil options:nil] lastObject];
    _gameWebView.url = self.model.url;
    _gameWebView.hideMenuView = YES;
    [self.contentView addSubview:_gameWebView];
    [_gameWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.top.mas_equalTo(8);
        make.bottom.mas_equalTo(-8);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
