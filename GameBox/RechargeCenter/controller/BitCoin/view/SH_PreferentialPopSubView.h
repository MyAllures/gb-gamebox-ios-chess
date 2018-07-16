//
//  SH_PreferentialPopSubView.h
//  GameBox
//
//  Created by jun on 2018/7/12.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SH_BitCoinSaleModel.h"
@protocol SH_PreferentialPopSubViewDelegate<NSObject>
-(void)selectedActivityId:(NSString *)activityId;
@end
@interface SH_PreferentialPopSubView : UIView
@property(nonatomic,weak)id<SH_PreferentialPopSubViewDelegate>delegate;
-(void)updateUIWithSaleModel:(SH_BitCoinSaleModel *)model moneyString:(NSString *)money;
@end
