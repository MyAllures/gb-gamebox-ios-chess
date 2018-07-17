//
//  SH_ProfitAlertView.m
//  GameBox
//
//  Created by jun on 2018/7/17.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_ProfitAlertView.h"

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
    _targetVC = targetVC;
}
- (IBAction)sureBtnClick:(id)sender {
    [self.targetVC dismissViewControllerAnimated:NO completion:nil];
}
@end
