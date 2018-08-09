//
//  SH_PromoModel.h
//  GameBox
//
//  Created by jun on 2018/8/9.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "SH_PromoSubModel.h"
@interface SH_PromoModel : JSONModel
@property(nonatomic,copy)NSString *activityKey;
@property(nonatomic,copy)NSString *activityTypeName;
@property(nonatomic,strong)NSArray <SH_PromoSubModel>*activityList;
@end
