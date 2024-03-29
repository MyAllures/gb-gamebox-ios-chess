//
//  SH_PromoDetailView.m
//  GameBox
//
//  Created by jun on 2018/8/8.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_PromoDetailView.h"
#import "SH_SmallWindowViewController.h"
#import "SH_TimeZoneManager.h"
#import "SH_BigWindowViewController.h"
#import "SH_ApplyResultView.h"
@interface SH_PromoDetailView()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webHeight;
@property(nonatomic,copy)NSString *promoId;
@property (weak, nonatomic) IBOutlet SH_WebPButton *applyBtn;

@end
@implementation SH_PromoDetailView
- (void)awakeFromNib{
    [super awakeFromNib];
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.delegate = self;
//    self.webView.scrollView.backgroundColor = [;
}
-(void)updateWithModel:(SH_PromoDetailModel *)model
                  Name:(NSString *)name
              ImageUrl:(NSString *)imageUrl
                  Date:(NSString *)date{
    if ([model.status isEqualToString:@"0"]) {
        self.applyBtn.hidden = NO;
        
    }else{
        self.applyBtn.hidden = YES;
    }
    self.promoId = model.name;
    self.nameLab.text = name;
    [self.bannerImageView setImageWithType:1 ImageName:imageUrl Placeholder:@"loading_activity"];
    self.dateLab.text = date;
    self.webHeight.constant = 1;
    NSLog(@"%@",model.code);
    [self.webView loadHTMLString:model.code baseURL:nil];
}
- (IBAction)applyBtnClick:(id)sender {
   
    UIViewController *vc = [self getCurrentViewController];
    SH_ApplyResultView *view = [[NSBundle mainBundle]loadNibNamed:@"SH_ApplyResultView" owner:self options:nil].firstObject;
    SH_BigWindowViewController * acr = [SH_BigWindowViewController new];
    acr.customView = view;
//    acr.titleImageName = @"title03";
    acr.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    acr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [vc presentViewController:acr animated:YES completion:nil];
    [view loadDataWithPromoId:self.promoId];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"colors" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSString *colorString = dic[@"category1"];
    [webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.background='%@'",colorString]];
//    //字体大小
//    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'"];
//    //字体颜色
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'white'"];
    CGFloat contentHeight = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"].floatValue;
    self.webHeight.constant = contentHeight;
}

@end
