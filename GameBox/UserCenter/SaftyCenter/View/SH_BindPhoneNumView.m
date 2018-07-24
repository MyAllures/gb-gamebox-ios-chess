//
//  SH_BindPhoneNumView.m
//  GameBox
//
//  Created by jun on 2018/7/23.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_BindPhoneNumView.h"
#import "SH_NetWorkService+SaftyCenter.h"
@interface SH_BindPhoneNumView()
@property (weak, nonatomic) IBOutlet UILabel *oldPhoneNumLab; //旧手机号码lable
@property (weak, nonatomic) IBOutlet UITextField *oldPhoneNumTF;//旧手机号码textfield
@property (weak, nonatomic) IBOutlet UILabel *NewPhoneNumLab;//新手机号码lable
@property (weak, nonatomic) IBOutlet UITextField *NewPhoneNumTF;//新手机号码textfield
@property (weak, nonatomic) IBOutlet UIButton *VerificationBtn;//验证码按钮
@property (weak, nonatomic) IBOutlet UILabel *InputVerificationCodeLab;//验证码lable
@property (weak, nonatomic) IBOutlet UITextField *InputCodeTF;//验证码textfield

@end
@implementation SH_BindPhoneNumView

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (IBAction)sureBtnClick:(id)sender {
}
-(void)selectBindPhoneNumView{
    [SH_NetWorkService getUserPhoneInfoSuccess:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary *dataDic = ConvertToClassPointer(NSDictionary, response);
        NSString *data = [dataDic objectForKey:@"data"];
        if (data == nil || [data isEqualToString:@""]) {
            //没有绑定过手机

        }
        else
        {
         //绑定过手机
        }
        
    } Fail:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
}
@end
