//
//  SH_SliderView.h
//  GameBox
//
//  Created by shin on 2018/7/30.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SH_SliderViewProgressChanging)(CGFloat progress);

@interface SH_SliderView : UIView

@property (nonatomic, assign) CGFloat progress;

- (void)progressChanging:(SH_SliderViewProgressChanging)changingBlcok;

@end
