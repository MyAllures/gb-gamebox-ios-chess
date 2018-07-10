//
//  SH_BitCoinTextView.h
//  GameBox
//
//  Created by jun on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SH_BitCoinTextViewDelegate<NSObject>
-(void)SH_BitCoinTextViewChooseDateBtnClick;
@end
@interface SH_BitCoinTextView : UIView
@property(nonatomic,weak)id<SH_BitCoinTextViewDelegate>delegate;
-(void)updateDateLabWithDataString:(NSString *)dateStr;
@end
