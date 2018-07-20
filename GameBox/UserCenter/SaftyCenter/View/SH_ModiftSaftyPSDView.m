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
@interface SH_ModiftSaftyPSDView()
@property (weak, nonatomic) IBOutlet UITextField *realNameTF;
@property (weak, nonatomic) IBOutlet UITextField *currentTF;
@property (weak, nonatomic) IBOutlet UITextField *NewTF;
@property (weak, nonatomic) IBOutlet UITextField *sureTF;
@property (weak, nonatomic) IBOutlet UILabel *currentLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDistance;

@end
@implementation SH_ModiftSaftyPSDView

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)updateView{
    if([RH_UserInfoManager shareUserManager].userSafetyInfo.hasPermissionPwd){
        //设置过安全密码
        self.topDistance.constant = 110;
        
    }else{
        //没有设置过安全密码
        self.topDistance.constant = 70;
        self.currentTF.hidden = YES;
        self.currentLab.hidden = YES;
        
    }
}

- (IBAction)sureBtnClick:(id)sender {
    if (self.realNameTF.text.length == 0) {
        showMessage(self, @"请输入真实姓名", nil);
    }else if (self.NewTF.text.length == 0){
        showMessage(self, @"请输入新密码", nil);
    }else if (self.sureTF.text.length == 0){
        showMessage(self, @"请确认新密码", nil);
    }else if (![self.NewTF.text isEqualToString:self.sureTF.text]){
        showMessage(self, @"请输入相同密码", nil);
    }else{
        if([RH_UserInfoManager shareUserManager].userSafetyInfo.hasPermissionPwd){
           //设置过安全密码
            if (self.currentTF.text.length == 0){
                showMessage(self, @"请输入当前密码", nil);
                return;
            }
        }
        [SH_NetWorkService setSaftyPasswordRealName:self.realNameTF.text originPassword:self.currentTF.text newPassword:self.NewTF.text confirmPassword:self.sureTF.text verifyCode:@"" Success:^(NSHTTPURLResponse *httpURLResponse, id response) {
            NSString *code = response[@"code"];
            NSString *message  = response[@"message"];
            if ([code isEqualToString:@"0"]) {
                showMessage(self, @"设置成功", nil);
                RH_UserSafetyCodeModel *model = [[RH_UserSafetyCodeModel alloc]initWithDictionary:response[@"data"] error:nil];
                [[RH_UserInfoManager shareUserManager] setUserSafetyInfo:model];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.targetVC dismissViewControllerAnimated:NO completion:nil];
                });
            }else{
                showMessage(self, message, nil);
            }
            
        } Fail:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            
        }];
    }
}
- (void)setTargetVC:(UIViewController *)targetVC{
    _targetVC = targetVC;
}
@end
