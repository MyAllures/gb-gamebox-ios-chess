//
//  UIImage+Size.h
//  CoreLib
//
//  Created by apple pro on 2016/11/23.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "help.h"

@interface UIImage (Size)

/**
 * @brief 缩放图片到目标尺寸（可能裁减）
 * @param size size为目标尺寸
 * @param sizeScaleMode sizeScaleMode为目标尺寸的比例模式，默认为CLScaleModeCurrent
 * @param zoomMode zoomMode为缩放模式
 * @param fillColor fillColor为边界填充色，默认为白色
 * @param equalThreshold ignoreThreshold为尺寸相等的阈值，尺寸在这差别在这个范围内则认为相等，相等则不进行缩放，默认为2像素
 * @return 返回目标尺寸的图片，如果目标尺寸与原图相等则返回原图
 */
- (UIImage *)imageWithSize:(CGSize)size
             sizeScaleMode:(CLScaleMode)sizeScaleMode
                  zoomMode:(CLZoomMode)zoomMode
                 fillColor:(UIColor *)fillColor
            equalThreshold:(NSUInteger)equalThreshold;
- (UIImage *)imageWithSize:(CGSize)size zoomMode:(CLZoomMode)zoomMode;

/**
 * @brief 缩放图片到目标尺寸（不裁剪）
 * @param targetSize targetSize为目标尺寸
 * @param sizeScaleMode sizeScaleMode为目标尺寸的比例模式
 * @param zoomMode zoomMode为缩放模式
 * @param zoomOption zoomOption为缩放选项
 * @param maxSize maxSize为最大不能超过的尺寸，等于CGSizeZero时则没有限制,默认为CGSizeZero,基于像素
 * @return 如果目标尺寸与原图一致则返回原图
 */

- (UIImage *)imageZoomToTargetSize:(CGSize)targetSize
                     sizeScaleMode:(CLScaleMode)sizeScaleMode
                          zoomMode:(CLZoomMode)zoomMode
                        zoomOption:(CLZoomOption)zoomOption
                           maxSize:(CGSize)maxSize;

- (UIImage *)imageZoomToTargetSize:(CGSize)targetSize
                     sizeScaleMode:(CLScaleMode)sizeScaleMode
                          zoomMode:(CLZoomMode)zoomMode
                        zoomOption:(CLZoomOption)zoomOption;

//缩放到maxSize以内
- (UIImage *)imageZoomInToMaxSize:(CGSize)maxSize;



//是否是长图（当图片长宽相差达到一定比例则为长图，对于长图缩放时会对其进行优化）
- (BOOL)isLongImage;


//返回封面图
- (UIImage *)thumbnailWithSize:(CGFloat)size;
- (UIImage *)thumbnailWithSize:(CGFloat)size sizeScaleMode:(CLScaleMode)sizeScaleMode;

//等比例的封面图
- (UIImage *)aspectRatioThumbnailWithSize:(CGFloat)size;
- (UIImage *)aspectRatioThumbnailWithSize:(CGFloat)size sizeScaleMode:(CLScaleMode)sizeScaleMode;

//适合全屏显示的图片
- (UIImage *)fullScreenShowImage;


- (CGSize)perfectShowSizeInScale:(CGFloat)scale;
- (CGSize)perfectShowSize;

@end
