//
//  SH_SendMsgView.m
//  GameBox
//
//  Created by sam on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_SendMsgView.h"

@interface SH_SendMsgView ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation SH_SendMsgView

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(20);
        make.right.bottom.mas_equalTo(-40);
    }];
    self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.scrollEnabled = YES;
//    self.scrollView.contentSize = CGSizeMake(-20, self.frame.size.height);
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.layer.borderWidth = 1;
    self.textView.layer.cornerRadius = 5;
    self.textView.clipsToBounds = YES;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementationSH_SendMsgView adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
