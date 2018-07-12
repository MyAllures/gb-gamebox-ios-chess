//
//  SH_PreferentialPopView.h
//  GameBox
//
//  Created by jun on 2018/7/12.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SH_BitCoinSaleModel.h"
@protocol SH_PreferentialPopViewDelegate<NSObject>
-(void)popViewSelectedActivityId:(NSString *)activityId;
@end
@interface SH_PreferentialPopView : UIView
@property(nonatomic,weak)id<SH_PreferentialPopViewDelegate>delegate;
-(void)updateUIWithSaleModel:(SH_BitCoinSaleModel *)model;
-(void)popViewShow;
@end
