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
    }else{
        if ([self.NewTX.text isEqualToString:self.sureTX.text]) {
            [SH_NetWorkService updatePassword:self.currentTX.text NewPassword:self.NewTX.text VerificationCode:self.verificationTF.text Success:^(NSHTTPURLResponse *httpURLResponse, id response) {
                NSString *code = [NSString stringWithFormat:@"%@",response[@"code"]];
                if ([code isEqualToString:@"0"]) {
                    showMessage(self, @"修改成功", nil);
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:self.NewTX.text forKey:@"password"];
                    [defaults synchronize];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                          [self.targetVC dismissViewControllerAnimated:NO completion:nil];
                    });
                  
                }else{
                    NSString *isOpenCaptcha = [NSString stringWithFormat:@"%@",response[@"data"][@"isOpenCaptcha"]];//是否需要输入验证码
                    if ([isOpenCaptcha isEqualToString:@"1"]) {
                        [self updateModifyLoginView];
                        [self getLoginVerificationCode];
                    }
                     showMessage(self, [NSString stringWithFormat:@"%@",response[@"message"]], nil);
                }
            } Fail:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
                
            }];
        }else{
             showMessage(self, @"请输入相同的新密码", nil);
        }
    }
}
- (void)setTargetVC:(UIViewController *)targetVC{
    _targetVC = targetVC;
}
- (IBAction)verificationBtnClick:(id)sender {
    [self getLoginVerificationCode];
}
//获取验证码
-(void)getLoginVerificationCode{
    __weak typeof(self) weakSelf = self;
    [SH_NetWorkService fetchVerifyCode:^(NSHTTPURLResponse *httpURLResponse, id response) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            __block UIImage *image = [[UIImage alloc]init];
            NSData *imageData = (NSData *)response;
            if (imageData) {
                image = [UIImage imageWithData:imageData];
            }
            //回到主线程更新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.verificationBtn setImage:image forState:UIControlStateNormal];
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
