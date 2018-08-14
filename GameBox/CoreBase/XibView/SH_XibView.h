//
//  SH_XibView.h
//  GameBox
//
//  Created by shin on 2018/7/25.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SH_ColorConfigView.h"

IB_DESIGNABLE
@interface SH_XibView : SH_ColorConfigView

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;

@end
