//
//  SH_OutCoinDetailView.h
//  GameBox
//
//  Created by jun on 2018/7/16.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SH_OutCoinDetailView : UIView
-(void)updateUIWithDetailArray:(NSArray *)details
                      TargetVC:(UIViewController *)targetVC
                         Token:(NSString *)token;
@end
