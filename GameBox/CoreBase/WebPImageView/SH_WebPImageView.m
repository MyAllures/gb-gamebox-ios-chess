//
//  SH_WebPImageView.m
//  GameBox
//
//  Created by shin on 2018/7/22.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_WebPImageView.h"
#import <UIImage+WebP.h>
#import "UIImage+SH_WebPImage.h"

@implementation SH_WebPImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    NSBundle *bundle;
#if TARGET_INTERFACE_BUILDER
    bundle = [NSBundle bundleForClass:[self class]];
#else
    bundle = [NSBundle mainBundle];
#endif
    NSString *path = [bundle pathForResource:_imageName ofType:@"webp"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    UIImage *img = [UIImage sd_imageWithWebPData:data];

    self.image = img;
}

@end
