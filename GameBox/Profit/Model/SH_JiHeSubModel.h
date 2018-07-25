//
//  SH_JiHeSubModel.h
//  GameBox
//
//  Created by jun on 2018/7/17.
//  Copyright © 2018年 shin. All rights reserved.
//

/**
 *  "createTime": 1528110629149,     //订单创建时间，0时区时间
 *  "rechargeAmount": 1,             //存款金额
 *  "rechargeAudit": 4.7,            //存款稽核
 *  "rechargeRemindAudit": 5,        //剩余存款稽核
 *  "rechargeFee": 0,                //行政费用，如果为0显示通过，其他直接展示费用
 *  "favorableAmount": null,         //优惠金额
 *  "favorableAudit": null,          //优惠稽核
 *  "favorableRemindAudit": null,    //剩余优惠稽核
 *  "favorableFee": null             //优惠扣除，如果为0显示通过，其他直接展示费用
 */

#import "JSONModel.h"
@protocol SH_JiHeSubModel;
@interface SH_JiHeSubModel : JSONModel
@property(nonatomic,copy)NSString <Optional>*createTime;
@property(nonatomic,copy)NSString <Optional>*rechargeAmount;
@property(nonatomic,copy)NSString <Optional>*rechargeAudit;
@property(nonatomic,copy)NSString <Optional>*rechargeRemindAudit;
@property(nonatomic,copy)NSString <Optional>*rechargeFee;
@property(nonatomic,copy)NSString <Optional>*favorableAmount;
@property(nonatomic,copy)NSString <Optional>*favorableAudit;
@property(nonatomic,copy)NSString <Optional>*favorableRemindAudit;
@property(nonatomic,copy)NSString <Optional>*favorableFee;
@end
