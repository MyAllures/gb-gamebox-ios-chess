//
//  SH_BankCardModel.m
//  GameBox
//
//  Created by jun on 2018/7/18.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_BankCardModel.h"

@implementation SH_BankCardModel
-(void)setBankDeposit:(NSString<Optional> *)bankDeposit{
    _bankDeposit = bankDeposit;
}

-(void)setBankName:(NSString<Optional> *)bankName{
    _bankName = bankName;
}
-(void)setBankcardNumber:(NSString<Optional> *)bankcardNumber{
    _bankcardNumber = bankcardNumber;
}
-(void)setRealName:(NSString<Optional> *)realName{
    _realName = realName;
}

@end
