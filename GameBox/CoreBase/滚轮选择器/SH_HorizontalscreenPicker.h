//
//  SH_HorizontalscreenPicker.h
//  GameBox
//
//  Created by jun on 2018/7/19.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^selectedBlock)(NSInteger selectedValue);
@interface SH_HorizontalscreenPicker : UIView
@property (strong, nonatomic) selectedBlock confirmBlock;
-(void)updateWithDatas:(NSArray *)datas;
@end
