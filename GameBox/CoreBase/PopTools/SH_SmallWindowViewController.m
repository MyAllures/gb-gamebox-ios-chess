//
//  SH_SmallWindowViewController.m
//  GameBox
//
//  Created by shin on 2018/8/8.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_SmallWindowViewController.h"
#import "SH_XibView.h"

@interface SH_SmallWindowViewController ()
@property (weak, nonatomic) IBOutlet SH_WebPButton *closeBtn;

@property (weak, nonatomic) IBOutlet UIImageView *titleImgView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *windowHeightConstraint;
@property (copy, nonatomic) SH_SmallWindowViewControllerDismissBlock dismissBlock;
@property (weak, nonatomic) IBOutlet SH_XibView *xibView;

@end

@implementation SH_SmallWindowViewController

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
}

- (void)close {
    [self closeAction:nil];
}

- (IBAction)closeAction:(SH_WebPButton *)sender {
    [sender setScale];
    [UIView animateKeyframesWithDuration:0.4 delay:0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:1/3.0 relativeDuration:1/3.0 animations: ^{
            self.xibView.transform = CGAffineTransformMakeScale(0.001, 0.001);
        }];
        
        [UIView animateWithDuration:0.1 animations:^{
            self.closeBtn.alpha = 0.0;
        }];
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];

    if (self.dismissBlock) {
        self.dismissBlock();
    }
}


@end
