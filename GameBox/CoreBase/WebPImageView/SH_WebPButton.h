//
//  SH_WebPButton.h
//  GameBox
//
//  Created by shin on 2018/7/22.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SH_RingButton.h"

IB_DESIGNABLE

@interface SH_WebPButton : SH_RingButton

@property (nonatomic, strong) IBInspectable NSString *webpImage;
@property (nonatomic, strong) IBInspectable NSString *webpBGImage;

- (void)setWebpImage:(NSString *)webpImage forState:(UIControlState)state;
- (void)setWebpBGImage:(NSString *)webpImage forState:(UIControlState)state;

@end
