//
//  SH_ShareView.h
//  GameBox
//
//  Created by Paul on 2018/7/19.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SH_ShareView : UIView
@property(nonatomic,strong)UIViewController  * targetVC;

+(instancetype)instanceShareView;
@end
