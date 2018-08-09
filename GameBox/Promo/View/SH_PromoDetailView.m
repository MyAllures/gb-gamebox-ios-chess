//
//  SH_PromoDetailView.m
//  GameBox
//
//  Created by jun on 2018/8/8.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_PromoDetailView.h"
#import "SH_PromoAlertView.h"
#import "AlertViewController.h"
#import "SH_TimeZoneManager.h"
@interface SH_PromoDetailView()
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;

@end
@implementation SH_PromoDetailView
- (void)awakeFromNib{
    [super awakeFromNib];
}
-(void)updateWithModel:(SH_PromoDetailModel *)model{
    [self.bannerImageView setImageWithType:1 ImageName:model.photo];
    self.dateLab.text = model.time;
    self.contentLab.text = model.explain;
}
- (IBAction)applyBtnClick:(id)sender {
    UIViewController *vc = [self getCurrentViewController];
    
    SH_PromoAlertView *view = [[NSBundle mainBundle]loadNibNamed:@"SH_PromoAlertView" owner:self options:nil].firstObject;
    AlertViewController *acr  = [[AlertViewController  alloc] initAlertView:view viewHeight:250 titleImageName:@"title03" alertViewType:AlertViewTypeShort];
    acr.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    acr.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [vc presentViewController:acr animated:YES completion:nil];
}
@end
