//
//  SH_PlayerCenterView.h
//  GameBox
//
//  Created by egan on 2018/7/9.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlayerCenterViewDelegate <NSObject>
- (void)removeView;
- (void)popView:(UIButton *)btn;
@end

@interface SH_PlayerCenterView : UIView
@property (nonatomic, weak) id <PlayerCenterViewDelegate> delegate;
@end
