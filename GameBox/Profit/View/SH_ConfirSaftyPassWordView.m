//
//  SH_ConfirSaftyPassWordView.m
//  GameBox
//
//  Created by jun on 2018/7/24.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_ConfirSaftyPassWordView.h"
#import "SH_NetWorkService+Profit.h"
#import "AlertViewController.h"
#import "SH_ProfitAlertView.h"

@interface SH_ConfirSaftyPassWordView()
@property (weak, nonatomic) IBOutlet UITextField *pswTF;

@end
@implementation SH_ConfirSaftyPassWordView


- (IBAction)sureBtnClick:(id)sender {
    if (self.pswTF.text.length == 0) {
        showMessage(self, @"请输入安全密码", nil);
    }else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *saftyKoken = [defaults objectForKey:@"saftyKoken"];
        if (saftyKoken.length > 0) {
            self.token = saftyKoken;
        }
        [SH_NetWorkService sureOutCoinMoney:self.money SaftyPWD:self.pswTF.text Token:self.token Way:@"1" Success:^(NSHTTPURLResponse *httpURLResponse, id response) {
            showMessage(self, [NSString stringWithFormat:@"%@",response[@"message"]], nil);
            NSString *message = response[@"message"];
            
            NSDictionary *dic = ConvertToClassPointer(NSDictionary, response);
            NSLog(@"%@",dic);
            NSString *code = [NSString stringWithFormat:@"%@",dic[@"code"]];
            if ([code isEqualToString:@"0"]) {
                showMessage(self, @"取款成功", nil);
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:@"" forKey:@"saftyKoken"];
                [defaults synchronize];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    UIViewController *vc = self.targetVC;
                    int count = 0;
                    while (vc.presentingViewController) {
                        count ++;
                        vc = vc.presentingViewController;
                        if ([vc isKindOfClass:[AlertViewController class]]) {
                            self.targetVC = vc;
                            if ([self.comeFromVC isEqualToString:@"profit"] && count <= 2) {
                                [self.targetVC dismissViewControllerAnimated:NO completion:nil];
                            } else {
                               [self.targetVC dismissViewControllerAnimated:NO completion:nil];
                            }
                        } else {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"close" object:nil];
                        }
                    }
                });
            } else {
                self.token = dic[@"data"][@"token"];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:self.token forKey:@"saftyKoken"];
                [defaults synchronize];
                if ([message containsString:@"未设置安全密码"]) {
                    [self popAlertView:message];
                }
            }
        } Failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            
        }];
    }
}


-(void)popAlertView: (NSString *)content{
    SH_ProfitAlertView *view = [[NSBundle mainBundle]loadNibNamed:@"SH_ProfitAlertView" owner:self options:nil].lastObject;
    view.content = content;
    view.sureBtn.tag = 100;
    view.targetVC = self.targetVC;
    AlertViewController *acr  = [[AlertViewController  alloc] initAlertView:view viewHeight:202 titleImageName:@"title03" alertViewType:AlertViewTypeShort];
    acr.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    acr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.targetVC presentViewController:acr animated:YES completion:nil];
    [view updateUIWithDetailArray:nil TargetVC:acr Token:nil];
}

- (void)updateUIWithDetailArray:(NSArray *)details
                       TargetVC:(UIViewController *)targetVC
                          Token:(NSString *)token{
    self.targetVC = targetVC;
}

- (void)setMoney:(NSString *)money{
    _money = money;
}
- (void)setToken:(NSString *)token{
    _token = token;
}
- (void)setTargetVC:(UIViewController *)targetVC{
    _targetVC = targetVC;
}
@end
