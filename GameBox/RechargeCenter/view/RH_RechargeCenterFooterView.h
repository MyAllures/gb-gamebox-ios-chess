//
//  RH_RechargeCenterFooterView.h
//  testDemo
//
//  Created by jun on 2018/7/6.
//  Copyright © 2018年 jun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SH_RechargeCenterChannelModel.h"
@protocol RH_RechargeCenterFooterViewDelegate<NSObject>
-(void)RH_RechargeCenterFooterViewSubmitBtnClick;
@end
@interface RH_RechargeCenterFooterView : UICollectionReusableView
@property(nonatomic,weak)id<RH_RechargeCenterFooterViewDelegate>delegate;
-(void)updateUIWithCode:(NSString *)code
                   Type:(NSString *)type
                 Number:(NSString *)number
      ChannelModelArray:(NSArray *)array
           ChannelModel:(SH_RechargeCenterChannelModel *)channelModel;
@end
