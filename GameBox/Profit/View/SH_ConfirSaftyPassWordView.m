//
//  SH_ConfirSaftyPassWordView.m
//  GameBox
//
//  Created by jun on 2018/7/24.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_ConfirSaftyPassWordView.h"
#import "SH_NetWorkService+Profit.h"

@interface SH_ConfirSaftyPassWordView()
@property (weak, nonatomic) IBOutlet UITextField *pswTF;

@end
@implementation SH_ConfirSaftyPassWordView


- (IBAction)sureBtnClick:(id)sender {
    if (self.pswTF.text.length == 0) {
        showMessage(self, @"请输入密码", nil);
    }else{
        [SH_NetWorkService sureOutCoinMoney:self.money SaftyPWD:self.pswTF.text Token:self.token Way:@"1" Success:^(NSHTTPURLResponse *httpURLResponse, id response) {
            showMessage(self, [NSString stringWithFormat:@"%@",response[@"message"]], nil);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIViewController *vc = self.targetVC;
                while (vc.presentingViewController) {
                    vc = vc.presentingViewController;
                }
                [vc dismissViewControllerAnimated:NO completion:nil];
            });
        } Failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            
        }];
    }
}
- (void)setMoney:(NSString *)money{
    _money = money;
}
- (void)setToken:(NSString *)token{
    _token = token;
}
- (void)setTargetVC:(UIViewController *)targetVC{
    _targetVC = targetVC;
}
@end
