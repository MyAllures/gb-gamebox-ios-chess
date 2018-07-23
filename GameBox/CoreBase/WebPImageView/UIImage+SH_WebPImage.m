//
//  UIImage+SH_WebPImage.m
//  GameBox
//
//  Created by shin on 2018/7/22.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "UIImage+SH_WebPImage.h"
#import <UIImage+WebP.h>

@implementation UIImage (SH_WebPImage)

+ (UIImage *)imageWithWebPImageName:(NSString *)name
{
    NSBundle *bundle;
#if TARGET_INTERFACE_BUILDER
    bundle = [NSBundle bundleForClass:[self class]];
#else
    bundle = [NSBundle mainBundle];
#endif
    NSString *path = [bundle pathForResource:name ofType:@"webp"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    UIImage *img = [UIImage sd_imageWithWebPData:data];
    return img;
}

@end
