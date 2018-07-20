
//  SH_PromoListView.h
//  GameBox
//
//  Created by shin on 2018/7/9.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SH_PromoListView;
@class SH_PromoListModel;
@protocol SH_PromoListViewDelegate

@optional
- (void)promoListView:(SH_PromoListView *)view didSelect:(SH_PromoListModel *)model;
@end

@interface SH_PromoListView : UIView

@property (nonatomic, weak) id <SH_PromoListViewDelegate> delegate;

- (void)reloadData;

@end
