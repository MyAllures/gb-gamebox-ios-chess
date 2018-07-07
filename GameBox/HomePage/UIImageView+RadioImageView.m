//
//  UIImageView+RadioImageView.m
//  GameBox
//
//  Created by egan on 2018/7/6.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "UIImageView+RadioImageView.h"
#import "UIImage+RadioImage.h"

@implementation UIImageView (RadioImageView)

- (void)addCorner:(CGFloat)radius
{
    self.image = [self.image drawRectWithRoundedCorner:radius sizeToFit:self.bounds.size];
}


@end
