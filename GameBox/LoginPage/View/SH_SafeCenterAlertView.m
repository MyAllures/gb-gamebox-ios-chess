//
//  SH_SafeCenterAlertView.m
//  GameBox
//
//  Created by sam on 2018/8/2.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_SafeCenterAlertView.h"
#import "SH_CustomerServiceManager.h"
@interface SH_SafeCenterAlertView()
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation SH_SafeCenterAlertView

+(instancetype)instanceSafeCenterAlertView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}
- (IBAction)btnClick:(SH_WebPButton *)sender {
    if (sender.tag == 100) {
        [sender setScale];
        //联系客服
        [[SH_CustomerServiceManager sharedManager] open];
    } else {
        [sender setScale];
        [self.vc close];
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (self.context.length > 0) {
        self.label.text = self.context;
    }
}


@end
