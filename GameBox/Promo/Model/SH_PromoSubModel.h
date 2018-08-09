//
//  SH_PromoSubModel.h
//  GameBox
//
//  Created by jun on 2018/8/9.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol SH_PromoSubModel;
@interface SH_PromoSubModel : JSONModel
@property(nonatomic,copy)NSString *code;
@property(nonatomic,copy)NSString *name;
@end
