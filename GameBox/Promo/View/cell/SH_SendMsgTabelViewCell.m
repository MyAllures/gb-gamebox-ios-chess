//
//  SH_SendMsgTabelViewCell.m
//  GameBox
//
//  Created by sam on 2018/7/14.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_SendMsgTabelViewCell.h"
#import "SH_NetWorkService+Promo.h"

@interface SH_SendMsgTabelViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (strong, nonatomic) NSString *advisoryType;
@end

@implementation SH_SendMsgTabelViewCell

- (IBAction)confirmAction:(id)sender {
    [SH_NetWorkService_Promo startAddApplyDiscountsWithAdvisoryType:self.advisoryType advisoryTitle:self.textField.text advisoryContent:self.textView.text code:@"" complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary *dic = (NSDictionary *)response;
        NSLog(@"dic====%@",dic);
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        
    }];
}
- (IBAction)seleteTypeAction:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"pickView" object:nil];
}

-(void)sendMsg:(NSNotification *)text {
    
    [self.typeBtn setTitle:text.userInfo[@"key"] forState:UIControlStateNormal];
    self.advisoryType = text.userInfo[@"advisoryType"];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMsg:) name:@"sendMsg" object:nil];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    self.textView.layer.cornerRadius = 5;
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.layer.borderWidth = 1;
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"sendMsg" object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
