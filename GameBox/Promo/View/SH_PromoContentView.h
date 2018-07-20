//
//  SH_PromoContentView.h
//  GameBox
//
//  Created by shin on 2018/7/9.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SH_PromoListModel;
typedef void(^SH_PromoContentViewShowDetail)(SH_PromoListModel *model);

@interface SH_PromoContentView : UIView

- (void)showPromoDetail:(SH_PromoContentViewShowDetail)showBlock;

@end
