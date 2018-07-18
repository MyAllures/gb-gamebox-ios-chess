//
//  SH_WelfareView.h
//  GameBox
//
//  Created by egan on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SH_WelfareView : UIView
@property (weak, nonatomic) IBOutlet UILabel *withdrawal_label;
@property (weak, nonatomic) IBOutlet UILabel *transfer_label;
@property(nonatomic,copy)void (^dataBlock)(NSDictionary * context);
+(instancetype)instanceWelfareView;
@end
