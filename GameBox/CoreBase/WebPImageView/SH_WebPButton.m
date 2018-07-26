//
//  SH_WebPButton.m
//  GameBox
//
//  Created by shin on 2018/7/22.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_WebPButton.h"
#import <UIImage+WebP.h>

@implementation SH_WebPButton

- (void)setWebpImage:(NSString *)webpImage
{
    _webpImage = webpImage;
    UIImage *img = [self webpToUIImage:_webpImage];
    [self setImage:img forState:UIControlStateNormal];
}

- (void)setWebpBGImage:(NSString *)webpBGImage
{
    _webpBGImage = webpBGImage;
    UIImage *img = [self webpToUIImage:_webpBGImage];
    [self setBackgroundImage:img forState:UIControlStateNormal];
}

- (void)setSelectedImage:(NSString *)selectedImage
{
    _selectedImage = selectedImage;
    UIImage *img = [self webpToUIImage:_selectedImage];
    [self setImage:img forState:UIControlStateSelected];
}

- (void)setSelectedBGImage:(NSString *)selectedBGImage
{
    _selectedBGImage = selectedBGImage;
    UIImage *img = [self webpToUIImage:_selectedBGImage];
    [self setBackgroundImage:img forState:UIControlStateSelected];
}

- (UIImage *)webpToUIImage:(NSString *)name
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

- (void)setWebpImage:(NSString *)webpImage forState:(UIControlState)state
{
    UIImage *img = [self webpToUIImage:webpImage];
    [self setImage:img forState:state];
}

- (void)setWebpBGImage:(NSString *)webpBGImage forState:(UIControlState)state
{
    UIImage *img = [self webpToUIImage:webpBGImage];
    [self setBackgroundImage:img forState:state];
}

@end
