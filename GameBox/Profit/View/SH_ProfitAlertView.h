//
//  SH_ProfitAlertView.h
//  GameBox
//
//  Created by jun on 2018/7/17.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SH_ProfitAlertView : UIView
@property(nonatomic,strong)UIViewController *targetVC;
@property (nonatomic, strong) NSString *content;
@property (weak, nonatomic) IBOutlet SH_WebPButton *sureBtn;
- (void)updateUIWithDetailArray:(NSArray *)details
                       TargetVC:(UIViewController *)targetVC
                          Token:(NSString *)token;
@end
