//
//  SH_GamesListScrollView.m
//  GameBox
//
//  Created by shin on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_GamesListScrollView.h"
#import <Masonry/Masonry.h>
#import "SH_GameItemView.h"
#import "SH_DZGameItemView.h"
#import "UIImage+SH_WebPImage.h"

#define SH_GAMELIST_ITEM_WIDTH self.frame.size.height/2.0*(128/107.5) //128
#define SH_GAMELIST_ITEM_HEIGHT self.frame.size.height/2.0 //107.5

@interface SH_GamesListScrollView () <UIScrollViewDelegate, SH_GameItemViewDelegate, SH_DZGameItemViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *preBT;
@property (nonatomic, strong) UIButton *nextBT;
@property (nonatomic, assign) int currentPage;

@end

@implementation SH_GamesListScrollView

- (void)reloaData
{
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    for (id subView in self.scrollView.subviews) {
        if ([subView isMemberOfClass:[SH_GameItemView class]] || [subView isMemberOfClass:[SH_DZGameItemView class]]) {
            [subView removeFromSuperview];
        }
    }
    
    NSInteger itemsNum = [self.dataSource numberOfItemsOfGamesListScrollView:self];
    CGFloat calculationW = (itemsNum/2+itemsNum%2)*SH_GAMELIST_ITEM_WIDTH;
    CGFloat contentSizeW = calculationW > self.scrollView.frame.size.width ? calculationW : self.scrollView.frame.size.width;
    
    if (calculationW > self.scrollView.frame.size.width) {
        self.nextBT.hidden = NO;
        self.preBT.hidden = YES;
    }
    else
    {
        self.nextBT.hidden = YES;
        self.preBT.hidden = YES;
    }

    self.scrollView.contentSize = CGSizeMake(contentSizeW, self.scrollView.frame.size.height);
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];

    for (int i = 0; i < itemsNum; i++) {
        id itemView =[self.dataSource gamesListScrollView:self viewForItem:i];
        if ([itemView isMemberOfClass:[SH_DZGameItemView class]]) {
            SH_DZGameItemView *gameItemView = (SH_DZGameItemView *)[self.dataSource gamesListScrollView:self viewForItem:i];
            [self.scrollView addSubview:gameItemView];
            gameItemView.delegate = self;
            [gameItemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo((i/2)*SH_GAMELIST_ITEM_WIDTH);
                make.top.mas_equalTo((i%2)*SH_GAMELIST_ITEM_HEIGHT);
                make.width.mas_equalTo(SH_GAMELIST_ITEM_WIDTH);
                make.height.mas_equalTo(SH_GAMELIST_ITEM_HEIGHT);
            }];
        }
        else if ([itemView isMemberOfClass:[SH_GameItemView class]])
        {
            SH_GameItemView *gameItemView = (SH_GameItemView *)[self.dataSource gamesListScrollView:self viewForItem:i];
            [self.scrollView addSubview:gameItemView];
            gameItemView.delegate = self;
            [gameItemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo((i/2)*SH_GAMELIST_ITEM_WIDTH);
                make.top.mas_equalTo((i%2)*SH_GAMELIST_ITEM_HEIGHT);
                make.width.mas_equalTo(SH_GAMELIST_ITEM_WIDTH);
                make.height.mas_equalTo(SH_GAMELIST_ITEM_HEIGHT);
            }];
        }
    }
}

- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self);
        }];
        [self layoutIfNeeded];
    }
    return _scrollView;
}

- (UIButton *)nextBT
{
    if (_nextBT == nil) {
        _nextBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBT.hidden = YES;
        [_nextBT setImage:[UIImage imageWithWebPImageName:@"arrow_next"] forState:UIControlStateNormal];
        [_nextBT addTarget:self action:@selector(nextBTClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_nextBT];
        [_nextBT mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.width.mas_equalTo(26.5);
            make.height.mas_equalTo(36);
            make.right.equalTo(self.mas_right).mas_equalTo(-12);
        }];
    }
    return _nextBT;
}

- (UIButton *)preBT
{
    if (_preBT == nil) {
        _preBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _preBT.hidden = YES;
        [_preBT setImage:[UIImage imageWithWebPImageName:@"arrow_prev"] forState:UIControlStateNormal];
        [_preBT addTarget:self action:@selector(preBTClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_preBT];
        [_preBT mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.width.mas_equalTo(26.5);
            make.height.mas_equalTo(36);
            make.left.mas_equalTo(12);
        }];
    }
    return _preBT;
}

- (void)nextBTClick:(id)sender
{
    CGFloat x = self.scrollView.frame.size.width * (self.currentPage+1);
    if (x > self.scrollView.contentSize.width-self.scrollView.frame.size.width) {
        x = self.scrollView.contentSize.width - self.scrollView.frame.size.width;
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self.scrollView setContentOffset:CGPointMake(x, 0) animated:NO];
        [self scrollViewDidEndDecelerating:self.scrollView];
    }];
}

- (void)preBTClick:(id)sender
{
    CGFloat x = self.scrollView.frame.size.width * (self.currentPage-1);
    [UIView animateWithDuration:0.3 animations:^{
        [self.scrollView setContentOffset:CGPointMake(x, 0) animated:NO];
        [self scrollViewDidEndDecelerating:self.scrollView];
    }];
}

#pragma mark - UIScrollViewDelegate M

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int currentPage = scrollView.contentOffset.x/scrollView.frame.size.width + ((int)scrollView.contentOffset.x%(int)scrollView.frame.size.width == 0 ? 0 : 1);
    self.currentPage = currentPage;
    int totalPage = ceil(scrollView.contentSize.width/scrollView.frame.size.width);
    if (currentPage+1 == totalPage) {
        //最后一页
        self.nextBT.hidden = YES;
        self.preBT.hidden = NO;
    }else if (currentPage == 0){
        //第一页
        self.nextBT.hidden = NO;
        self.preBT.hidden = YES;
    }else{
        //中间页
        self.nextBT.hidden = NO;
        self.preBT.hidden = NO;
    }
}

#pragma mark - SH_GameItemViewDelegate M

- (void)gameItemView:(SH_GameItemView *)view didSelect:(SH_GameItemModel *)model
{
    ifRespondsSelector(self.delegate, @selector(gamesListScrollView:didSelectItem:))
    {
        [self.delegate gamesListScrollView:self didSelectItem:model];
    }
}

#pragma mark - SH_DZGameItemViewDelegate M

- (void)dzGameItemView:(SH_DZGameItemView *)view didSelect:(SH_GameItemModel *)model
{
    ifRespondsSelector(self.delegate, @selector(gamesListScrollView:didSelectItem:))
    {
        [self.delegate gamesListScrollView:self didSelectItem:model];
    }
}
@end
