//
//  SH_ConfirSaftyPassWordView.h
//  GameBox
//
//  Created by jun on 2018/7/24.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SH_ConfirSaftyPassWordView : UIView
@property(nonatomic,copy)NSString *money;
@property(nonatomic,copy)NSString *token;

- (void)updateUIWithDetailArray:(NSArray *)details
                       TargetVC:(UIViewController *)targetVC
                          Token:(NSString *)token;
@end
