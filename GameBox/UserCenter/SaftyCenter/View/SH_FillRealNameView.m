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

@interface SH_FillRealNameView()
@property (weak, nonatomic) IBOutlet UITextField *realNameTF;
@property (weak, nonatomic) IBOutlet UILabel *messageLab;


@end
@implementation SH_FillRealNameView

- (void)awakeFromNib{
    [super awakeFromNib];
}
- (IBAction)sureBtnClick:(id)sender {
    
    [SH_NetWorkService startSetRealName:self.realNameTF.text complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary *dict = (NSDictionary *)response;
        NSString *code = dict[@"code"];
        if ([code isEqualToString:@"0"]) {
            showMessage(self, @"", @"真实姓名设置成功");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.targetVC1 dismissViewControllerAnimated:NO completion:nil];
            });
        } else {
            self.messageLab.text = dict[@"message"];
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
}

@end
