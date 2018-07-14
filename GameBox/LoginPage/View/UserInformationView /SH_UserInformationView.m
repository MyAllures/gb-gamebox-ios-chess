//
//  SH_UserInformationView.m
//  GameBox
//
//  Created by Paul on 2018/7/13.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_UserInformationView.h"
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
-(void)awakeFromNib{
    [super  awakeFromNib];
    [self configUI];
}
-(void)configUI{
    self.titleNum_label.text = [RH_UserInfoManager  shareUserManager].mineSettingInfo.username?:@"";
    self.lastLoginTime_label.text = [NSString  stringWithFormat:@"上次登录时间：%@",[RH_UserInfoManager  shareUserManager].mineSettingInfo.lastLoginTime?:@""];
    self.userWelfare_label.text = [NSString  stringWithFormat:@"%f",[RH_UserInfoManager  shareUserManager].mineSettingInfo.walletBalance?:0.0];
     self.warehouseWelfare_label.text = [NSString  stringWithFormat:@"%.3f",[RH_UserInfoManager  shareUserManager].mineSettingInfo.walletBalance?:0.0];
}
- (IBAction)btnClick:(UIButton *)sender {
    NSInteger  tag = sender.tag;
    if (self.buttonClickBlock) {
        self.buttonClickBlock(tag);
    }
    
}

@end
