//
//  SH_DZGameItemView.h
//  GameBox
//
//  Created by shin on 2018/7/16.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SH_GameItemModel;
@class SH_DZGameItemView;

@protocol SH_DZGameItemViewDelegate

- (void)dzGameItemView:(SH_DZGameItemView *)view didSelect:(SH_GameItemModel *)model;

@end

@interface SH_DZGameItemView : UIView

@property (nonatomic, strong) SH_GameItemModel *gameItemModel;
@property (nonatomic, weak) id <SH_DZGameItemViewDelegate> delegate;

@end
