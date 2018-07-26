
//
//  SH_FindPSWSendCodeView.m
//  GameBox
//
//  Created by sam on 2018/7/24.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_FindPSWSendCodeView.h"
#import "AlertViewController.h"
#import "SH_FindPSWSureView.h"
@interface SH_FindPSWSendCodeView()
@property (weak, nonatomic) IBOutlet UIButton *verificationBtn;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *codeTV;

@end

@implementation SH_FindPSWSendCodeView
- (IBAction)nextAction:(id)sender {
    [SH_NetWorkService_FindPsw forgetPswCheckCode:self.codeTV.text complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary *dict1 = (NSDictionary *)response;
        NSLog(@"dict1===%@",dict1);
        NSString *code = dict1[@"code"];
        if ([code isEqualToString:@"0"]) {
            SH_FindPSWSureView *view = [[[NSBundle mainBundle]loadNibNamed:@"SH_FindPSWSureView" owner:nil options:nil] lastObject];
            AlertViewController *acr  = [[AlertViewController  alloc] initAlertView:view viewHeight:200 titleImageName:@"title19" alertViewType:AlertViewTypeShort];
            view.targetVC3 = acr;
            acr.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            acr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self.targetVC2 presentViewController:acr animated:YES completion:nil];
        } else {
            showMessage(self, @"", dict1[@"message"]);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];

}

- (IBAction)sendVerification:(id)sender {
    [self.verificationBtn startCountDownTime:60 withCountDownBlock:^{
        [SH_NetWorkService_FindPsw forgetPswSendCode:self.encryptedId complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
            NSDictionary *dict1 = (NSDictionary *)response;
            NSLog(@"dict1===%@",dict1);
//            NSString *code = dict1[@"code"];
//            if ([code isEqualToString:@"0"]) {
//
//            } else {
//
//            }
            showMessage(self, @"", dict1[@"message"]);
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            
        }];
    }];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.phoneLabel.text = self.phoneStr;
}


@end
