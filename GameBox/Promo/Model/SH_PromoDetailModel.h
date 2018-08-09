//
//  SH_PromoDetailModel.h
//  GameBox
//
//  Created by jun on 2018/8/9.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface SH_PromoDetailModel : JSONModel
@property(nonatomic,copy)NSString <Optional>*photo;
@property(nonatomic,copy)NSString <Optional>*url;
@property(nonatomic,copy)NSString <Optional>*ID;
@property(nonatomic,copy)NSString <Optional>*name;
@property(nonatomic,copy)NSString <Optional>*status;
@property(nonatomic,copy)NSString <Optional>*orderNum;
@property(nonatomic,copy)NSString <Optional>*explain;
@property(nonatomic,copy)NSString <Optional>*time;
@end
