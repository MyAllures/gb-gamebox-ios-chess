//
//  SH_AlertView.m
//  GameBox
//
//  Created by Paul on 2018/7/14.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_AlertView.h"
@interface  SH_AlertView()
@property (weak, nonatomic) IBOutlet UILabel *content_label;

@end
@implementation SH_AlertView
+(instancetype)instanceAlertView{
    return [[[NSBundle  mainBundle] loadNibNamed:NSStringFromClass([self  class]) owner:nil options:nil] lastObject];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)buttonClick:(UIButton *)sender {
    if (self.btnClickBlock) {
        self.btnClickBlock(sender.tag);
    }
}

@end
