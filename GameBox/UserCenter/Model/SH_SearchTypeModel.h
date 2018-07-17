//
//  SH_SearchTypeModel.h
//  GameBox
//
//  Created by Paul on 2018/7/17.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "JSONModel.h"

@interface SH_SearchTypeModel : JSONModel
@property(nonatomic,strong)NSString *deposit;
@property(nonatomic,strong)NSString *backwater;
@property(nonatomic,strong)NSString *withdrawals;
@property(nonatomic,strong)NSString *recommend;
@property(nonatomic,strong)NSString *transfers;
@property(nonatomic,strong)NSString *favorable;
@end
