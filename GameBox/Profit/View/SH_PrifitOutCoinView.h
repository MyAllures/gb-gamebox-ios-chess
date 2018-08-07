//
//  SH_PrifitOutCoinView.h
//  GameBox
//
//  Created by jun on 2018/7/16.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SH_ProfitModel;
@interface SH_PrifitOutCoinView : UIView
-(void)updateUIWithBalance:(SH_ProfitModel *)model
                   BankNum:(NSString *)bankNum
                  TargetVC:(UIViewController *)targetVC
                     Token:(NSString *)token Code:(NSString *)code Message:(NSString *)message;
@end
