//
//  SH_FillRealNameView.m
//  GameBox
//
//  Created by jun on 2018/7/23.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_FillRealNameView.h"
//#import "SH_NetWorkService+SaftyCenter.h"ns
#import "SH_NetWorkService+RegistAPI.h"
#import "SH_TopLevelControllerManager.h"
@interface SH_FillRealNameView()
@property (weak, nonatomic) IBOutlet UITextField *realNameTF;
@property (weak, nonatomic) IBOutlet UILabel *messageLab;


@end
@implementation SH_FillRealNameView

- (void)awakeFromNib{
    [super awakeFromNib];
}
- (IBAction)sureBtnClick:(SH_WebPButton *)sender {
    [sender setScale];
    if (self.realNameTF.text.length == 0) {
        showMessage(self, @"请输入真实姓名", @"");
        return;
    } else if (self.realNameTF.text.length < 2) {
        showMessage(self, @"真实姓名至少2位数", @"");
        return;
    }
    [SH_NetWorkService startSetRealName:self.realNameTF.text complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary *dict = (NSDictionary *)response;
        NSString *code = dict[@"code"];
        if ([code isEqualToString:@"0"]) {
            showMessage(self, @"", @"真实姓名设置成功");
            
            [SH_NetWorkService fetchUserInfo:^(NSHTTPURLResponse *httpURLResponse, id response) {
                NSDictionary * dict = ConvertToClassPointer(NSDictionary, response);
                if ([dict[@"code"] isEqualToString:@"0"]) {
                    NSError *err;
                    NSArray *arr = [SH_BankListModel arrayOfModelsFromDictionaries:response[@"data"][@"bankList"] error:&err];
                    [[RH_UserInfoManager shareUserManager] setBankList:arr];
                    NSError *err2;
                    RH_MineInfoModel * model = [[RH_MineInfoModel alloc] initWithDictionary:[response[@"data"] objectForKey:@"user"] error:&err2];
                    [[RH_UserInfoManager  shareUserManager] setMineSettingInfo:model];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"realName" object:nil];
                }else{
//                    [[RH_UserInfoManager  shareUserManager] updateIsLogin:false];
                }
                
            } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
                //
//                [[RH_UserInfoManager  shareUserManager] updateIsLogin:false];
            }];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 UIViewController * svc = [SH_TopLevelControllerManager fetchTopLevelController];
                [svc dismissViewControllerAnimated:NO completion:nil];
            });
        } else {
            self.messageLab.text = dict[@"message"];
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
}

@end
