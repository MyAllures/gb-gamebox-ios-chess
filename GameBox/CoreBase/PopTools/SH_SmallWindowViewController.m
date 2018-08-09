//
//  SH_SmallWindowViewController.m
//  GameBox
//
//  Created by shin on 2018/8/8.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_SmallWindowViewController.h"

@interface SH_SmallWindowViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *titleImgView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *windowHeightConstraint;
@property (copy, nonatomic) SH_SmallWindowViewControllerDismissBlock dismissBlock;

@end

@implementation SH_SmallWindowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleImgView.image = [UIImage imageNamed:self.titleImageName];
    self.windowHeightConstraint.constant = self.contentHeight+46;
    [self.contentView addSubview:self.customView];
    [self.customView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setTitleImageName:(NSString *)titleImageName
{
    _titleImageName = titleImageName;
    self.titleImgView.image = [UIImage imageNamed:_titleImageName];
}
-(void)close:(SH_SmallWindowViewControllerDismissBlock)closeBlock
{
    self.dismissBlock = closeBlock;
//    [self closeAction:nil];
}

- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}


@end
