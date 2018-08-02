//
//  SH_SafeCenterAlertView.m
//  GameBox
//
//  Created by sam on 2018/8/2.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_SafeCenterAlertView.h"

@implementation SH_SafeCenterAlertView

+(instancetype)instanceSafeCenterAlertView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}
- (IBAction)btnClick:(UIButton *)sender {
    if (sender.tag == 100) {
       
    } else {
         [self.vc close];
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
