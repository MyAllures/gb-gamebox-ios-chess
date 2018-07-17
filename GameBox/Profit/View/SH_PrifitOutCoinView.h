//
//  SH_PrifitOutCoinView.h
//  GameBox
//
//  Created by jun on 2018/7/16.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SH_PrifitOutCoinView : UIView
-(void)updateUIWithBalance:(NSString *)balance
                   BankNum:(NSString *)bankNum;
@end
