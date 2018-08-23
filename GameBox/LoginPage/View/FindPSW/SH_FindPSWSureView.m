//
//  SH_FindPSWSureView.m
//  GameBox
//
//  Created by sam on 2018/7/24.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_FindPSWSureView.h"
#import "SH_TopLevelControllerManager.h"
@interface SH_FindPSWSureView()
@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *textField2;
@end

@implementation SH_FindPSWSureView
- (IBAction)sureAction:(id)sender {
    if (self.textField2.text.length == 0 || self.textField1.text.length == 0) {
        showMessage(self, @"", @"密码不能为空");
    } else if (self.textField2.text.length <6 || self.textField1.text.length <6) {
        showMessage(self, @"", @"密码至少6位数");
    } else  if (![self.textField1.text isEqualToString:self.textField2.text]) {
        showMessage(self, @"", @"两次输入的密码不一致");
    } else {
        NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
        NSString *userName = [defaults objectForKey:@"userName"];
        [SH_NetWorkService_FindPsw finbackLoginPsw:userName psw:self.textField2.text complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
            NSDictionary *dict = (NSDictionary *)response;
            NSLog(@"dict==%@",dict);
            NSString *code = dict[@"code"];
            if ([code isEqualToString:@"0"]) {
                showMessage(self, @"密码修改成功", nil);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    UIViewController *vc= [SH_TopLevelControllerManager fetchTopLevelController];
                    [defaults setObject:nil forKey:@"userName"];
                    [defaults synchronize];
                    while (vc.presentingViewController) {
                        if ([vc isKindOfClass:[UINavigationController class]]) {
                            break;
                            
                        }
                        vc = vc.presentingViewController;
                    }
                    [vc dismissViewControllerAnimated:NO completion:nil];
                });
            } else {
                showMessage(self, @"", dict[@"message"]);
            }
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            
        }];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
