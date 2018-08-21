//
//  SH__PromoApplyModel.h
//  GameBox
//
//  Created by jun on 2018/8/16.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "SH_ApplyDetailsModel.h"
@interface SH__PromoApplyModel : JSONModel
@property(nonatomic,copy)NSString <Optional>*actibityTitle;
@property(nonatomic,copy)NSString <Optional>*applyResult;
@property(nonatomic,copy)NSString <Optional>*status;
@property(nonatomic,copy)NSString <Optional>*searchId;
@property(nonatomic,copy)NSString <Optional>*tips;
@property(nonatomic,copy)NSArray <SH_ApplyDetailsModel>*applyDetails;
@end
