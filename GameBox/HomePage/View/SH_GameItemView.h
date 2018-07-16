//
//  SH_GameItemView.h
//  GameBox
//
//  Created by shin on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SH_GameItemModel;
@class SH_GameItemView;

@protocol SH_GameItemViewDelegate

- (void)gameItemView:(SH_GameItemView *)view didSelect:(SH_GameItemModel *)model;

@end

@interface SH_GameItemView : UIView

@property (nonatomic, strong) SH_GameItemModel *gameItemModel;
@property (nonatomic, weak) id <SH_GameItemViewDelegate> delegate;

@end
