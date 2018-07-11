//
//  SH_CycleScrollView.h
//  GameBox
//
//  Created by shin on 2018/7/8.
//  Copyright © 2018年 shin. All rights reserved.
//


#import <UIKit/UIKit.h>

@class SH_CycleScrollView;

typedef void(^CompleteBlock)(void);

@protocol SH_CycleScrollViewDataSource <NSObject>

@required
- (NSArray *)numberOfCycleScrollView:(SH_CycleScrollView *)bannerView;
- (UIViewContentMode)contentModeForImageIndex:(NSUInteger)index;

@optional
- (UIImage *)placeHolderImageOfZeroBannerView;
- (UIImage *)placeHolderImageOfBannerView:(SH_CycleScrollView *)bannerView atIndex:(NSUInteger)index;

@end

@protocol SH_CycleScrollViewDelegate <NSObject>

@optional
- (void)cycleScrollView:(SH_CycleScrollView *)scrollView didScrollToIndex:(NSUInteger)index;
- (void)cycleScrollView:(SH_CycleScrollView *)scorllView didSelectedAtIndex:(NSUInteger)index;

@end

@interface SH_CycleScrollView : UIView

// Delegate and Datasource
@property (weak, nonatomic) id <SH_CycleScrollViewDataSource> datasource;
@property (weak, nonatomic) id <SH_CycleScrollViewDelegate> delegate;

@property (assign, nonatomic, getter = isContinuous) BOOL continuous;   // if YES, then bannerview will show like a carousel, default is NO
@property (assign, nonatomic) NSUInteger autoPlayTimeInterval;  // if autoPlayTimeInterval more than 0, the bannerView will autoplay with autoPlayTimeInterval value space, default is 0

- (void)reloadDataWithCompleteBlock:(CompleteBlock)competeBlock;
- (void)setCurrentPage:(NSInteger)currentPage animated:(BOOL)animated;

@end
