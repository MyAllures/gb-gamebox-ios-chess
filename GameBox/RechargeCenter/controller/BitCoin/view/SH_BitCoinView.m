//
//  SH_BitCoinView.m
//  GameBox
//
//  Created by jun on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_BitCoinView.h"
#import "SH_BitCoinSubView.h"
#import "SH_BitCoinTextView.h"
#import "PGDatePickManager.h"
#import "SavePhotoTool.h"
@interface SH_BitCoinView()<SH_BitCoinTextViewDelegate,PGDatePickerDelegate>
@property(nonatomic,strong)UIImageView *QRImageView;
@property(nonatomic,strong)SH_BitCoinTextView *bitCoinView;
@property(nonatomic,strong)UILabel *massegeLab;
@property(nonatomic,strong)SH_BitCoinSubView *bitConnHeadView;
@end
@implementation SH_BitCoinView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self configUI];
    }
    return self;
}
- (SH_BitCoinSubView *)bitConnHeadView{
    if (!_bitConnHeadView) {
        _bitConnHeadView = [[NSBundle mainBundle]loadNibNamed:@"SH_BitCoinSubView" owner:self options:nil].firstObject;
        [self addSubview:_bitConnHeadView];
    }
    return _bitConnHeadView;
}
#pragma mark--
#pragma mark--lazy
- (UIImageView *)QRImageView{
    if (!_QRImageView) {
        _QRImageView = [[UIImageView alloc]init];
        [self addSubview:_QRImageView];
    }
    return _QRImageView;
}
- (SH_BitCoinTextView *)bitCoinView{
    if (!_bitCoinView) {
        _bitCoinView = [[NSBundle mainBundle]loadNibNamed:@"SH_BitCoinTextView" owner:self options:nil].firstObject;
        _bitCoinView.delegate = self;
        [self addSubview:_bitCoinView];
    }
    return _bitCoinView;
}
- (UILabel *)massegeLab{
    if (!_massegeLab) {
        _massegeLab = [[UILabel alloc]init];
        _massegeLab.numberOfLines = 0;
        _massegeLab.font = [UIFont systemFontOfSize:14];
        [self addSubview:_massegeLab];
    }
    return _massegeLab;
}
-(void)configUI{
      __weak typeof(self) weakSelf = self;
    UIView *colorView = [[UIView alloc]init];
    colorView.backgroundColor = colorWithRGB(0, 122, 255);
    [self addSubview:colorView];
    [colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@3);
        make.height.equalTo(@20);
        make.top.left.equalTo(self).offset(10);
    }];
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.font = [UIFont systemFontOfSize:14];
    titleLab.text = @"账号信息";
    [self addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(colorView);
        make.left.equalTo(colorView.mas_right).offset(10);
    }];
    
    
    [self.bitConnHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(titleLab.mas_bottom).offset(15);
        make.width.equalTo(@250);
        make.height.equalTo(@140);
    }];
    
    [self.QRImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@120);
        make.centerX.equalTo(self);
        make.top.equalTo(weakSelf.bitConnHeadView.mas_bottom).offset(10);
    }];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setTitle:@"保存手机" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    saveBtn.backgroundColor = colorWithRGB(0, 122, 255);
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveToPhoneBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:saveBtn];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.equalTo(weakSelf.QRImageView);
        make.height.equalTo(@30);
        make.top.equalTo(weakSelf.QRImageView.mas_bottom).offset(5);
    }];
    
    [self.bitCoinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(saveBtn.mas_bottom).offset(15);
        make.left.right.equalTo(self);
        make.height.equalTo(@260);
    }];
    
    [self.massegeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bitCoinView.mas_bottom).offset(30);
        make.left.equalTo(self).offset(15);
        make.right.bottom.equalTo(self).offset(-15);

    }];
    self.massegeLab.text = @"温馨提示：\n• 为了方便系统快速完成转账，请输入正确的txId、交易时间，以加快系统入款速度。\n• 建议您使用Internet Explorer 9以上、360浏览器、Firefox或Google Chrome等浏览器浏览。\n• 如出现充值失败或充值后未到账等情况，请联系在线客服获取帮助。 点击联系在线客服";
}
- (void)setTargetVC:(UIViewController *)targetVC{
    _targetVC = targetVC;
}
#pragma mark--
#pragma mark-- SH_BitCoinTextView代理
-(void)SH_BitCoinTextViewChooseDateBtnClick{
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    datePickManager.isShadeBackgroud = true;
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePicker.delegate = self;
    datePicker.datePickerType = PGPickerViewType2;
    datePicker.datePickerMode = PGDatePickerModeDateHourMinute;
    [self.targetVC presentViewController:datePickManager animated:false completion:nil];
}
- (void)SH_BitCoinTextViewSubmitBtnClickWithAdress:(NSString *)address Txid:(NSString *)txid BitCoinNum:(NSString *)num date:(NSString *)date{
    [self.delegate SH_BitCoinViewAdress:address Txid:txid BitCoinNum:num date:date];
}
#pragma mark - PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [gregorian dateFromComponents:dateComponents];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormat stringFromDate:date];
    [self.bitCoinView updateDateLabWithDataString:dateString];
}
- (void)updateUIWithChannelModel:(SH_RechargeCenterChannelModel *)model{
    [self.QRImageView setImageWithType:1 ImageName:model.qrCodeUrl];
    [self.bitConnHeadView updateUIWithChannelModel:model];
}
-(void)saveToPhoneBtnClick{
    [[SavePhotoTool shared]saveImageToPhoneImage:self.QRImageView.image];
}
@end
