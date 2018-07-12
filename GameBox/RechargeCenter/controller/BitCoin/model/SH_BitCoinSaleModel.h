//
//  SH_BitCoinSaleModel.h
//  GameBox
//
//  Created by jun on 2018/7/12.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "JSONModel.h"
#import "SH_BitCoinSaleDetailModel.h"
@interface SH_BitCoinSaleModel : JSONModel
@property(nonatomic,copy)NSString<Optional> *msg;
@property(nonatomic,copy)NSString<Optional>  *fee;
@property(nonatomic,copy)NSString<Optional> *counterFee;
@property(nonatomic,copy)NSString <Optional>*failureCount;
@property(nonatomic,strong)NSArray<Optional,SH_BitCoinSaleDetailModel> *sales;
@end
