//
//  SH_ProfitAlertView.m
//  GameBox
//
//  Created by jun on 2018/7/17.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_ProfitAlertView.h"
#import "SH_SaftyCenterView.h"
#import "SH_BigWindowViewController.h"
#import "SH_TopLevelControllerManager.h"
@interface SH_ProfitAlertView()
@property (weak, nonatomic) IBOutlet UILabel *lab;

@end
@implementation SH_ProfitAlertView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.lab.layer.borderWidth = 2;
    self.lab.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.25].CGColor;
}
- (IBAction)sureBtnClick:(SH_WebPButton *)sender {
    if (sender.tag == 100) {
        [self popAlertView];
        return;
    }
     UIViewController * svc= [SH_TopLevelControllerManager  fetchTopLevelController];
    [svc dismissViewControllerAnimated:NO completion:nil];
}

-(void)popAlertView {
    SH_SaftyCenterView *view = [[NSBundle mainBundle]loadNibNamed:@"SH_SaftyCenterView" owner:self options:nil].firstObject;
    SH_BigWindowViewController * acr = [SH_BigWindowViewController  new];
    acr.customView = view;
    acr.titleImageName = @"title03";
    acr.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    acr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
     UIViewController * svc= [SH_TopLevelControllerManager  fetchTopLevelController];
    [svc presentViewController:acr animated:YES completion:nil];
    [view selectedWithType:@"setSafePsw" From:@"setSafePsw"];
}

- (void)updateUIWithDetailArray:(NSArray *)details
                       TargetVC:(UIViewController *)targetVC
                          Token:(NSString *)token {
}
- (void)setContent:(NSString *)content{
    _content = content;
    self.lab.text = content;
}
@end
