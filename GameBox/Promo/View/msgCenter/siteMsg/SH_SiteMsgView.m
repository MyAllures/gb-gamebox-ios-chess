//
//  SH_SiteMsgView.m
//  GameBox
//
//  Created by sam on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_SiteMsgView.h"

#import "SH_SystemMsgView.h"
#import "SH_SendMsgView.h"

@interface SH_SiteMsgView ()
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) SH_SystemMsgView *systemMsgView;
@property (strong, nonatomic) SH_SendMsgView *sendMsgView;
@end

@implementation SH_SiteMsgView

-(void)awakeFromNib {
    [super awakeFromNib];
    self.systemMsgView.hidden = NO;
//    self.backgroundColor = [UIColor colorWithRed:0.15 green:0.19 blue:0.44 alpha:1];
    self.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
}

- (IBAction)touchMe:(id)sender {
    int index = (int)[sender selectedSegmentIndex];
    switch (index) {
        case 0:
            self.systemMsgView.hidden = NO;
            self.sendMsgView.hidden = YES;
            break;
        case 1:
            self.systemMsgView.hidden = NO;
            self.sendMsgView.hidden = YES;
            break;
        case 2:
            self.systemMsgView.hidden = YES;
            self.sendMsgView.hidden = NO;
            break;
        default:
            break;
    }
}

-(SH_SystemMsgView *)systemMsgView {
    if (!_systemMsgView) {
        _systemMsgView = [[[NSBundle mainBundle] loadNibNamed:@"SH_SystemMsgView" owner:nil options:nil] lastObject];
        [self.contentView addSubview:_systemMsgView];
        [_systemMsgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
    }
    return _systemMsgView;
}

-(SH_SendMsgView *)sendMsgView {
    if (!_sendMsgView) {
        _sendMsgView = [[[NSBundle mainBundle] loadNibNamed:@"SH_SendMsgView" owner:nil options:nil] lastObject];
        [self.contentView addSubview:_sendMsgView];
        [_sendMsgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
    }
    return _sendMsgView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
