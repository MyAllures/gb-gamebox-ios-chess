//
//  SH_UserInformationView.m
//  GameBox
//
//  Created by Paul on 2018/7/13.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_UserInformationView.h"
#import "SH_NetWorkService+RegistAPI.h"
#import "SH_AlertView.h"
#import "SH_SettingView.h"
#import "UIImage+SH_WebPImage.h"
#import "SH_SmallWindowViewController.h"
#import "SH_TopLevelControllerManager.h"
@interface  SH_UserInformationView()
@property (weak, nonatomic) IBOutlet UILabel *lastLoginTime_label;
@property (weak, nonatomic) IBOutlet UILabel *titleNum_label;
@property (weak, nonatomic) IBOutlet UILabel *userWelfare_label;
@property (weak, nonatomic) IBOutlet UILabel *warehouseWelfare_label;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;

@end
@implementation SH_UserInformationView
+(instancetype)instanceInformationView{
    return [[[NSBundle  mainBundle] loadNibNamed:NSStringFromClass([self  class]) owner:nil options:nil] lastObject];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)dealloc
{
    
}

-(void)awakeFromNib{
    [super  awakeFromNib];
    [self configUI];
}
-(void)configUI{
    self.titleNum_label.text = [RH_UserInfoManager  shareUserManager].mineSettingInfo.username?:@"";
    self.lastLoginTime_label.text = [NSString  stringWithFormat:@"上次登录时间：%@",[RH_UserInfoManager  shareUserManager].mineSettingInfo.lastLoginTime?:@""];
    self.userWelfare_label.text = [NSString  stringWithFormat:@"%.2f",[RH_UserInfoManager  shareUserManager].mineSettingInfo.walletBalance?:0.0];
//     self.warehouseWelfare_label.text = [NSString  stringWithFormat:@"%.2f",[RH_UserInfoManager  shareUserManager].mineSettingInfo.walletBalance?:0.0];
    self.warehouseWelfare_label.text = @"0.00";
    if ([RH_UserInfoManager  shareUserManager].isLogin) {
        if ([RH_UserInfoManager shareUserManager].mineSettingInfo.userSex.length > 0) {
            if ([[RH_UserInfoManager shareUserManager].mineSettingInfo.userSex isEqualToString:@"male"]) {
                self.userAvatar.image = [UIImage imageWithWebPImageName:@"photo_male"];
            } else  if ([[RH_UserInfoManager shareUserManager].mineSettingInfo.userSex isEqualToString:@"female"]){
                self.userAvatar.image = [UIImage imageWithWebPImageName:@"photo_female"];
            } else {
                self.userAvatar.image = [UIImage imageWithWebPImageName:@"photo_male"];
            }
        } else {
            self.userAvatar.image = [UIImage imageWithWebPImageName:@"photo_male"];
        }
    }else{
        self.userAvatar.image = [UIImage  imageWithWebPImageName:@"visitor"];
    }
}
- (IBAction)btnClick:(UIButton *)sender {
     UIViewController * svc = [SH_TopLevelControllerManager fetchTopLevelController];
    if (sender.tag == 100) {
        SH_AlertView * alert = [SH_AlertView  instanceAlertView];
        SH_SmallWindowViewController *vc = [SH_SmallWindowViewController new];
        vc.titleImageName = @"title03";
        vc.customView = alert;
        vc.contentHeight = 174;
        [self  presentViewController:vc addTargetViewController:svc];
    }else{
        SH_SettingView * settingView = [SH_SettingView instanceSettingView];
        SH_SmallWindowViewController * setVC = [SH_SmallWindowViewController new];
        setVC.customView = settingView;
        setVC.contentHeight = 130;
        setVC.titleImageName = @"title05";
        [self  presentViewController:setVC addTargetViewController:svc];
    }
}

#pragma mark --- 模态弹出viewController
-(void)presentViewController:(UIViewController*)viewController addTargetViewController:(UIViewController*)targetVC{
    viewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    viewController.modalTransitionStyle =UIModalTransitionStyleCrossDissolve;
    [targetVC presentViewController:viewController animated:YES completion:nil];
}
@end
