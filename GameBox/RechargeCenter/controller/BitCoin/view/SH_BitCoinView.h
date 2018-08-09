//
//  SH_BitCoinView.h
//  GameBox
//
//  Created by jun on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SH_RechargeCenterChannelModel.h"
@protocol SH_BitCoinViewDelegate<NSObject>
-(void)SH_BitCoinViewAdress:(NSString *)address Txid:(NSString *)txid BitCoinNum:(NSString *)num date:(NSString *)date;
@end
@interface SH_BitCoinView : UIView
@property(nonatomic,weak)id<SH_BitCoinViewDelegate>delegate;
-(void)updateUIWithChannelModel:(SH_RechargeCenterChannelModel *)model;
@end
