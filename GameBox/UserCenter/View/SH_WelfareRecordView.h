//
//  SH_WelfareRecordView.h
//  GameBox
//
//  Created by Paul on 2018/7/16.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SH_FundListModel;
@interface SH_WelfareRecordView : UIView
@property(nonatomic,copy)void (^backToDetailViewBlock)(NSString * searchId,SH_FundListModel * model);
+(instancetype)instanceWelfareRecordView;
@end
