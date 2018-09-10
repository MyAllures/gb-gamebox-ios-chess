//
//  SH_GameItemView.m
//  GameBox
//
//  Created by shin on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_GameItemView.h"
#import "SH_GameItemModel.h"
#import "UIImage+SH_WebPImage.h"

@interface SH_GameItemView ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;

@end

@implementation SH_GameItemView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setGameItemModel:(SH_GameItemModel *)gameItemModel
{
    _gameItemModel = gameItemModel;
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:_gameItemModel.cover] placeholderImage:[UIImage imageNamed:@"loading"] options:SDWebImageAllowInvalidSSLCertificates];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    ifRespondsSelector(self.delegate, @selector(gameItemView:didSelect:))
    {
        self.iconImg.highlighted = YES;
        [UIView animateKeyframesWithDuration:0.5 delay:0 options:0 animations: ^{
            [UIView addKeyframeWithRelativeStartTime:1/3.0 relativeDuration:1/3.0 animations: ^{
                self.transform = CGAffineTransformMakeScale(0.95, 0.95);
            }];
        } completion:nil];
        
        [UIView animateKeyframesWithDuration:0.5 delay:0 options:0 animations: ^{
            [UIView addKeyframeWithRelativeStartTime:1/3.0 relativeDuration:1/3.0 animations: ^{
                self.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }];
        } completion:nil];
//        CIContext *context = [CIContext contextWithOptions:nil];
//        CIImage *superImage = [CIImage imageWithCGImage:self.iconImg.image.CGImage];
//        CIFilter *lighten = [CIFilter filterWithName:@"CIColorControls"];
//        [lighten setValue:superImage forKey:kCIInputImageKey];
//
////        // 修改亮度   -1---1   数越大越亮
////        [lighten setValue:@(0.2) forKey:@"inputBrightness"];
////
//        // 修改饱和度  0---2
//        [lighten setValue:@(1.4) forKey:@"inputSaturation"];
//
//        // 修改对比度  0---4
//        [lighten setValue:@(1.5) forKey:@"inputContrast"];
//        CIImage *result = [lighten valueForKey:kCIOutputImageKey];
//        CGImageRef cgImage = [context createCGImage:result fromRect:[superImage extent]];
//
//        // 得到修改后的图片
//        self.iconImg.image = [UIImage imageWithCGImage:cgImage];
//
//        // 释放对象
//        CGImageRelease(cgImage);
        
        [self.delegate gameItemView:self didSelect:self.gameItemModel];
    }
}

@end
