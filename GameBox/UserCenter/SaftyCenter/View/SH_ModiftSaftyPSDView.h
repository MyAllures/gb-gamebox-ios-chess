//
//  SH_ModiftSaftyPSDView.h
//  GameBox
//
//  Created by jun on 2018/7/17.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SH_XibView.h"

@interface SH_ModiftSaftyPSDView : SH_XibView
@property(nonatomic,strong)UIViewController *targetVC;
@property (weak, nonatomic) IBOutlet UITextField *realNameTF;
-(void)updateView;
@end
