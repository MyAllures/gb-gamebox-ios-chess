//
//  SH_ModifyLoginPSDView.m
//  GameBox
//
//  Created by jun on 2018/7/17.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_ModifyLoginPSDView.h"
#import "SH_NetWorkService+SaftyCenter.h"
#import "SH_NetWorkService+RegistAPI.h"
#import "SH_TopLevelControllerManager.h"
@interface SH_ModifyLoginPSDView()
@property (weak, nonatomic) IBOutlet UITextField *currentTX;
@property (weak, nonatomic) IBOutlet UITextField *NewTX;
@property (weak, nonatomic) IBOutlet UITextField *sureTX;
@property (weak, nonatomic) IBOutlet UILabel *verificationLab;
@property (weak, nonatomic) IBOutlet UITextField *verificationTF;
@property (weak, nonatomic) IBOutlet UIButton *verificationBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sureBtnTopDistance;

@end
@implementation SH_ModifyLoginPSDView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.verificationLab.hidden = YES;
    self.verificationTF.hidden = YES;
    self.verificationBtn.hidden = YES;
    self.sureBtnTopDistance.constant = 15;
}
- (IBAction)sureBtnClick:(id)sender {
    if (self.currentTX.text.length == 0) {
        showMessage(self, @"请输入当前密码", nil);
    }else if (self.NewTX.text.length == 0){
        showMessage(self, @"请输入新密码", nil);
    }else if (self.sureTX.text.length == 0){
        showMessage(self, @"请再次输入新密码", nil);
    }else if (self.sureTX.text.length < 6 || self.NewTX.text.length < 6){
        showMessage(self, @"密码至少6位数", nil);
    } else if (![self.sureTX.text isEqualToString:self.NewTX.text]){
        showMessage(self, @"两次输入的密码不一致", nil);
    } else {
//        if ([self.NewTX.text isEqualToString:self.sureTX.text]) {
            [SH_NetWorkService updatePassword:self.currentTX.text NewPassword:self.NewTX.text VerificationCode:self.verificationTF.text Success:^(NSHTTPURLResponse *httpURLResponse, id response) {
                NSString *code = [NSString stringWithFormat:@"%@",response[@"code"]];
                if ([code isEqualToString:@"0"]) {
                    showMessage(self, @"修改成功", nil);
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:self.NewTX.text forKey:@"password"];
                    [defaults synchronize];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                         UIViewController * svc= [SH_TopLevelControllerManager  fetchTopLevelController];
                          [svc.presentingViewController dismissViewControllerAnimated:NO completion:nil];
                    });
                  
                }else{
                    if ([code isEqualToString:@"1301"]||[code isEqualToString:@"1308"]||[code isEqualToString:@"1016"]||[code isEqualToString:@"1311"]) {
                        showMessage(self, [NSString stringWithFormat:@"%@",response[@"message"]], nil);
                    } else {
                        NSString *isOpenCaptcha = [NSString stringWithFormat:@"%@",response[@"data"][@"isOpenCaptcha"]];//是否需要输入验证码
                        if ([isOpenCaptcha isEqualToString:@"1"]) {
                            [self updateModifyLoginView];
                            [self getLoginVerificationCode];
                        }
                        showMessage(self, [NSString stringWithFormat:@"%@",response[@"message"]], nil);
                    }
                }
            } Fail:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
                
            }];
//        }else{
//             showMessage(self, @"请输入相同的新密码", nil);
//        }
    }
}

- (IBAction)verificationBtnClick:(id)sender {
    [self getLoginVerificationCode];
}
//获取验证码
-(void)getLoginVerificationCode{
    [SH_NetWorkService fetchVerifyCode:^(NSHTTPURLResponse *httpURLResponse, id response) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            __block UIImage *image = [[UIImage alloc]init];
            NSData *imageData = (NSData *)response;
            if (imageData) {
                image = [UIImage imageWithData:imageData];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.verificationBtn setImage:image forState:UIControlStateNormal];
            });
        });
        
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
}
//更新UI 让验证码显示出来
-(void)updateModifyLoginView{
    self.verificationLab.hidden = NO;
    self.verificationTF.hidden = NO;
    self.verificationBtn.hidden = NO;
    self.sureBtnTopDistance.constant = 55;
}
@end
