//
//  SH_FeeModel.h
//  GameBox
//
//  Created by jun on 2018/7/17.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "JSONModel.h"

@interface SH_FeeModel : JSONModel
@property(nonatomic,copy)NSString <Optional>*actualWithdraw;//实际取款金额
@property(nonatomic,copy)NSString <Optional>*administrativeFee;//行政费
@property(nonatomic,copy)NSString <Optional>* counterFee;//手续费
@property(nonatomic,copy)NSString <Optional>*deductFavorable;//扣除优惠
@end
