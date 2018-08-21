//
//  SH_ApplyFailTableViewCell.m
//  GameBox
//
//  Created by jun on 2018/8/14.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_ApplyFailTableViewCell.h"
#import "SH_PromoApplyProgressView.h"
#import "SH_NetWorkService+PromoActivities.h"
@interface SH_ApplyFailTableViewCell()
@property (weak, nonatomic) IBOutlet SH_WebPImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet SH_WebPButton *applyBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *proTrailing;
@property (weak, nonatomic) IBOutlet SH_PromoApplyProgressView *progressView;
@property(nonatomic,copy)NSString *searchId;
@property(nonatomic,copy)NSString *transactionNo;

@end
@implementation SH_ApplyFailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)updateUIWithModel:(SH_ApplyDetailsModel *)model
           SearchId:(NSString *)searchId{
    self.searchId = searchId;
    self.transactionNo = model.transactionNo;
    self.titleLab.text = model.condition;
    if ([model.mayApply isEqualToString:@"1"]) {
        //展示申请按钮
        self.applyBtn.hidden = NO;
        self.proTrailing.constant = 100;
    }else{
        self.applyBtn.hidden = YES;
        self.proTrailing.constant = 0;
    }
    if ([model.showSchedule isEqualToString:@"1"]) {
        //展示进度条
        self.numLab.hidden = NO;
        self.progressView.hidden = NO;
        [self.progressView changeProgressValue:[model.reached floatValue]/[model.standard floatValue]];
    }else{
        self.numLab.hidden = YES;
        self.progressView.hidden = YES;
    }
    UIColor *numColor;
    NSString *iconImageName;
    if ([model.satisfy isEqualToString:@"1"]) {
        //满足条件
        numColor = [UIColor colorWithHexStr:@"#2DE614"];
        iconImageName = @"success2";
    }else{
        numColor = [UIColor colorWithHexStr:@"#CE0101"];
        iconImageName = @"error2";
    }
    self.iconImageView.imageName = iconImageName;
    [self.numLab setTextWithFirstString:[NSString stringWithFormat:@"%@/%@",model.reached,model.standard] SecondString:model.reached FontSize:13 Color:numColor];
}

- (IBAction)applyBtnClick:(id)sender {
    [SH_NetWorkService applyPromoActivitiesPromoId:self.searchId TransactionNo:self.transactionNo  Sucess:^(SH__PromoApplyModel *model) {
        showMessage(self, @"申请成功", nil);
 
    } Failure:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        showMessage(self, err, nil);
    }];
}
@end
