//
//  SH_WelfareDetailView.h
//  GameBox
//
//  Created by Paul on 2018/7/17.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SH_FundListModel.h"
@interface SH_WelfareDetailView : UIView
@property(nonatomic,copy)NSString * searchId;
@property(nonatomic,strong)SH_FundListModel * infoModel;
+(instancetype)instanceWelfareDetailView;
@end
