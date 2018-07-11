//
//  SH_BitCoinTextView.m
//  GameBox
//
//  Created by jun on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_BitCoinTextView.h"
@interface SH_BitCoinTextView()
@property (weak, nonatomic) IBOutlet UITextField *bitCoinAdressTexField;
@property (weak, nonatomic) IBOutlet UITextField *txidTextfield;
@property (weak, nonatomic) IBOutlet UITextField *numTextfield;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;

@end
@implementation SH_BitCoinTextView

- (void)awakeFromNib{
    [super awakeFromNib];
}
- (IBAction)chooseDateBtnClick:(id)sender {
    [self.delegate SH_BitCoinTextViewChooseDateBtnClick];
}
- (IBAction)submitBtnClick:(id)sender {
    
}
-(void)updateDateLabWithDataString:(NSString *)dateStr{
    self.dateLab.text = dateStr;
}
@end
