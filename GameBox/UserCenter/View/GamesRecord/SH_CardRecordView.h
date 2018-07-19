//
//  SH_CardRecordView.h
//  GameBox
//
//  Created by egan on 2018/7/15.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RH_BettingInfoModel;
@interface SH_CardRecordView : UIView
@property(nonatomic,copy)void (^backToDetailViewBlock)(NSString * info);
+(instancetype)instanceCardRecordView;
@end
