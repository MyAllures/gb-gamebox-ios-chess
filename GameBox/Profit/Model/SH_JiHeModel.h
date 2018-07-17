//
//  SH_JiHeModel.h
//  GameBox
//
//  Created by jun on 2018/7/17.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "JSONModel.h"
#import "SH_JiHeSubModel.h"
@interface SH_JiHeModel : JSONModel
@property(nonatomic,copy)NSString <Optional>*currencySign;
@property(nonatomic,strong)NSArray<Optional,SH_JiHeSubModel> *withdrawAudit;
@end
