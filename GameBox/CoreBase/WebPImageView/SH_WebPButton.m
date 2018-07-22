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
    
    NSBundle *bundle;
#if TARGET_INTERFACE_BUILDER
    bundle = [NSBundle bundleForClass:[self class]];
#else
    bundle = [NSBundle mainBundle];
#endif
    NSString *path = [bundle pathForResource:_webpImage ofType:@"webp"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    UIImage *img = [UIImage sd_imageWithWebPData:data];
    
    [self setImage:img forState:UIControlStateNormal];
}

@end
