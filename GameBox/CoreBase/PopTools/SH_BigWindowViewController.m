//
//  SH_BigWindowViewController.m
//  GameBox
//
//  Created by shin on 2018/8/7.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_BigWindowViewController.h"

@interface SH_BigWindowViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *titleImgView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (copy, nonatomic) SH_BigWindowViewControllerDismissBlock dismissBlock;

@end

@implementation SH_BigWindowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleImgView.image = [UIImage imageNamed:self.titleImageName];

    [self.contentView addSubview:self.customView];
    [self.customView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)close:(SH_BigWindowViewControllerDismissBlock)closeBlock
{
    self.dismissBlock = closeBlock; 
    [self closeAction:nil];
}

- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

@end
