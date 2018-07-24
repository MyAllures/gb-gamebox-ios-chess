//
//  SH_ConfirSaftyPassWordView.m
//  GameBox
//
//  Created by jun on 2018/7/24.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_ConfirSaftyPassWordView.h"


@interface SH_ConfirSaftyPassWordView()
@property (weak, nonatomic) IBOutlet UITextField *pswTF;

@end
@implementation SH_ConfirSaftyPassWordView


- (IBAction)sureBtnClick:(id)sender {
    if (self.pswTF.text.length == 0) {
        showMessage(self, @"请输入密码", nil);
    }else{
        
    }
}

@end
