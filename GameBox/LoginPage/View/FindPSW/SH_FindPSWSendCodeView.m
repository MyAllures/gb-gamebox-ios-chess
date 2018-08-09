
//
//  SH_FindPSWSendCodeView.m
//  GameBox
//
//  Created by sam on 2018/7/24.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_FindPSWSendCodeView.h"
#import "SH_FindPSWSureView.h"
#import "SH_SmallWindowViewController.h"
#import "SH_TopLevelControllerManager.h"
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
            SH_SmallWindowViewController * acr = [SH_SmallWindowViewController new];
            acr.contentHeight = 200;
            acr.customView = view;
            acr.titleImageName = @"title19";
            acr.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            acr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
             UIViewController * svc = [SH_TopLevelControllerManager fetchTopLevelController];
            [svc presentViewController:acr animated:YES completion:nil];
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
            NSString *code = dict1[@"code"];
            if ([code isEqualToString:@"0"]) {
                showMessage(self, @"短信发送成功", nil);
            } else {
                showMessage(self, @"", dict1[@"message"]);
            }
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
