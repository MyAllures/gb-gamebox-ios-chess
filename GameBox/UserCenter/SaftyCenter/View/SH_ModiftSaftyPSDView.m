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
#import "AlertViewController.h"
#import "SH_GamesHomeViewController.h"
@interface SH_ModiftSaftyPSDView()
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


@end
@implementation SH_ModiftSaftyPSDView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.verificationCodeLab.hidden = YES;
    self.verificationCodeTF.hidden = YES;
    self.verificationBtn.hidden = YES;
    self.sureBtnTopDistance.constant = 15;
    [self updateView];
    
    
//    SH_ProfitAlertView *view = [[NSBundle mainBundle]loadNibNamed:@"SH_ProfitAlertView" owner:self options:nil].firstObject;
//    view.content = content;
//    view.targetVC = self.targetVC;
//    AlertViewController *acr  = [[AlertViewController  alloc] initAlertView:view viewHeight:202 titleImageName:@"title03" alertViewType:AlertViewTypeShort];
//    acr.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    acr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [self.targetVC presentViewController:acr animated:YES completion:nil];
}

-(void)drawRect:(CGRect)rect {
    NSLog(@"comeFromVC===%@",self.comeFromVC);
//    if([RH_UserInfoManager shareUserManager].mineSettingInfo.realName.length > 0){
//
//    } else {
//        SH_FillRealNameView *view = [[[NSBundle mainBundle] loadNibNamed:@"SH_FillRealNameView" owner:nil options:nil] lastObject];
//        AlertViewController *acr = [[AlertViewController alloc] initAlertView:view viewHeight:202 titleImageName:@"title18" alertViewType:AlertViewTypeShort];
//        view.targetVC1 = acr;
//        acr.shutBtn.hidden = YES;
//        acr.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//        acr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//        [self.targetVC presentViewController:acr animated:YES completion:nil];
//    }
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

- (IBAction)sureBtnClick:(id)sender {
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
        [SH_NetWorkService setSaftyPasswordRealName:realName originPassword:self.currentTF.text newPassword:self.NewTF.text confirmPassword:self.sureTF.text verifyCode:@"" Success:^(NSHTTPURLResponse *httpURLResponse, id response) {
            NSString *code = response[@"code"];
            NSString *message  = response[@"message"];
            if ([code isEqualToString:@"0"]) {
                showMessage(self, @"设置成功", nil);
                RH_UserSafetyCodeModel *model = [[RH_UserSafetyCodeModel alloc]initWithDictionary:response[@"data"] error:nil];
                [[RH_UserInfoManager shareUserManager] setUserSafetyInfo:model];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([self.comeFromVC isEqualToString:@"setSafePsw"]) {
                        [self.targetVC.presentingViewController dismissViewControllerAnimated:NO completion:nil];
                    }
                    else{
                        UIViewController *vc = self.targetVC;
                        while (vc.presentingViewController) {
                            if ([vc isKindOfClass:[UINavigationController class]]) {
                                break;
                                
                            }
                            vc = vc.presentingViewController;
                        }
                        [vc dismissViewControllerAnimated:NO completion:nil];
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
- (void)setTargetVC:(UIViewController *)targetVC{
    _targetVC = targetVC;
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
    __weak typeof(self) weakSelf = self;
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
                [weakSelf.verificationBtn setImage:image forState:UIControlStateNormal];
            });
        });
        
    } Fail:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];

}
- (IBAction)verificationBtnClick:(id)sender {
    [self verificationImage];
}

@end
