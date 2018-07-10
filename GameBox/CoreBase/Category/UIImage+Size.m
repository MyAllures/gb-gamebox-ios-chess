//
//  UIImage+Size.m
//  CoreLib
//
//  Created by apple pro on 2016/11/23.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import "UIImage+Size.h"
#import "UIImage+Alpha.h"

@implementation UIImage (Size)

- (UIImage *)imageWithSize:(CGSize)size zoomMode:(CLZoomMode)zoomMode {
    return [self imageWithSize:size sizeScaleMode:CLScaleModeCurrent zoomMode:zoomMode fillColor:nil equalThreshold:2];
}

- (UIImage *)imageWithSize:(CGSize)size
             sizeScaleMode:(CLScaleMode)sizeScaleMode
                  zoomMode:(CLZoomMode)zoomMode
                 fillColor:(UIColor *)fillColor
            equalThreshold:(NSUInteger)equalThreshold
{
    //检测size
    if (size.height <= 0 || size.width <=0) {
        return nil;
    }

    //图片大小
    CGSize imageSize = self.size;

    //转换size到图片缩放比例下
    size = convertSizeToCurrentScale(size, sizeScaleMode, self.scale);
    equalThreshold = convertLenghtToScale(equalThreshold, 1.f, self.scale);

    //尺寸相等,或者尺寸之一为0，返回原图
    if ((fabs(imageSize.width - size.width) <= equalThreshold &&
         fabs(imageSize.height - size.height) <= equalThreshold)
        || imageSize.width == 0.f || imageSize.height == 0.f) {
        return self;
    }

    //目标矩形
    CGRect targetRect = CGRectMake(0.f, 0.f, roundf(size.width), roundf(size.height)), drawRect;

    if (zoomMode == CLZoomModeFill) {
        drawRect = targetRect;
    }else {

        //计算图片绘制的大小
        CGSize drawSize = sizeZoomToTagetSize(imageSize, targetRect.size, zoomMode);

        //计算绘制的矩形区域，定位到目标矩形中心
        drawRect = contentRectForLayout(targetRect, drawSize, CLContentLayoutCenter);
        drawRect.origin.x = roundf(drawRect.origin.x);
        drawRect.origin.y = roundf(drawRect.origin.y);
        drawRect.size.width = roundf(drawRect.size.width);
        drawRect.size.height = roundf(drawRect.size.height);
    }

    UIGraphicsBeginImageContextWithOptions(targetRect.size, ![self hasAlpha], self.scale);

    //如果目标尺寸大于绘制尺寸，则填充背景颜色
    if (CGRectGetWidth(targetRect) > CGRectGetWidth(drawRect) ||
        CGRectGetHeight(targetRect) > CGRectGetHeight(drawRect)) {
        [fillColor ?: [UIColor whiteColor] setFill];
        UIRectFill(targetRect);
    }

    [self drawInRect:drawRect];
    UIImage * resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return resultImage;
}

#pragma mark -


- (UIImage *)imageZoomToTargetSize:(CGSize)targetSize
                     sizeScaleMode:(CLScaleMode)sizeScaleMode
                          zoomMode:(CLZoomMode)zoomMode
                        zoomOption:(CLZoomOption)zoomOption
{
    return [self imageZoomToTargetSize:targetSize
                         sizeScaleMode:sizeScaleMode
                              zoomMode:zoomMode
                            zoomOption:zoomOption
                               maxSize:CGSizeZero];
}

- (UIImage *)imageZoomToTargetSize:(CGSize)targetSize
                     sizeScaleMode:(CLScaleMode)sizeScaleMode
                          zoomMode:(CLZoomMode)zoomMode
                        zoomOption:(CLZoomOption)zoomOption
                           maxSize:(CGSize)maxSize
{

    //转换到当前缩放比例下
    targetSize = convertSizeToCurrentScale(targetSize, sizeScaleMode, self.scale);

    //计算缩放后的图片大小
    targetSize = sizeZoomToTagetSize_extend(self.size, targetSize, zoomMode, zoomOption);

    //缩放到最大以内
    if (!CGSizeEqualToSize(maxSize, CGSizeZero)) {

        //将最大尺寸转换到当前比例
        maxSize = convertSizeToCurrentScale(maxSize, CLScaleModePixel, self.scale);
        if ([self isLongImage]) { //如果是长图则通过长宽之积来判定是否大于maxSize
            CGFloat factor = (maxSize.height * maxSize.width * 8) / (targetSize.width * targetSize.height);
            if (factor < 1.f) { //需要缩小
                targetSize = CGSizeMake(targetSize.width * factor, targetSize.height * factor);
            }
        }else {
            targetSize = sizeZoomToTagetSize_extend(targetSize, maxSize, CLZoomModeAspectFit, CLZoomOptionZoomIn);
        }
    }

    return  [self imageWithSize:targetSize zoomMode:CLZoomModeFill];
}

- (UIImage *)imageZoomInToMaxSize:(CGSize)maxSize
{
    return [self imageZoomToTargetSize:self.size
                         sizeScaleMode:CLScaleModeCurrent
                              zoomMode:CLZoomModeFill
                            zoomOption:CLZoomOptionZoomIn
                               maxSize:maxSize];
}

#pragma mark -

- (BOOL)isLongImage
{
    CGSize imageSize = self.size;
    if (imageSize.width <= 0.f || imageSize.height <= 0.f) {
        return NO;
    }else {
        CGFloat imageFactor = imageSize.width / imageSize.height;
        imageFactor = imageFactor < 1.f ? 1.f / imageFactor : imageFactor;
        return imageFactor >= 5.f;
    }
}

#pragma mark -

- (UIImage *)thumbnailWithSize:(CGFloat)size {
    return [self thumbnailWithSize:size sizeScaleMode:CLScaleModeScreen];
}

- (UIImage *)thumbnailWithSize:(CGFloat)size sizeScaleMode:(CLScaleMode)sizeScaleMode
{
    if (size <= 0.f) {
        return nil;
    }

    size = MIN(MIN(self.size.width, self.size.height), convertLenghtToCurrentScale(size, sizeScaleMode, self.scale));
    return [self imageWithSize:CGSizeMake(size, size) zoomMode:CLZoomModeAspectFill];
}

- (UIImage *)aspectRatioThumbnailWithSize:(CGFloat)size {
    return [self aspectRatioThumbnailWithSize:size sizeScaleMode:CLScaleModeScreen];
}

- (UIImage *)aspectRatioThumbnailWithSize:(CGFloat)size sizeScaleMode:(CLScaleMode)sizeScaleMode
{
    return [self imageZoomToTargetSize:CGSizeMake(size, size)
                         sizeScaleMode:sizeScaleMode
                              zoomMode:CLZoomModeAspectFill
                            zoomOption:CLZoomOptionZoomIn];
}

//适合全屏显示的图片
- (UIImage *)fullScreenShowImage
{
    return [self imageZoomToTargetSize:screenSize()
                         sizeScaleMode:CLScaleModeScreen
                              zoomMode:CLZoomModeAspectFill
                            zoomOption:CLZoomOptionZoomIn];
}

#pragma mark -

- (CGSize)perfectShowSizeInScale:(CGFloat)scale {
    return convertSizeToScale(self.size, self.scale, scale);
}

- (CGSize)perfectShowSize {
    return [self perfectShowSizeInScale:[UIScreen mainScreen].scale];
}

@end
