//
//  UIImage+Representation.m
//  CoreLib
//
//  Created by apple pro on 2016/11/23.
//  Copyright © 2016年 GIGA. All rights reserved.
//

#import "UIImage+Representation.h"
#import "UIImage+Orientation.h"
#import "UIImage+Size.h"
#import "UIImage+Alpha.h"
#import "MacroDef.h"

@implementation UIImage (Representation)

- (NSUInteger)imageMemorySize
{
    CGImageRef imageRef = [self CGImage];
    return CGImageGetBitsPerPixel(imageRef) * CGImageGetWidth(imageRef) * CGImageGetHeight(imageRef);
}

#pragma mark -

- (NSData *)representationWithMaxSize:(NSUInteger)maxSize {
    return [self representationWithMaxSize:maxSize minCompressionQuality:0.5f fixOrientation:YES];
}

- (NSData *)representationWithMaxSize:(NSUInteger)maxSize
                minCompressionQuality:(CGFloat)minCompressionQuality
                       fixOrientation:(BOOL)fixOrientation
{
    if (maxSize == 0) {
        return nil;
    }

    //修正方向
    UIImage * image = fixOrientation ? [self fixOrientationImage] : self;

    //首先进行编码的压缩
    minCompressionQuality = ChangeInMinToMax(minCompressionQuality, 0.f, 1.f);
    NSData * representationData = [image _representationWithMaxSize:maxSize minCompressionQuality:minCompressionQuality];
    if (representationData == nil) { //如果最小质量下仍大于maxSize，则进行尺寸的压缩

        CGSize imageSize = self.size;

        //缩小图片尺寸直至图片编码后的大小小于maxSize
        do {

            imageSize.width  *= 0.9f;
            imageSize.height *= 0.9f;

            representationData = [[image imageWithSize:imageSize zoomMode:CLZoomModeFill]  _representationWithMaxSize:maxSize minCompressionQuality:minCompressionQuality];

        } while (representationData == nil);

    }

    return representationData;
}

- (NSData *)_representationWithMaxSize:(NSUInteger)maxSize minCompressionQuality:(CGFloat)minCompressionQuality
{
    //尝试使用jpeg压缩编码，降低压缩质量直至不能降低或者质量达到最低
    NSData * representationData = nil;
    CGFloat compressionQuality = 1.f;
    do {
        @autoreleasepool {
            representationData = UIImageJPEGRepresentation(self, compressionQuality);
        }
        if (compressionQuality > minCompressionQuality) {
            compressionQuality = MAX(MAX(0.f, minCompressionQuality - 0.0001f), compressionQuality - 0.1f);
        }else {
            break;
        }

    } while (representationData.length > maxSize);


    return representationData.length <= maxSize ? representationData : nil;
}

#pragma mark -

- (NSData *)representationData:(CGFloat)compressionQuality {
    return [self representationData:compressionQuality fixOrientation:YES];
}

- (NSData *)representationData:(CGFloat)compressionQuality fixOrientation:(BOOL)fixOrientation
{
    UIImage * image = fixOrientation ? [self fixOrientationImage] : nil;
    return [image hasAlpha] ? UIImagePNGRepresentation(image) : UIImageJPEGRepresentation(image, compressionQuality);
}

@end
