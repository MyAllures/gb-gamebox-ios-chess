//
//  SH_MyMsgDetailView.m
//  GameBox
//
//  Created by sam on 2018/7/19.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_MyMsgDetailView.h"
#import "SH_NetWorkService+Promo.h"
@interface SH_MyMsgDetailView ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation SH_MyMsgDetailView

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
    [SH_NetWorkService_Promo startSiteMessageMyMessageDetailWithID:self.searchId complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary *dict = (NSDictionary *)response;
        NSLog(@"dict===%@",dict);
        self.textView.text = dict[@"data"][@"content"];
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
    
    [SH_NetWorkService_Promo startLoadMyMessageReadYesWithIds:[NSString stringWithFormat:@"%ld",(long)self.mId] complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary *dict = (NSDictionary *)response;
        NSLog(@"dict1===%@",dict);
        NSString *msg = dict[@"message"];
        if ([msg containsString:@"请求成功"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadMyMsgData" object:nil];
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
}


@end
