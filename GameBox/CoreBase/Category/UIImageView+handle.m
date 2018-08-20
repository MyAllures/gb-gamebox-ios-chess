//
//  UIImageView+handle.m
//  lotteryBox
//
//  Created by jun on 2018/4/30.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "UIImageView+handle.h"
@implementation UIImageView (handle)

-(void)setImageWithType:(NSInteger)type
              ImageName:(NSString *)imageName
            Placeholder:(NSString *)placeholder{
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
        UIImage * place ;
        if (placeholder) {
            place = [UIImage imageNamed:placeholder];
        }
        [self sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:place options:SDWebImageAllowInvalidSSLCertificates];
        
    }
}
@end
