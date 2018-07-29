//
//  SH_BitCoinSuccessPopView.h
//  GameBox
//
//  Created by jun on 2018/7/12.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SH_BitCoinSuccessPopViewDelegate<NSObject>
-(void)SH_BitCoinSuccessPopViewTryAgainBtnClick;
-(void)SH_BitCoinSuccessPopViewBackToHomePage;
@end
@interface SH_BitCoinSuccessPopView : UIView
@property(nonatomic,weak)id<SH_BitCoinSuccessPopViewDelegate>delegate;
@end
