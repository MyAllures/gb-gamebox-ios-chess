//
//  SH_WelfareView.h
//  GameBox
//
//  Created by egan on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WelfareViewDelegate <NSObject>
- (void)welfareViewDisappear;
@end

@interface SH_WelfareView : UIView
@property (nonatomic, weak) id <WelfareViewDelegate> delegate;
@end
