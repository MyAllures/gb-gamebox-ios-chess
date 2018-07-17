//
//  SH_WelfareView.h
//  GameBox
//
//  Created by egan on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SH_WelfareView : UIView
@property(nonatomic,copy)void (^dataBlock)(NSDictionary * context);
@end
