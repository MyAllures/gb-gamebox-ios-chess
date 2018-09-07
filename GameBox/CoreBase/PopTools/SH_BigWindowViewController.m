//
//  SH_BigWindowViewController.m
//  GameBox
//
//  Created by shin on 2018/8/7.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_BigWindowViewController.h"
#import "SH_XibView.h"

@interface SH_BigWindowViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *titleImgView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (copy, nonatomic) SH_BigWindowViewControllerDismissBlock dismissBlock;
@property (weak, nonatomic) IBOutlet SH_XibView *xibView;
@property (weak, nonatomic) IBOutlet SH_WebPButton *closeBtn;

@end

@implementation SH_BigWindowViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.closeBtn.alpha = 0.0;
    self.xibView.transform = CGAffineTransformMakeScale(0.001, 0.001);
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:1/3.0 relativeDuration:1/3.0 animations: ^{
            self.xibView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
        [UIView animateWithDuration:1 animations:^{
            self.closeBtn.alpha = 0.0;
        }];
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.8 animations:^{
            self.closeBtn.alpha = 1.0;
        }];
    }];
}

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
- (void)setTitleImageName:(NSString *)titleImageName
{
    _titleImageName = titleImageName;
    self.titleImgView.image = [UIImage imageNamed:_titleImageName];
}
-(void)close:(SH_BigWindowViewControllerDismissBlock)closeBlock
{
    self.dismissBlock = closeBlock; 
    [self closeAction:nil];
}

- (IBAction)closeAction:(SH_WebPButton *)sender {
    [sender setScale];
    [self dismissViewControllerAnimated:NO completion:nil];
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

@end
