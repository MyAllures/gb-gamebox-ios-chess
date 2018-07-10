//
//  SH_NavigationView.h
//  GameBox
//
//  Created by jun on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SH_NavigationViewDelegate<NSObject>
-(void)SH_NavigationViewBackBtnClick;
@end
@interface SH_NavigationView : UIView
@property(nonatomic,weak)id<SH_NavigationViewDelegate>delegate;
-(void)updateUIWithTitle:(NSString *)title;
@end
