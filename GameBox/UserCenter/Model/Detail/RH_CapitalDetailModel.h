//
//  RH_CapitalDetailModel.h
//  gameBoxEx
//
//  Created by Richard on 2018/1/10.
//  Copyright © 2018年 luis. All rights reserved.
//


#import <CoreGraphics/CoreGraphics.h>
@interface RH_CapitalDetailModel : JSONModel
@property(nonatomic,strong)NSString *administrativeFee;

/**
 创建实际
 */
@property(nonatomic,strong)NSDate   *createTime;

/**
 扣除优惠（银行卡里的信息）
 */
@property(nonatomic,strong)NSString *deductFavorable;

/**
 失败原因
 */
@property(nonatomic,strong)NSString *failureReason;
@property(nonatomic,strong)NSString *fundType;
@property(nonatomic,strong)NSString *mId;
@property(nonatomic,strong)NSString *payerBankcard;

/**
 手续费
 */
@property(nonatomic,strong)NSString *poundage;

/**
 真实姓名
 */
@property(nonatomic,strong)NSString *realName;

/**
 交易地址
 */
@property(nonatomic,strong)NSString *rechargeAddress;

/**
 存款金额
 */
@property(nonatomic,strong)NSString *rechargeAmount;
/**
 实际到账
 */
@property(nonatomic,strong)NSString *rechargeTotalAmount;

/**
 状态
 */
@property(nonatomic,strong)NSString *status;

/**
 状态名称
 */
@property(nonatomic,strong)NSString *statusName;

/**
 转账金额
 */
@property(nonatomic,strong)NSString *transactionMoney;

/**
 交易号
 */
@property(nonatomic,strong)NSString *transactionNo;
@property(nonatomic,strong)NSString *transactionType;
@property(nonatomic,strong)NSString *transactionWay;
@property(nonatomic,strong)NSString *withdrawMoney;

/**
 描述
 */
@property(nonatomic,strong)NSString *transactionWayName;
@property(nonatomic,strong)NSString *username;

/**
 转入
 */
@property(nonatomic,strong)NSString *transferInto;

/**
 转出
 */
@property(nonatomic,strong)NSString *transferOut;


/**
 其它方式
 */
@property(nonatomic,strong)NSString *bankCodeName;

/**
 银行卡url
 */
@property(nonatomic,strong)NSString *bankUrl;


/**
 银行类型
 */
@property(nonatomic,strong)NSString *bankCode;
/**
 txId
 */
@property(nonatomic,strong)NSString *txId;

/**
 比特币地址
 */
@property(nonatomic,strong)NSString *bitcoinAdress;
/**
  比特币交易时间
 */
@property(nonatomic,strong)NSDate *returnTime;
//extend
@property(nonatomic,strong)NSString *bankURL;

@end
