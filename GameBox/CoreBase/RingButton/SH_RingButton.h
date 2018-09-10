//
//  SH_RingButton.h
//  GameBox
//
//  Created by shin on 2018/7/12.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    SH_Ring_Type_Alert = 1,
    SH_Ring_Type_Money,
    SH_Ring_Type_Err,
} SH_Ring_Type;

IB_DESIGNABLE
@interface SH_RingButton : UIButton

@property (nonatomic, assign) IBInspectable int ringType;
-(void)setScale;
@end
