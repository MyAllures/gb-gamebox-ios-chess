//
//  SH_XibButton.h
//  GameBox
//
//  Created by shin on 2018/8/2.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface SH_XibButton : UIButton

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;

@end
