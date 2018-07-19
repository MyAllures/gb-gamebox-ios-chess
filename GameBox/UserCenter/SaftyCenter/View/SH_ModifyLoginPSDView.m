//
//  SH_ModifyLoginPSDView.m
//  GameBox
//
//  Created by jun on 2018/7/17.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_ModifyLoginPSDView.h"
#import "SH_NetWorkService+SaftyCenter.h"
@interface SH_ModifyLoginPSDView()
@property (weak, nonatomic) IBOutlet UITextField *currentTX;
@property (weak, nonatomic) IBOutlet UITextField *NewTX;
@property (weak, nonatomic) IBOutlet UITextField *sureTX;

@end
@implementation SH_ModifyLoginPSDView

- (void)awakeFromNib{
    [super awakeFromNib];
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
            [SH_NetWorkService updatePassword:self.currentTX.text NewPassword:self.NewTX.text Success:^(NSHTTPURLResponse *httpURLResponse, id response) {
                NSString *code = [NSString stringWithFormat:@"%@",response[@"code"]];
                if ([code isEqualToString:@"0"]) {
                    showMessage(self, @"修改成功", nil);
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:self.NewTX.text forKey:@"password"];
                    [defaults synchronize];
                    [self.targetVC dismissViewControllerAnimated:NO completion:nil];
                }else{
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
@end
