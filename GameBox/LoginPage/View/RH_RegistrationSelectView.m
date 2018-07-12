//
//  RH_RegistrationSelectView.m
//  gameBoxEx
//
//  Created by Lenny on 2018/3/25.
//  Copyright © 2018年 luis. All rights reserved.
//

#import "RH_RegisetInitModel.h"
#import "RH_RegistrationSelectView.h"
#import "coreLib.h"
@interface RH_RegistrationSelectView()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickView;

@end

@implementation RH_RegistrationSelectView
{
    NSInteger selectedRow;
    NSArray<id> *list;
    NSInteger pickerviewColumNum;
    NSString *mType;
    NSInteger selectedYear;
    NSInteger selectedMonth;
    NSInteger selectedDay;
}
@synthesize pickView = _pickView;
- (UIPickerView *)pickView {
    
    if (_pickView == nil) {
        _pickView = [[UIPickerView alloc] init];
        _pickView.delegate = self;
        _pickView.dataSource = self;
    }
    return _pickView;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.backgroundColor = colorWithRGB(213, 213, 213);
        UIButton *button_Cancel = [UIButton new];
        [self addSubview:button_Cancel];
        [button_Cancel  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(5);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(44);
        }];
//        button_Cancel.whc_LeftSpace(15).whc_TopSpace(5).whc_Width(60).whc_Height(44);
        button_Cancel.layer.cornerRadius = 5;
        button_Cancel.clipsToBounds = YES;
        [button_Cancel setTitle:@"取消" forState:UIControlStateNormal];
        [button_Cancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        UIButton *button_Confirm = [UIButton new];
        [self addSubview:button_Confirm];
        [button_Confirm mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(44);
            make.width.mas_equalTo(60);
        }];
//        button_Confirm.whc_TopSpace(5).whc_RightSpace(15).whc_Height(44).whc_Width(60);
        button_Confirm.layer.cornerRadius = 5;
        button_Confirm.clipsToBounds = YES;
        [button_Confirm setTitle:@"确定" forState:UIControlStateNormal];
        [button_Confirm addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        UIView *line = [UIView new];
        [self addSubview:line];
        [line  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(-20);
            make.height.mas_equalTo(2);
            make.top.mas_equalTo(button_Confirm).mas_offset(10);
        }];
//        line.whc_LeftSpace(20).whc_RightSpace(20).whc_Height(2).whc_TopSpaceToView(10, button_Confirm);
        
        [self addSubview:self.pickView];
//        self.pickView.whc_TopSpaceToView(5, line).whc_LeftSpace(0).whc_RightSpace(0).whc_BottomSpace(0);
        [self.pickView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0);
            make.top.mas_equalTo(line).mas_offset(5);
        }];
        selectedDay = 01;
        selectedYear = 1918;
        selectedMonth = 01;
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
//    self.pickView.whc_BottomSpace(0);
    [self.pickView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
    }];
}

- (void)cancel {
    ifRespondsSelector(self.delegate, @selector(RH_RegistrationSelectViewDidCancelButtonTaped)){
        [self.delegate RH_RegistrationSelectViewDidCancelButtonTaped] ;
    }
}
- (void)confirm {
    ifRespondsSelector(self.delegate, @selector(RH_RegistrationSelectViewDidConfirmButtonTapedwith:)){
        if ([mType isEqualToString:@"birthday"]) {
            [self.delegate RH_RegistrationSelectViewDidConfirmButtonTapedwith:[NSString stringWithFormat:@"%02ld-%02ld-%02ld", (long)selectedYear, (long)selectedMonth,selectedDay]] ;
        }else {
            id s = @"";
            if ([list[selectedRow] isKindOfClass:[SexModel class]]) {
                SexModel *model = list[selectedRow];
                s = model.mText;
            }
            if ([list[selectedRow] isKindOfClass:[MainCurrencyModel class]]) {
                MainCurrencyModel *model = list[selectedRow];
                s = model.mText;
            }
            if ([list[selectedRow] isKindOfClass:[DefaultLocaleModel class]]) {
                DefaultLocaleModel *model = list[selectedRow];
                s = model.mText;
            }
            if ([list[selectedRow] isKindOfClass:[SecurityIssuesModel class]]) {
                SecurityIssuesModel *model = list[selectedRow];
                s = model.mText;
            }
            [self.delegate RH_RegistrationSelectViewDidConfirmButtonTaped:list[selectedRow]];
        }
    }
}

- (void)setDataList:(NSArray<id> *)dataList {
    list = [NSArray array];
    list = dataList;
}

- (void)setColumNumbers:(NSInteger)num {
    pickerviewColumNum = num;
}

- (void)setSelectViewType:(NSString *)type {
    mType = type;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([mType isEqualToString:@"birthday"]) {
        if (component == 0) {
            return 2000 - 1918;
        }
        if (component == 1) {
            return 12;
        }
        if (component == 2) {
            return 31;
        }
    }else {
        
    }
    return list.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([mType isEqualToString:@"birthday"]) {
        if (component == 0) {
            return [NSString stringWithFormat:@"%ld", row + 1918];
        }
        if (component == 1) {
            return [NSString stringWithFormat:@"%ld", row + 1];
        }
        if (component == 2) {
            return [NSString stringWithFormat:@"%ld", row + 1];
        }
    }
    else {
        if ([list[row] isKindOfClass:[SexModel class]]) {
            SexModel *model = list[row];
            return model.mText;
        }
        if ([list[row] isKindOfClass:[MainCurrencyModel class]]) {
            MainCurrencyModel *model = list[row];
            return model.mText;
        }
        if ([list[row] isKindOfClass:[DefaultLocaleModel class]]) {
            DefaultLocaleModel *model = list[row];
            return model.mText;
        }
        if ([list[row] isKindOfClass:[SecurityIssuesModel class]]) {
            SecurityIssuesModel *model = list[row];
            return model.mText;
        }
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"%s", __func__);
    if (component == 0) {
        selectedYear = row + 1918;
    }
    if (component == 1) {
        selectedMonth = row + 1;
    }
    if (component == 2) {
        selectedDay = row + 1;
    }
    selectedRow = row;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return pickerviewColumNum ;
}


@end
