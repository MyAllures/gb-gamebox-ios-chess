//
//  SH_WelfareWarehouse.m
//  GameBox
//
//  Created by sam on 2018/8/17.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_WelfareWarehouse.h"
@interface SH_WelfareWarehouse ()
@property (weak, nonatomic) IBOutlet UILabel *currentGoldCoinLabel;
@property (weak, nonatomic) IBOutlet UILabel *warehouseBalanceLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet SH_WebPImageView *numImageView;
@property (weak, nonatomic) IBOutlet SH_WebPButton *depositBtn;
@property (weak, nonatomic) IBOutlet SH_WebPButton *withdrawalBtn;
@property (weak, nonatomic) IBOutlet SH_WebPButton *thirtyPercentBtn;
@property (weak, nonatomic) IBOutlet SH_WebPButton *fiftyPercentBtn;
@property (weak, nonatomic) IBOutlet SH_WebPButton *allBtn;
@property (weak, nonatomic) IBOutlet SH_WebPButton *sureBtn;

@property (assign, nonatomic) NSInteger index;

@end

@implementation SH_WelfareWarehouse

- (IBAction)tapAction:(SH_WebPButton *)sender {
        self.index = sender.tag;
        if (sender.tag == 0) {
            [self updateDepositUI];
        } else {
            [self updateWithdrawalUI];
        }
}
//更新寄存UI
-(void)updateDepositUI {
    self.textField.text = @"";
    self.depositBtn.webpBGImage = @"button-long-click";
    self.withdrawalBtn.webpBGImage = @"button-long";
    self.numImageView.imageName = @"input_top_bg";
    [self.thirtyPercentBtn setTitle:@"存30%" forState:UIControlStateNormal];
    [self.fiftyPercentBtn setTitle:@"存50%" forState:UIControlStateNormal];
    [self.sureBtn setTitle:@"确定寄存" forState:UIControlStateNormal];
}
//更新支取UI
-(void)updateWithdrawalUI {
    self.textField.text = @"";
    self.numImageView.imageName = @"input_top_bg2";
    self.depositBtn.webpBGImage = @"button-long";
    self.withdrawalBtn.webpBGImage = @"button-long-click";
    [self.thirtyPercentBtn setTitle:@"取30%" forState:UIControlStateNormal];
    [self.fiftyPercentBtn setTitle:@"取50%" forState:UIControlStateNormal];
    [self.sureBtn  setTitle:@"确定支取" forState:UIControlStateNormal];
}
//存或取事件
- (IBAction)saveOrTakeAction:(UIButton *)sender {
    switch (sender.tag) {
            //30%
        case 10:
            if (self.index == 0) {
                //存
            } else {
                //取
            }
            break;
            //50%
        case 11:
            if (self.index == 0) {
                //存
            } else {
                //取
            }
            break;
            //全部
        case 12:
            if (self.index == 0) {
                //存
            } else {
                //取
            }
            break;
            
        default:
            break;
    }
}
//确定事件
- (IBAction)sureAction:(id)sender {
    if (self.index == 0) {
        //确定存
    } else {
        //确定取
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
