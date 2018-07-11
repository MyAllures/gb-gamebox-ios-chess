//
//  SH_RechargeDetailHeadView.m
//  GameBox
//
//  Created by jun on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_RechargeDetailHeadView.h"
@interface SH_RechargeDetailHeadView()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saveBtnCenterX;
@property (weak, nonatomic) IBOutlet UIButton *openBtn;

@end
@implementation SH_RechargeDetailHeadView

- (void)awakeFromNib{
    [super awakeFromNib];
}
- (void)updateWithInteger:(NSInteger)index{
    if (index%2==0) {
        self.openBtn.hidden = YES;
        self.saveBtnCenterX.constant = 0;
    }
}
@end
