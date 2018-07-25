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
            if ([code isEqualToString:@"0"]) {

                [SH_NetWorkService_FindPsw forgetPswSendCode:dict[@"data"][@"encryptedId"] complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
                    NSDictionary *dict1 = (NSDictionary *)response;
                    NSLog(@"dict1===%@",dict1);
                    NSString *code = dict1[@"code"];
                    if ([code isEqualToString:@"0"]) {
                        SH_FindPSWSendCodeView *view = [[[NSBundle mainBundle]loadNibNamed:@"SH_FindPSWSendCodeView" owner:nil options:nil] lastObject];
                        AlertViewController *acr  = [[AlertViewController  alloc] initAlertView:view viewHeight:200 titleImageName:@"outCoinDetail" alertViewType:AlertViewTypeShort];
                        view.targetVC2 = acr;
                        view.encryptedId = dict[@"data"][@"encryptedId"];
                        view.phoneStr = dict1[@"data"];
                        acr.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                        acr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                        [self.targetVC1 presentViewController:acr animated:YES completion:nil];
                    } else{
                        showMessage(self, @"", dict1[@"message"]);
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
