//
//  SH_WelfareWarehouse.m
//  GameBox
//
//  Created by sam on 2018/8/17.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_WelfareWarehouse.h"
@interface SH_WelfareWarehouse ()
@property (weak, nonatomic) IBOutlet SH_WebPButton *depositBtn;
@property (weak, nonatomic) IBOutlet SH_WebPButton *withdrawalBtn;
@end

@implementation SH_WelfareWarehouse

- (IBAction)tapAction:(SH_WebPButton *)sender {
        if (sender.tag == 0) {
            self.depositBtn.webpBGImage = @"button-long-click";
            self.withdrawalBtn.webpBGImage = @"button-long";
        } else {
            self.depositBtn.webpBGImage = @"button-long";
            self.withdrawalBtn.webpBGImage = @"button-long-click";
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
