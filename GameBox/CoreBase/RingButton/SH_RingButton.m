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

@end
