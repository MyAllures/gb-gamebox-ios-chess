//
//  UIImageView+handle.m
//  lotteryBox
//
//  Created by jun on 2018/4/30.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "UIImageView+handle.h"
@implementation UIImageView (handle)

-(void)setImageWithType:(NSInteger)type ImageName:(NSString *)imageName{
    if (type == 0) {
        self.image = [UIImage imageNamed:imageName];
    }else{
        NSString *imageUrl;
        if ([imageName containsString:@"http"] || [imageName containsString:@"https:"]) {
            imageUrl = imageName ;
        }else
        {
            imageUrl = [NSString stringWithFormat:@"%@/%@",[NetWorkLineMangaer sharedManager].currentPreUrl,imageName] ;
        }
        [self sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
        
    }
}
@end
