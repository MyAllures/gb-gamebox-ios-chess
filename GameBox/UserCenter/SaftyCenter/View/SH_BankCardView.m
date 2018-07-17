//
//  SH_BankCardView.m
//  GameBox
//
//  Created by jun on 2018/7/17.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_BankCardView.h"
@interface SH_BankCardView()
@property (weak, nonatomic) IBOutlet UIButton *chooseBankBtn;

@end
@implementation SH_BankCardView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.chooseBankBtn ButtonPositionStyle:ButtonPositionStyleRight spacing:5];
}
@end
