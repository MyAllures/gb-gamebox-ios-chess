//
//  SH_BitCoinSuccessPopView.m
//  GameBox
//
//  Created by jun on 2018/7/12.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_BitCoinSuccessPopView.h"

@implementation SH_BitCoinSuccessPopView
- (void)awakeFromNib{
    [super awakeFromNib];
}
- (IBAction)tryAgainBtnClick:(id)sender {
    [UIView animateWithDuration:0.6 animations:^{
        self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        [self.delegate SH_BitCoinSuccessPopViewTryAgainBtnClick];
        [self.superview removeFromSuperview];
    }];
}

- (IBAction)backToHomePage:(id)sender {
    [self.delegate SH_BitCoinSuccessPopViewBackToHomePage];
    [self.superview removeFromSuperview];
}


@end
