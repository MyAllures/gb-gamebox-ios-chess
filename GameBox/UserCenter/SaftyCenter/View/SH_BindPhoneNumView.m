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
            [self notBindPhoneNum];

        }else
        {
         //绑定过手机
            [self bindedPhoneNumber:nil];
        }
        
    } Fail:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
}
//绑定过手机号码
-(void)bindedPhoneNumber:(NSString *)phoneNum{
    self.oldPhoneNumLab.hidden = YES;
    self.oldPhoneNumTF.hidden = YES;
    self.NewPhoneNumLab.text = @"手机号码";
    self.oldPhoneNumTF.text = phoneNum;
    self.oldPhoneNumTF.enabled = NO;

}
//未绑定过手机号码
-(void)notBindPhoneNum{
    
}
@end
