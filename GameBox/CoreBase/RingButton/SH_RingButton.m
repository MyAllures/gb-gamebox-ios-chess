//
//  SH_RingButton.m
//  GameBox
//
//  Created by shin on 2018/7/12.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_RingButton.h"
#import "SH_RingManager.h"

@implementation SH_RingButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    switch (self.ringType) {
        case SH_Ring_Type_Alert:
            [[SH_RingManager sharedManager] playAlertRing];
            break;
        case SH_Ring_Type_Money:
            [[SH_RingManager sharedManager] playMoneyRing];
            break;
        case SH_Ring_Type_Err:
            [[SH_RingManager sharedManager] playErrRing];
            break;
        default:
            break;
    }
}

-(void)setScale {
    
    [UIView animateKeyframesWithDuration:0.5 delay:0 options:0 animations: ^{
        [UIView addKeyframeWithRelativeStartTime:1/3.0 relativeDuration:1/3.0 animations: ^{
            self.transform = CGAffineTransformMakeScale(0.95, 0.95);
        }];
    } completion:nil];
    
    [UIView animateKeyframesWithDuration:0.5 delay:0 options:0 animations: ^{
        [UIView addKeyframeWithRelativeStartTime:1/3.0 relativeDuration:1/3.0 animations: ^{
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    } completion:nil];
}

@end
