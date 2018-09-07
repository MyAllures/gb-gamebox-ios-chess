//
//  SH_ModiftSaftyPSDView.m
//  GameBox
//
//  Created by jun on 2018/7/17.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_ModiftSaftyPSDView.h"
#import "SH_NetWorkService+SaftyCenter.h"
#import "RH_UserSafetyCodeModel.h"
#import "SH_FillRealNameView.h"
#import "SH_GamesHomeViewController.h"
#import "SH_SmallWindowViewController.h"
#import "SH_TopLevelControllerManager.h"
#import "SH_BigWindowViewController.h"
@interface SH_ModiftSaftyPSDView()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *currentTF;
@property (weak, nonatomic) IBOutlet UITextField *NewTF;
@property (weak, nonatomic) IBOutlet UITextField *sureTF;
@property (weak, nonatomic) IBOutlet UILabel *currentLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDistance;
@property (weak, nonatomic) IBOutlet UILabel *verificationCodeLab;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sureBtnTopDistance;
@property (weak, nonatomic) IBOutlet UIButton *verificationBtn;
@property (weak, nonatomic) IBOutlet UILabel *realNameLabel;
@property (weak, nonatomic) IBOutlet SH_WebPButton *setBtn;


@end
@implementation SH_ModiftSaftyPSDView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.verificationCodeLab.hidden = YES;
    self.verificationCodeTF.hidden = YES;
    self.verificationBtn.hidden = YES;
    self.sureBtnTopDistance.constant = 15;
    [self updateView];
    self.NewTF.delegate = self;
    self.sureTF.delegate = self;
    if([RH_UserInfoManager shareUserManager].userSafetyInfo.hasPermissionPwd){
        //设置过安全密码
        [self.setBtn setTitle:@"修改" forState:UIControlStateNormal];
    }else{
        //没有设置过安全密码
        [self.setBtn setTitle:@"设置" forState:UIControlStateNormal];
    }
    
}



- (void)updateView{
    if([RH_UserInfoManager shareUserManager].userSafetyInfo.hasPermissionPwd){
        //设置过安全密码
        self.topDistance.constant = 70;
        self.currentTF.hidden = NO;
        self.currentLab.hidden = NO;
        self.realNameTF.hidden = YES;
        [self.realNameLabel setHidden:YES];
    }else{
        //没有设置过安全密码
        self.topDistance.constant = 30;
        self.currentTF.hidden = YES;
        self.currentLab.hidden = YES;
        self.realNameTF.hidden = YES;
        [self.realNameLabel setHidden:YES];
    }
}

