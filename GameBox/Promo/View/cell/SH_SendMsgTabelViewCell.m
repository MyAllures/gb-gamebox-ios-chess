//
//  SH_SendMsgTabelViewCell.m
//  GameBox
//
//  Created by sam on 2018/7/14.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_SendMsgTabelViewCell.h"
#import "SH_NetWorkService+Promo.h"
#import "HLPopTableView.h"
#import "SH_AdvisoryTypeModel.h"

@interface SH_SendMsgTabelViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (strong, nonatomic) NSString *advisoryType;
@property (strong, nonatomic) NSMutableArray *advisoryTypeArr;
@property (strong, nonatomic) NSMutableArray *advisoryTypeModelArr;
@end

@implementation SH_SendMsgTabelViewCell

- (IBAction)confirmAction:(id)sender {
    if ([self.typeBtn.titleLabel.text isEqualToString:@"请选择"]) {
        showMessage(self, @"发送失败", @"请选择问题类型");
        return;
    }
    if (self.textField.text.length < 4 || self.textField.text.length > 10) {
        showMessage(self, @"发送失败", @"标题在4-10个字");
        return;
    }
    if (self.textView.text.length < 10 || self.textView.text.length > 2000) {
        showMessage(self, @"发送失败", @"内容在10字以上2000字以下");
        return;
    }
    [SH_NetWorkService_Promo startAddApplyDiscountsWithAdvisoryType:self.advisoryType advisoryTitle:self.textField.text advisoryContent:self.textView.text code:@"" complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary *dic = (NSDictionary *)response;
        NSString *msg = dic[@"data"][@"msg"];
        showMessage(self, @"", msg);
        if ([msg containsString:@"提交成功"]) {
            self.textView.text = @"";
            self.textField.placeholder = @"请输入标题";
            [self.typeBtn setTitle:@"请选择" forState:UIControlStateNormal];
        }
        NSLog(@"dic====%@",dic);
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        showMessage(self, @"", @"提交失败");
    }];
}
- (IBAction)seleteTypeAction:(UIButton *)sender {
    HLPopTableView *popTV = [HLPopTableView initWithFrame:CGRectMake(0, 0, sender.bounds.size.width+5, 110) dependView:sender textArr:self.advisoryTypeArr block:^(NSString *region_name, NSInteger index) {
        SH_AdvisoryTypeModel *model = self.advisoryTypeModelArr[index];
        self.advisoryType = model.advisoryType;
        [self.typeBtn setTitle:model.advisoryName forState:UIControlStateNormal];
    }];
    [self addSubview:popTV];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    self.textView.layer.cornerRadius = 5;
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textView.layer.borderWidth = 1;
    
    self.advisoryTypeArr = [NSMutableArray array];
    self.advisoryTypeModelArr = [NSMutableArray array];
    if ([RH_UserInfoManager shareUserManager].isLogin) {
        [MBProgressHUD showHUDAddedTo:self animated:YES];
        [SH_NetWorkService_Promo startAddApplyDiscountsVerify:^(NSHTTPURLResponse *httpURLResponse, id response) {
            NSDictionary *dic = (NSDictionary *)response;
            NSLog(@"dic===%@",dic);
            for (NSDictionary *dict in dic[@"data"][@"advisoryTypeList"]) {
                NSError *err;
                SH_AdvisoryTypeModel *model = [[SH_AdvisoryTypeModel alloc] initWithDictionary:dict error:&err];
                [self.advisoryTypeArr addObject:model.advisoryName];
                [self.advisoryTypeModelArr addObject:model];
            }
            [MBProgressHUD hideHUDForView:self animated:YES];
        } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
            
        }];
    }else{
        showMessage(self, @"", @"请先登录");
    }
    
}

-(void)dealloc {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
