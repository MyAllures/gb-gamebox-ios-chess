//
//  SH_GamesListScrollView.h
//  GameBox
//
//  Created by shin on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SH_GamesListScrollView;

@protocol GamesListScrollViewDataSource <NSObject>

@required
- (NSInteger)numberOfItemsOfGamesListScrollView:(SH_GamesListScrollView *)scrollView;
- (UIView *)gamesListScrollView:(SH_GamesListScrollView *)scrollView viewForItem:(NSInteger)index;

@end

@protocol GamesListScrollViewDelegate <NSObject>

@optional
- (void)gamesListScrollView:(SH_GamesListScrollView *)scrollView didSelectItem:(NSInteger)index;

@end

@interface SH_GamesListScrollView : UIView

@property (nonatomic, weak) id <GamesListScrollViewDataSource> dataSource;
@property (nonatomic, weak) id <GamesListScrollViewDelegate> delegate;

- (void)reloaData;

@end
