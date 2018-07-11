//
//  RH_RegistrationSelectView.h
//  gameBoxEx
//
//  Created by Lenny on 2018/3/25.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RH_RegistrationSelectViewDelegate
- (void)RH_RegistrationSelectViewDidCancelButtonTaped;
- (void)RH_RegistrationSelectViewDidConfirmButtonTapedwith:(NSString *)selected;
- (void)RH_RegistrationSelectViewDidConfirmButtonTaped:(id )selected;
@end
@interface RH_RegistrationSelectView : UIView
@property (nonatomic, weak) id<RH_RegistrationSelectViewDelegate> delegate;
- (void)setSelectViewType:(NSString *)type;
- (void)setDataList:(NSArray<id> *)dataList;
- (void)setColumNumbers:(NSInteger )num;
- (void)setBirthDayMin:(NSInteger )start MaxDate:(NSInteger )end;
@end
