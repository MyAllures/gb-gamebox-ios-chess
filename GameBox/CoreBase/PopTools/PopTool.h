//
//  PopTool.h
//  GameBox
//
//  Created by Paul on 2018/7/6.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger,AnimationType) {
    AnimationTypeNone= 0,
    AnimationTypeScale,// 缩放
    AnimationTypePosition,// 位移
    AnimationTypeFade//淡入淡出
};
typedef NS_ENUM(NSInteger, AnimationDirection) {// 动画方向
    AnimationDirectionFromRight,// 从右侧进入
    AnimationDirectionFromLeft,// 从左侧进入
    AnimationDirectionFromTop,// 从顶部进入
    AnimationDirectionFromBottom,// 从底部进入
    AnimationDirectionFromCenter// 从屏幕中间进入
};

@interface PopTool : NSObject

+(PopTool*)sharedInstance;
/**
 *  弹出要展示的View
 *  @param width height 距离左边和上边的距离
 *  @param presentView show View
 *  @param animatedType    动画类型
 */
- (void)showWithPresentView:(UIView *)presentView
        withWidth:(CGFloat)width
        withHeight:(CGFloat)height
        subTitle:(NSString*)subTitle
        AnimatedType:(AnimationType)animatedType
     AnimationDirectionType:(AnimationDirection)animationDirectionType;
/**
 *  关闭弹出视图
 */
- (void)closePopView;

@end
