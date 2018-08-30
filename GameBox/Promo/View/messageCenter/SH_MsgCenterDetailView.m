//
//  SH_MsgCenterDetailView.m
//  GameBox
//
//  Created by shin on 2018/7/26.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_MsgCenterDetailView.h"

@interface SH_MsgCenterDetailView ()
@property (weak, nonatomic) IBOutlet UITextView *detailLB;
@property (nonatomic, copy) SH_MsgCenterDetailViewDismiss dismissBlock;

@end

@implementation SH_MsgCenterDetailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{
    [super awakeFromNib];
    self.detailLB.editable = false;
}

- (void)dismiss:(SH_MsgCenterDetailViewDismiss)dismissBlock
{
    self.dismissBlock = dismissBlock;
}

- (void)setContent:(NSString *)content
{
    _content = content;
    self.detailLB.text = _content;
}

- (IBAction)dismissAction:(id)sender {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

@end
