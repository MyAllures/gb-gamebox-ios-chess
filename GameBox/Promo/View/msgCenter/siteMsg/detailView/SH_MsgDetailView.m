//
//  SH_MsgDetailView.m
//  GameBox
//
//  Created by sam on 2018/7/18.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_MsgDetailView.h"
#import "SH_NetWorkService+Promo.h"
@interface SH_MsgDetailView ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation SH_MsgDetailView
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
     NSLog(@"searchId1===%@",self.searchId);
    [SH_NetWorkService_Promo startLoadSystemMessageDetailWithSearchId:self.searchId complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary *dict = (NSDictionary *)response;
        NSLog(@"dict===%@",dict);
        self.textView.text = dict[@"data"][@"content"];
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
}


@end
