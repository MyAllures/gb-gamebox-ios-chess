//
//  SH_PromoContentView.h
//  GameBox
//
//  Created by shin on 2018/7/9.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertViewController.h"
@class SH_PromoListModel;
typedef void(^SH_PromoContentViewShowDetail)(SH_PromoListModel *model);

@interface SH_PromoContentView : UIView
@property(nonatomic,strong)AlertViewController * alertVC;
- (void)showPromoDetail:(SH_PromoContentViewShowDetail)showBlock;

@end
