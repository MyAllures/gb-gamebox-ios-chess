//
//  SH_RegistRulerView.m
//  GameBox
//
//  Created by Paul on 2018/8/3.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_RegistRulerView.h"
@interface  SH_RegistRulerView()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end
@implementation SH_RegistRulerView
+(instancetype)instanceRegistRulerView{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{
    [super awakeFromNib];

}
-(void)setHtml:(NSString *)html{
     [self.webView loadHTMLString:html baseURL:nil];
}
@end
