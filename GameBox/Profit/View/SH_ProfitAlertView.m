//
//  SH_ProfitAlertView.m
//  GameBox
//
//  Created by jun on 2018/7/17.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_ProfitAlertView.h"
#import "SH_SaftyCenterView.h"
#import "AlertViewController.h"

@interface SH_ProfitAlertView()
@property (weak, nonatomic) IBOutlet UILabel *lab;

@end
@implementation SH_ProfitAlertView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.lab.layer.borderWidth = 2;
    self.lab.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.25].CGColor;
}
- (void)setTargetVC:(UIViewController *)targetVC{
    self.lab.text = self.content;
    _targetVC = targetVC;
}
- (IBAction)sureBtnClick:(SH_WebPButton *)sender {
    if (sender.tag == 100) {
        [self popAlertView];
        return;
    }
    [self.targetVC dismissViewControllerAnimated:NO completion:nil];
}

-(void)popAlertView {
    SH_SaftyCenterView *view = [[NSBundle mainBundle]loadNibNamed:@"SH_SaftyCenterView" owner:self options:nil].firstObject;
    view.targetVC = self.targetVC;
    AlertViewController *acr  = [[AlertViewController  alloc] initAlertView:view viewHeight:[UIScreen mainScreen].bounds.size.height-60 titleImageName:@"title03" alertViewType:AlertViewTypeLong];
    acr.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    acr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.targetVC presentViewController:acr animated:YES completion:nil];
    [view selectedWithType:@"setSafePsw" From:@"setSafePsw"];
}

- (void)updateUIWithDetailArray:(NSArray *)details
                       TargetVC:(UIViewController *)targetVC
                          Token:(NSString *)token {
    self.targetVC = targetVC;
}

@end
