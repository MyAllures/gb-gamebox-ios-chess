//
//  SH_BulletinDetailView.m
//  GameBox
//
//  Created by sam on 2018/7/23.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_BulletinDetailView.h"

@interface SH_BulletinDetailView ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation SH_BulletinDetailView

- (IBAction)closeView:(id)sender {
    [self removeFromSuperview];
}
-(void)awakeFromNib {
    [super awakeFromNib];
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.layer.borderWidth = 1;
    self.textView.layer.cornerRadius = 5;
    self.textView.layer.masksToBounds = YES;
    self.textView.backgroundColor = [UIColor clearColor];
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.textView.text = self.context;
}


@end
