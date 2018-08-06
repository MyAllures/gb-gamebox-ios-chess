//
//  SH_FindPSWView.m
//  GameBox
//
//  Created by jun on 2018/7/24.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_FindPSWView.h"
#import "SH_FindPSWSendCodeView.h"
#import "AlertViewController.h"
#import "SH_SafeCenterAlertView.h"
@interface SH_FindPSWView ()
@property (weak, nonatomic) IBOutlet UITextField *realNameTV;
@end

@implementation SH_FindPSWView

- (IBAction)nextAction:(id)sender {
    if (self.realNameTV.text.length > 0) {
        [SH_NetWorkService_FindPsw findUserPhone:self.realNameTV.text complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
            NSDictionary *dict = (NSDictionary *)response;
            NSLog(@"dict===%@",dict);
            NSString *code = dict[@"code"];
            if ([code intValue] == 0) {

                [SH_NetWorkService_FindPsw forgetPswSendCode:dict[@"data"][@"encryptedId"] complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
                    NSDictionary *dict1 = (NSDictionary *)response;
                    NSLog(@"dict1===%@",dict1);
                    NSString *code = dict1[@"code"];
                    if ([code intValue] == 0) {
                        SH_FindPSWSendCodeView *view = [[[NSBundle mainBundle]loadNibNamed:@"SH_FindPSWSendCodeView" owner:nil options:nil] lastObject];
                        AlertViewController *acr  = [[AlertViewController  alloc] initAlertView:view viewHeight:200 titleImageName:@"title19" alertViewType:AlertViewTypeShort];
                        view.targetVC2 = acr;
                        view.encryptedId = dict[@"data"][@"encryptedId"];
                        view.phoneStr = dict[@"data"][@"phone"];
                        acr.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                        acr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                        [self.targetVC1 presentViewController:acr animated:YES completion:nil];
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        [defaults setObject:self.realNameTV.text forKey:@"userName"];
                        [defaults synchronize];
                    } else {
                        [self popAlertView:dict1[@"message"]];
                    }
                } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {

                }];
            } else {
                showMessage(self, @"", dict[@"message"]);
            }

        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {

        }];

    } else {
        showMessage(self, @"", @"请输入账号");
    }
}


-(void)popAlertView:(NSString *)context {
    SH_SafeCenterAlertView * alert = [SH_SafeCenterAlertView  instanceSafeCenterAlertView];
    AlertViewController * acr = [[AlertViewController  alloc] initAlertView:alert viewHeight:174 titleImageName:@"title03" alertViewType:AlertViewTypeShort];
    alert.vc = acr;
    alert.context = context;
    acr.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    acr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.targetVC1 presentViewController:acr animated:YES completion:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
