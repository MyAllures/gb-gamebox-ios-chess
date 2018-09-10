//
//  SH_ConfirSaftyPassWordView.m
//  GameBox
//
//  Created by jun on 2018/7/24.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_ConfirSaftyPassWordView.h"
#import "SH_NetWorkService+Profit.h"
#import "SH_ProfitAlertView.h"
#import "SH_NetWorkService+Home.h"
#import "SH_NetWorkService+RegistAPI.h"

#import "SH_SmallWindowViewController.h"
#import "SH_BigWindowViewController.h"
#import "SH_TopLevelControllerManager.h"
@interface SH_ConfirSaftyPassWordView()
@property (weak, nonatomic) IBOutlet UITextField *pswTF;

@end
@implementation SH_ConfirSaftyPassWordView


- (IBAction)sureBtnClick:(SH_WebPButton *)sender {
    [sender setScale];
    if (self.pswTF.text.length == 0) {
        showMessage(self, @"请输入安全密码", nil);
    }else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *saftyKoken = [defaults objectForKey:@"saftyKoken"];
        if (saftyKoken.length > 0) {
            self.token = saftyKoken;
        }
        [SH_NetWorkService sureOutCoinMoney:self.money SaftyPWD:self.pswTF.text Token:self.token Way:@"1" Success:^(NSHTTPURLResponse *httpURLResponse, id response) {
            NSString *message = response[@"message"];
            NSDictionary *dic = ConvertToClassPointer(NSDictionary, response);
            NSLog(@"%@",dic);
            NSString *code = [NSString stringWithFormat:@"%@",dic[@"code"]];
            if ([code isEqualToString:@"0"]) {
                showMessage(self, @"取款成功", nil);
                [self refreshBalance];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:@"" forKey:@"saftyKoken"];
                [defaults synchronize];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    UIViewController *vc = [SH_TopLevelControllerManager fetchTopLevelController];
                    while (vc.presentingViewController) {
                        if ([vc isKindOfClass:[UINavigationController class]]) {
                            break;
                            
                        }
                        vc = vc.presentingViewController;
                    }
                    [vc dismissViewControllerAnimated:NO completion:nil];
                });
            } else {
                self.token = dic[@"data"][@"token"];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:self.token forKey:@"saftyKoken"];
                [defaults synchronize];
                [self popAlertView:message];
            }
        } Failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            
        }];
    }
}

-(void) refreshBalance {
    [SH_NetWorkService onekeyrecoveryApiId:nil Success:^(NSHTTPURLResponse *httpURLResponse, id response) {
        //刷新用户余额
        if (![[response objectForKey:@"data"] isKindOfClass:[NSNull class]]) {
            //            weakSelf.suishenFuLiLab.text = response[@"data"][@"assets"];
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
    [SH_NetWorkService fetchUserInfo:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary * dict = ConvertToClassPointer(NSDictionary, response);
        if ([dict[@"code"] isEqualToString:@"0"]) {
            NSError *err;
            NSArray *arr = [SH_BankListModel arrayOfModelsFromDictionaries:response[@"data"][@"bankList"] error:&err];
            [[RH_UserInfoManager shareUserManager] setBankList:arr];
            NSError *err2;
            RH_MineInfoModel * model = [[RH_MineInfoModel alloc] initWithDictionary:[response[@"data"] objectForKey:@"user"] error:&err2];
            [[RH_UserInfoManager  shareUserManager] setMineSettingInfo:model];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshBalance" object:nil];
        }else{
            [[RH_UserInfoManager  shareUserManager] updateIsLogin:false];
        }
        
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        //
        [[RH_UserInfoManager  shareUserManager] updateIsLogin:false];
    }];
}

-(void)popAlertView: (NSString *)content{
    SH_ProfitAlertView *view = [[NSBundle mainBundle]loadNibNamed:@"SH_ProfitAlertView" owner:self options:nil].lastObject;
    view.content = content;
    if ([content containsString:@"未设置安全密码"]) {
        view.sureBtn.tag = 100;
    }
    SH_SmallWindowViewController *acr = [SH_SmallWindowViewController new];
    acr.customView = view;
    acr.titleImageName = @"title03";
    acr.contentHeight = 202;
    acr.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    acr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    UIViewController * svc = [SH_TopLevelControllerManager fetchTopLevelController];
    [svc presentViewController:acr animated:YES completion:nil];
    [view updateUIWithDetailArray:nil TargetVC:nil Token:nil];
}

- (void)updateUIWithDetailArray:(NSArray *)details
                       TargetVC:(UIViewController *)targetVC
                          Token:(NSString *)token{
}

- (void)setMoney:(NSString *)money{
    _money = money;
}
- (void)setToken:(NSString *)token{
    _token = token;
}
@end
