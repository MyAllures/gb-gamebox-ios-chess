//
//  UIImage+RadioImage.m
//  GameBox
//
//  Created by egan on 2018/7/6.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "UIImage+RadioImage.h"

@implementation UIImage (RadioImage)

- (UIImage *)drawRectWithRoundedCorner:(CGFloat)radius SizeToFit:(CGSize)sizeToFit
{
    CGRect rect = CGRectMake(0, 0, sizeToFit.width, sizeToFit.height);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
    UIGraphicsBeginImageContextWithOptions(rect.size, false, [UIScreen mainScreen].scale);
    
    CGContextAddPath(UIGraphicsGetCurrentContext(), path.CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    
    [self drawInRect:rect];
    
    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFillStroke);
    
    UIImage *outImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outImage;
}

@end
