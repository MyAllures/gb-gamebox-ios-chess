//
//  SH_RechargeCenterAccountModel.h
//  GameBox
//
//  Created by jun on 2018/7/9.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "JSONModel.h"

@protocol SH_RechargeCenterAccountModel;
@interface SH_RechargeCenterAccountModel : JSONModel
@property(nonatomic,strong,readonly)NSString <Optional>*code;
@property (nonatomic,strong,readonly)NSString <Optional>*name;
@end
