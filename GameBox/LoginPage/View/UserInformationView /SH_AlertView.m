//
//  SH_AlertView.m
//  GameBox
//
//  Created by Paul on 2018/7/14.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_AlertView.h"
#import "SH_NetWorkService+RegistAPI.h"
@interface  SH_AlertView()
@property (weak, nonatomic) IBOutlet UILabel *content_label;

@end
@implementation SH_AlertView
+(instancetype)instanceAlertView{
    return [[[NSBundle  mainBundle] loadNibNamed:NSStringFromClass([self  class]) owner:nil options:nil] lastObject];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)buttonClick:(UIButton *)sender {

    if (sender.tag == 100) {
        [self.vc close:nil];
    }else{
        __weak typeof(self) weakSelf = self;
        MBProgressHUD * activityIndicatorView= showHUDWithMyActivityIndicatorView(self.window, nil, @"正在退出...");
        [SH_NetWorkService  fetchUserLoginOut:^(NSHTTPURLResponse *httpURLResponse, id response) {
            [activityIndicatorView hideAnimated:false];
            [[RH_UserInfoManager  shareUserManager] updateIsLogin:false];
            [[RH_UserInfoManager  shareUserManager] setMineSettingInfo:nil];
            /*  [[NSUserDefaults  standardUserDefaults] setObject:@"" forKey:@"password"];
             [[NSUserDefaults  standardUserDefaults] synchronize];*/
//            [weakSelf configUI];
            [[NSNotificationCenter  defaultCenter] postNotificationName:@"didLogOut" object:nil];
            showMessage([UIApplication  sharedApplication].keyWindow, @"已成功退出", nil);
            if ([weakSelf.vc respondsToSelector:@selector(presentingViewController)]){
                [weakSelf.vc.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
            }else {
                [weakSelf.vc.parentViewController.parentViewController dismissViewControllerAnimated:NO completion:nil];
            }
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            [activityIndicatorView hideAnimated:false];
            showMessage([UIApplication  sharedApplication].keyWindow, @"退出失败", nil);
        }];
    }
    
}

@end
