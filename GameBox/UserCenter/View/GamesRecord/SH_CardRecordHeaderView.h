//
//  SH_CardRecordHeaderView.h
//  GameBox
//
//  Created by Paul on 2018/7/17.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertViewController.h"
@interface SH_CardRecordHeaderView : UIView
@property(nonatomic,strong)AlertViewController * alertVC;
@property(nonatomic,copy)void (^searchConditionBlock)(NSDictionary * context);
+(instancetype)instanceCardRecordHeaderView;
@end