- (IBAction)sureBtnClick:(SH_WebPButton *)sender {
    [sender setScale];
    if([RH_UserInfoManager shareUserManager].mineSettingInfo.realName.length > 0){
        
    } else {
        SH_FillRealNameView *view = [[[NSBundle mainBundle] loadNibNamed:@"SH_FillRealNameView" owner:nil options:nil] lastObject];
        SH_SmallWindowViewController *acr = [SH_SmallWindowViewController new];
        acr.contentHeight = 202;
        acr.titleImageName = @"title18";
        acr.customView = view;
        acr.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        acr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
         UIViewController * svc= [SH_TopLevelControllerManager  fetchTopLevelController];
        [svc presentViewController:acr animated:YES completion:nil];
        return;
    }
    
    if (self.NewTF.text.length == 0){
        showMessage(self, @"请输入新密码", nil);
    } else if (self.sureTF.text.length == 0){
        showMessage(self, @"请确认新密码", nil);
    } else if (self.sureTF.text.length < 6 || self.NewTF.text.length < 6){
        showMessage(self, @"密码至少6位数", nil);
    } else if (![self.NewTF.text isEqualToString:self.sureTF.text]){
        showMessage(self, @"请输入相同密码", nil);
    } else {
        NSString *realName;
        if([RH_UserInfoManager shareUserManager].mineSettingInfo.realName.length > 0){
            realName  = [RH_UserInfoManager shareUserManager].mineSettingInfo.realName;
        }
//        __weak typeof(self) weakSelf = self;
        [SH_NetWorkService setSaftyPasswordRealName:realName originPassword:self.currentTF.text newPassword:self.NewTF.text confirmPassword:self.sureTF.text verifyCode:self.verificationCodeTF.text Success:^(NSHTTPURLResponse *httpURLResponse, id response) {
            NSString *code = response[@"code"];
            NSString *message  = response[@"message"];
            if ([code isEqualToString:@"0"]) {
                showMessage(self, @"设置成功", nil);
                RH_UserSafetyCodeModel *model = [[RH_UserSafetyCodeModel alloc]initWithDictionary:response[@"data"] error:nil];
                [[RH_UserInfoManager shareUserManager] setUserSafetyInfo:model];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([self.comeFromVC isEqualToString:@"setSafePsw"]) {
                        UIViewController * svc= [SH_TopLevelControllerManager  fetchTopLevelController];
                        while (svc.presentingViewController) {
                            svc = svc.presentingViewController;
                            if ([svc.presentingViewController isKindOfClass:[SH_SmallWindowViewController class]]) {
                                SH_SmallWindowViewController *vc = (SH_SmallWindowViewController *)svc.presentingViewController;
                                [vc dismissViewControllerAnimated:NO completion:nil];
                                break;
                            }
                        }
                    }
                    else{
                         UIViewController * svc= [SH_TopLevelControllerManager  fetchTopLevelController];
                        while (svc.presentingViewController) {
                            if ([svc isKindOfClass:[UINavigationController class]]) {
                                break;
                                
                            }
                            svc = svc.presentingViewController;
                        }
                        [svc dismissViewControllerAnimated:NO completion:nil];
                    }
                });
            }else{
                NSString *isOpenCaptcha = [NSString stringWithFormat:@"%@",response[@"data"][@"isOpenCaptcha"]];//是否需要输入验证码
                if ([isOpenCaptcha isEqualToString:@"1"]) {
                    [self updateSaftyView];
                    [self verificationImage];
                }
                showMessage(self, message, nil);
            }
            
        } Fail:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            
        }];
    }
}
-(void)updateSaftyView{
    //当需要验证码的时候刷新UI布局
    self.verificationCodeLab.hidden = NO;
    self.verificationCodeTF.hidden = NO;
    self.verificationBtn.hidden = NO;
    self.sureBtnTopDistance.constant = 55;
    [self layoutIfNeeded];
}
//设置验证码
-(void)verificationImage{
    //获取验证码接口
    [SH_NetWorkService getSaftyVericationCodeSuccess:^(NSHTTPURLResponse *httpURLResponse, id response) {
        __block UIImage *image = [[UIImage alloc]init];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSData *imageData = (NSData *)response;
            if (imageData) {
                image = [UIImage imageWithData:imageData];
            }
            //回到主线程更新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.verificationBtn setImage:image forState:UIControlStateNormal];
            });
        });
        
    } Fail:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];

}
- (IBAction)verificationBtnClick:(id)sender {
    [self verificationImage];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if([RH_UserInfoManager shareUserManager].mineSettingInfo.realName.length > 0){
        return YES;
    } else {
        SH_FillRealNameView *view = [[[NSBundle mainBundle] loadNibNamed:@"SH_FillRealNameView" owner:nil options:nil] lastObject];
        SH_SmallWindowViewController * acr = [SH_SmallWindowViewController new];
        acr.customView = view;
        acr.contentHeight = 202;
        acr.titleImageName = @"title18";
        acr.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        acr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
         UIViewController * svc= [SH_TopLevelControllerManager  fetchTopLevelController];
        [svc presentViewController:acr animated:YES completion:nil];
        return NO;
    }
}

@end
