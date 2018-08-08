//
//  RH_RegistrationViewItem.m
//  gameBoxEx
//
//  Created by Lenny on 2018/3/23.
//  Copyright © 2018年 luis. All rights reserved.
//
#import "RH_RegistrationSelectView.h"
#import "RH_RegistrationViewItem.h"
#import "coreLib.h"

#import "SH_NetWorkService+RegistAPI.h"
#import "RH_UserInfoManager.h"
@interface RH_RegistrationViewItem() <RH_RegistrationSelectViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate>
{
    dispatch_source_t timer;
}
//@property (nonatomic, strong) NSTimer *timer;

@end
@implementation RH_RegistrationViewItem
{
    UILabel *label_Title;
    UITextField *textField;
    UIButton *button_Check;
    
    UIImageView *imageView_VerifyCode;
    FieldModel *fieldModel;
    NSInteger minDateYear;
    NSInteger maxDateYear;
    RH_RegistrationSelectView *selectView;

    
    NSArray<SexModel *> *sexModel;
    NSArray<MainCurrencyModel *> *mainCurrencyModel;
    NSArray<DefaultLocaleModel *> *defaultLocaleModel;
    NSArray<SecurityIssuesModel *> *securityIssuesModel;
    
    id selectedItem;
    NSInteger countDownNumber;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        label_Title = [UILabel new];
        [self addSubview:label_Title];
        [label_Title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.height.mas_equalTo(24);
            make.width.mas_equalTo(120);//120
            make.centerY.mas_equalTo(self);
        }];

        label_Title.font = [UIFont systemFontOfSize:13];
        label_Title.textColor = [UIColor  colorWithHexStr:@"0xFFFFFF"];
        label_Title.textAlignment = NSTextAlignmentRight;
        
        textField = [UITextField new];
        [self addSubview:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.right.mas_equalTo(0);
            make.leading.mas_equalTo(self->label_Title.mas_trailing).mas_offset(8);
            make.height.mas_equalTo(38);
        }];

        textField.layer.borderColor = [[UIColor  colorWithHexStr:@"0x0E295F"] CGColor];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.layer.borderWidth = 1;
        textField.layer.cornerRadius = 3;
        textField.clipsToBounds = YES;
        textField.font = [UIFont systemFontOfSize:15];
        textField.textColor = [UIColor  whiteColor];
        textField.delegate = self;
        textField.backgroundColor = [UIColor  colorWithHexStr:@"0x232B6A"];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeImageView_VerfyCode1) name:@"changeImageView_VerfyCode" object:nil];
        
    }
    return self;
}

- (BOOL)isRequire {
    if ([fieldModel.isRequired isEqualToString:@"2"]) {
        return NO;
    }
    return YES;
}
- (NSString *)contentType {
    return fieldModel.name;
}

- (NSString *)textFieldContent {
    if ([fieldModel.name isEqualToString:@"sex"]) {
        SexModel *model = selectedItem;
        return model.mValue ?: @"";
    }
    if ([fieldModel.name isEqualToString:@"mainCurrency"]) {
        MainCurrencyModel *model = selectedItem;
        return model.mValue ?: @"";
    }
    if ([fieldModel.name isEqualToString:@"defaultLocale"]) {
        DefaultLocaleModel *model = selectedItem;
        return model.mValue ?: @"";
    }
    if ([fieldModel.name isEqualToString:@"securityIssues"]) {
        SecurityIssuesModel *model = selectedItem;
        return model.mValue ?: @"";
    }
    return  textField.text ;
}

- (void)setRequiredJson:(NSArray<NSString *> *)requiredJson {
    for (NSString *obj in requiredJson) {
        if ([obj isEqualToString:fieldModel.name]) {
            if ([obj isEqualToString:@"username"]) {
                label_Title.text = @"用户名⭐️";
                textField.placeholder = @"用户名"; break ;
            }
            if ([obj isEqualToString:@"password"]) {
                label_Title.text = @"密码⭐️";
                textField.placeholder = @"6-20个字母数字或字符"; break ;
            }
            if ([obj isEqualToString:@"password2"]) {
                label_Title.text = @"验证密码⭐️";
                textField.placeholder = @"验证登录密码"; break ;
            }
            if ([obj isEqualToString:@"verificationCode"]) {
                label_Title.text = @"验证码⭐️";
                textField.placeholder = @"验证码"; break ;
            }
            if ([obj isEqualToString:@"regCode"]) {
                label_Title.text = @"推荐码⭐️";
                textField.placeholder = @"推荐码"; break ;
            }
            if ([obj isEqualToString:@"304"]) {
                label_Title.text = @"微信⭐️";
                textField.placeholder = @"微信"; break ;
            }
            if ([obj isEqualToString:@"110"]) {
                label_Title.text = @"手机号⭐️";
                textField.placeholder = @"手机号"; break ;
            }
            if ([obj isEqualToString:@"110verify"]) {
                label_Title.text = @"手机验证码⭐️";
                textField.placeholder = @"手机验证码"; break ;
            }
            if ([obj isEqualToString:@"201"]) {
                label_Title.text = @"邮箱⭐️";
                textField.placeholder = @"邮箱地址"; break ;
            }
            if ([obj isEqualToString:@"realName"]) {
                label_Title.text = @"真实姓名⭐️";
                textField.placeholder = @"真实姓名"; break ;
            }
            if ([obj isEqualToString:@"301"]) {
                label_Title.text = @"QQ号码⭐️";
                textField.placeholder = @"QQ号码"; break ;
            }
            if ([obj isEqualToString:@"paymentPassword"]) {
                label_Title.text = @"6位数字安全密码⭐️";
                textField.secureTextEntry = YES;
                textField.placeholder = @"6位数字安全密码"; break ;
            }
            if ([obj isEqualToString:@"paymentPassword2"]) {
                label_Title.text = @"验证6位数字安全密码";
                textField.secureTextEntry = YES;
                textField.placeholder = @"验证6位数字安全密码"; break ;
            }
            if ([obj isEqualToString:@"defaultTimezone"]) {
                label_Title.text = @"时区⭐️";
                textField.placeholder = @"";
                textField.enabled = NO; break ;
            }
            if ([obj isEqualToString:@"birthday"]) {
                label_Title.text = @"生日⭐️";
                textField.placeholder = @""; break ;
            }
            if ([obj isEqualToString:@"sex"]) {
                label_Title.text = @"性别⭐️";
                textField.placeholder = @"请选择性别"; break ;
            }
            if ([obj isEqualToString:@"mainCurrency"]) {
                label_Title.text = @"货币⭐️";
                textField.placeholder = @"人民币"; break ;
            }
            if ([obj isEqualToString:@"defaultLocale"]) {
                label_Title.text = @"主语言⭐️";
                textField.placeholder = @"简体中文"; break ;
            }
            if ([obj isEqualToString:@"securityIssues"]) {
                label_Title.text = @"请选择安全问题⭐️";
                textField.placeholder = @"请选择安全问题"; break ;
            }
            if ([obj isEqualToString:@"securityIssues2"]) {
                label_Title.text = @"回答安全问题⭐️";
                textField.placeholder = @"回答";break ;
            }
            if (textField.placeholder.length >0) {
                UIColor *color = [UIColor whiteColor];
                textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textField.placeholder attributes:@{NSForegroundColorAttributeName: color,NSFontAttributeName:[UIFont  systemFontOfSize:11]}];
            }
        }
        
    }
}

- (void)setFieldModel:(FieldModel *)model {
    fieldModel = model;
    if ([model.name isEqualToString:@"username"]) {
        label_Title.text = @"用户名";
        textField.placeholder = @"用户名";
    }
    if ([model.name isEqualToString:@"password"]) {
        label_Title.text = @"密码";
        textField.placeholder = @"6-20个字母数字或字符";
        [self setPasswordLayout];
    }
    if ([model.name isEqualToString:@"password2"]) {
        label_Title.text = @"验证密码⭐️";
        textField.placeholder = @"验证登录密码";
        [self setPasswordLayout];
    }
    if ([model.name isEqualToString:@"verificationCode"]) {
        label_Title.text = @"验证码";
        textField.placeholder = @"验证码";
        [self setVerifyCodeLayout];
    }
    if ([model.name isEqualToString:@"regCode"]) {
        label_Title.text = @"推荐码";
        textField.placeholder = @"推荐码";
    }
    if ([model.name isEqualToString:@"304"]) {
        label_Title.text = @"微信";
        textField.placeholder = @"微信";
    }
    if ([model.name isEqualToString:@"110"]) {
        label_Title.text = @"手机号";
        textField.placeholder = @"手机号";
    }
    if ([model.name isEqualToString:@"110verify"]) {
        label_Title.text = @"手机验证码";
        textField.placeholder = @"手机验证码";
        [self setPhoneVerifyCodeLayout];
    }
    
    if ([model.name isEqualToString:@"201"]) {
        label_Title.text = @"邮箱";
        textField.placeholder = @"邮箱地址";
    }
    if ([model.name isEqualToString:@"realName"]) {
        label_Title.text = @"真实姓名";
        textField.placeholder = @"真实姓名";
    }
    if ([model.name isEqualToString:@"301"]) {
        label_Title.text = @"QQ号码";
        textField.placeholder = @"QQ号码";
    }
    if ([model.name isEqualToString:@"paymentPassword"]) {
        label_Title.text = @"6位数字安全密码";
        textField.secureTextEntry = YES;
        textField.placeholder = @"6位数字安全密码";
    }
    if ([model.name isEqualToString:@"paymentPassword2"]) {
        label_Title.text = @"验证6位数字安全密码";
        label_Title.font = [UIFont systemFontOfSize:12];
        textField.secureTextEntry = YES;
        textField.placeholder = @"验证6位数字安全密码";
    }
    if ([model.name isEqualToString:@"defaultTimezone"]) {
        label_Title.text = @"时区";
        textField.placeholder = @"";
        textField.enabled = NO;
    }
    if ([model.name isEqualToString:@"birthday"]) {
        label_Title.text = @"生日";
        textField.placeholder = @"请选择生日";
        [self setBirthdaySelectLayout];
    }
    if ([model.name isEqualToString:@"sex"]) {
        label_Title.text = @"性别";
        textField.placeholder = @"请选择性别";
    }
    if ([model.name isEqualToString:@"mainCurrency"]) {
        label_Title.text = @"货币";
        textField.placeholder = @"人民币";
    }
    if ([model.name isEqualToString:@"defaultLocale"]) {
        label_Title.text = @"主语言";
        textField.placeholder = @"简体中文";
    }
    if ([model.name isEqualToString:@"securityIssues"]) {
        label_Title.text = @"请选择安全问题";
        textField.placeholder = @"请选择安全问题";
    }
    if ([model.name isEqualToString:@"securityIssues2"]) {
        label_Title.text = @"回答安全问题";
        textField.placeholder = @"回答";
    }
    if (textField.placeholder.length >0) {
        UIColor *color = [UIColor whiteColor];
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textField.placeholder attributes:@{NSForegroundColorAttributeName: color,NSFontAttributeName:[UIFont  systemFontOfSize:11]}];
    }
    
}

- (void)setTimeZone:(NSString *)zone {
    textField.text = zone;
}

- (void)setSexModel:(NSArray<SexModel *> *)models {
    sexModel = [NSArray array];
    sexModel = models;
    [self setSexSelectLayout];
    textField.enabled = NO;
}
- (void)setDefaultLocale:(NSArray<DefaultLocaleModel *> *)models {
    defaultLocaleModel = [NSArray array];
    defaultLocaleModel = models;
    [self setDefaultLocaleLayout];
    textField.enabled = NO;
}
- (void)setMainCurrencyModel:(NSArray<MainCurrencyModel *> *)models {
    mainCurrencyModel = [NSArray array];
    mainCurrencyModel = models;
    [self setMainCurrencyLayout];
    textField.enabled = NO;
}
- (void)setSecurityIssues:(NSArray<SecurityIssuesModel *> *)models {
    securityIssuesModel = [NSArray array];
    securityIssuesModel = models;
    [self setSecurityIssuesLayout];
    textField.enabled = NO;
}

- (void)setBirthDayMin:(NSInteger )start MaxDate:(NSInteger )end {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];//@"yyyy-MM-dd-HHMMss"
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:start/1000];
    minDateYear = date.year;
    
    date = [NSDate dateWithTimeIntervalSince1970:end/1000];
    maxDateYear = date.year;
    textField.enabled = NO;
}

- (void)setSexSelectLayout {
    UIButton *button = [UIButton new];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self->textField);
        make.right.mas_equalTo(-8);
        make.width.mas_equalTo(180);
        make.height.mas_equalTo(20);
    }];

    [button setImage:ImageWithName(@"arrow") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sexSelectDidTap) forControlEvents:UIControlEventTouchUpInside];
}

- (void)sexSelectDidTap {
    if (selectView.superview == nil) {
        selectView = [[RH_RegistrationSelectView alloc] init];
        selectView.delegate = self;
        [selectView setSelectViewType:@""];
        [selectView setColumNumbers:1];
        [selectView setDataList:sexModel];
          selectView.frame = CGRectMake(0, MainScreenH, MainScreenW, MainScreenH);
        [self.window addSubview:selectView];
        [UIView animateWithDuration:0.3 animations:^{
                self->selectView.frame = CGRectMake(0, 0, MainScreenW, MainScreenH);
        }];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            self->selectView.frame = CGRectMake(0, MainScreenH, MainScreenW, MainScreenH);
        }completion:^(BOOL finished) {
            [self->selectView removeFromSuperview];
        }];
    }
}

- (void)setMainCurrencyLayout {
    UIButton *button = [UIButton new];
    [self addSubview:button];
    [button  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self->textField);
        make.right.mas_equalTo(-8);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(20);
    }];

    [button setImage:ImageWithName(@"arrow") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(mainCurrencyDidTaped) forControlEvents:UIControlEventTouchUpInside];
}
- (void)mainCurrencyDidTaped {
    if (selectView.superview == nil) {
        selectView = [[RH_RegistrationSelectView alloc] init];
        selectView.delegate = self;
        [selectView setSelectViewType:@""];
        [selectView setColumNumbers:1];
        [selectView setDataList:mainCurrencyModel];
        selectView.frame = CGRectMake(0, MainScreenH, MainScreenW, MainScreenH);
        [self.window addSubview:selectView];
        [UIView animateWithDuration:0.3 animations:^{
            self->selectView.frame = CGRectMake(0, 0, MainScreenW, MainScreenH);
        }];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            self->selectView.frame = CGRectMake(0, MainScreenH, MainScreenW, MainScreenH);
        }completion:^(BOOL finished) {
            [self->selectView removeFromSuperview];
        }];
    }
}

- (void)setDefaultLocaleLayout {
    UIButton *button = [UIButton new];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self->textField);
        make.right.mas_equalTo(-8);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(20);
    }];
    [button setImage:ImageWithName(@"arrow") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(defaultLocaleDidTaped) forControlEvents:UIControlEventTouchUpInside];
}
- (void)defaultLocaleDidTaped {
    if (selectView.superview == nil) {
        selectView = [[RH_RegistrationSelectView alloc] init];
        selectView.delegate = self;
        [selectView setSelectViewType:@""];
        [selectView setColumNumbers:1];
        [selectView setDataList:defaultLocaleModel];
        selectView.frame = CGRectMake(0, MainScreenH, MainScreenW, MainScreenH);
        [self.window addSubview:selectView];
        [UIView animateWithDuration:0.3 animations:^{
            self->selectView.frame = CGRectMake(0, 0, MainScreenW, MainScreenH);
        }];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            self->selectView.frame = CGRectMake(0, MainScreenH, MainScreenW, MainScreenH);
        }completion:^(BOOL finished) {
            [self->selectView removeFromSuperview];
        }];
    }
}

- (void)setSecurityIssuesLayout {
    UIButton *button = [UIButton new];
    [self addSubview:button];
    [button  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self->textField);
        make.right.mas_equalTo(-8);
        make.width.mas_equalTo(180);
        make.height.mas_equalTo(20);
    }];

    [button setImage:ImageWithName(@"arrow") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(securityIssuesDidTaped) forControlEvents:UIControlEventTouchUpInside];
}
- (void)securityIssuesDidTaped {
    if (selectView.superview == nil) {
        selectView = [[RH_RegistrationSelectView alloc] init];
        selectView.delegate = self;
        [selectView setSelectViewType:@""];
        [selectView setColumNumbers:1];
        [selectView setDataList:securityIssuesModel];
        selectView.frame = CGRectMake(0, MainScreenH, MainScreenW, MainScreenH);
        [self.window addSubview:selectView];
        [UIView animateWithDuration:0.3 animations:^{
            self-> selectView.frame = CGRectMake(0, 0, MainScreenW, MainScreenH);
        }];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            self-> selectView.frame = CGRectMake(0, MainScreenH, MainScreenW, MainScreenH);
        }completion:^(BOOL finished) {
            [self->selectView removeFromSuperview];
        }];
    }
}
- (void)setBirthdaySelectLayout {
    UIButton *button = [UIButton new];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self->textField);
        make.right.mas_equalTo(-8);
        make.width.mas_equalTo(180);
        make.height.mas_equalTo(20);
    }];
    [button setImage:ImageWithName(@"arrow") forState:UIControlStateNormal];
    [button addTarget:self action:@selector(birthdaySelectTaped) forControlEvents:UIControlEventTouchUpInside];
}
- (void)birthdaySelectTaped {
    
    if (selectView.superview == nil) {
        selectView = [[RH_RegistrationSelectView alloc] init];
        selectView.delegate = self;
        [selectView setSelectViewType:@"birthday"];
        [selectView setColumNumbers:3];
        selectView.frame = CGRectMake(0, MainScreenH, MainScreenW, MainScreenH);
        [self.window addSubview:selectView];
        [UIView animateWithDuration:0.3 animations:^{
            self-> selectView.frame = CGRectMake(0, 0, MainScreenW, MainScreenH);
        }];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            self-> selectView.frame = CGRectMake(0, MainScreenH, MainScreenW, MainScreenH);
        }completion:^(BOOL finished) {
            [self->selectView removeFromSuperview];
        }];
    }
    
}

- (void)RH_RegistrationSelectViewDidCancelButtonTaped {
    [UIView animateWithDuration:0.3 animations:^{
        self-> selectView.frame = CGRectMake(0, MainScreenH, MainScreenW, MainScreenH);
    }completion:^(BOOL finished) {
        [self->selectView removeFromSuperview];
    }];
}
- (void)RH_RegistrationSelectViewDidConfirmButtonTapedwith:(NSString *)selected {
    textField.text = selected;
    [UIView animateWithDuration:0.3 animations:^{
        self->selectView.frame = CGRectMake(0, MainScreenH, MainScreenW, MainScreenH);
    }completion:^(BOOL finished) {
        [self->selectView removeFromSuperview];
    }];
}
- (void)RH_RegistrationSelectViewDidConfirmButtonTaped:(id)selected {
    selectedItem = selected;
    if ([fieldModel.name isEqualToString:@"sex"]) {
        SexModel *model = ConvertToClassPointer(SexModel, selected);
        textField.text = model.mText;
    }
    if ([fieldModel.name isEqualToString:@"mainCurrency"]) {
        MainCurrencyModel *model = ConvertToClassPointer(MainCurrencyModel, selected);
        textField.text = model.mText;
    }
    if ([fieldModel.name isEqualToString:@"defaultLocale"]) {
        DefaultLocaleModel *model = ConvertToClassPointer(DefaultLocaleModel, selected);
        textField.text = model.mText;
    }
    if ([fieldModel.name isEqualToString:@"securityIssues"]) {
        SecurityIssuesModel *model = ConvertToClassPointer(SecurityIssuesModel, selected);
        textField.text = model.mText;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self->selectView.frame = CGRectMake(0, MainScreenH, MainScreenW, MainScreenH);
    }completion:^(BOOL finished) {
        [self->selectView removeFromSuperview];
    }];
}

- (void)setPasswordLayout {
    button_Check = [UIButton new];
    [self addSubview:button_Check];
    [button_Check mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self->textField);
        make.right.mas_equalTo(-8);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(20);
    }];

    textField.secureTextEntry = YES;
    [button_Check setImage:ImageWithName(@"eyeclose") forState:UIControlStateNormal];
    [button_Check addTarget:self action:@selector(button_CheckHandle:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)button_CheckHandle:(UIButton *)button {
    if ([button isSelected]) {
        [button setSelected:NO];
        [button setImage:ImageWithName(@"eyeclose") forState:UIControlStateNormal];
        textField.secureTextEntry = YES;
    }else {
        [button setSelected:YES];
        [button setImage:ImageWithName(@"eye") forState:UIControlStateNormal];
        textField.secureTextEntry = NO;
    }
}

- (void)setVerifyCodeLayout {
    [textField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-56);//-110
    }];
    imageView_VerifyCode = [UIImageView new];
    [self addSubview:imageView_VerifyCode];
    [imageView_VerifyCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self->textField);
//        make.left.mas_equalTo(self->textField.mas_right).mas_offset(10);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(48);
    }];
    imageView_VerifyCode.layer.cornerRadius = 5;
    imageView_VerifyCode.layer.masksToBounds = YES;
    imageView_VerifyCode.backgroundColor = [UIColor orangeColor];
    [self startV3RegisetCaptchaCode];
    imageView_VerifyCode.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeImageView_VerfyCode)];
    [imageView_VerifyCode addGestureRecognizer:tap];
}
-(void)changeImageView_VerfyCode
{
    [self startV3RegisetCaptchaCode];
}
-(void)changeImageView_VerfyCode1
{
    [self startV3RegisetCaptchaCode];
}
-(void)startV3RegisetCaptchaCode{
    [SH_NetWorkService fetchV3RegisetCaptchaCode:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSData * data = ConvertToClassPointer(NSData, response);
        self->imageView_VerifyCode.image = [UIImage  imageWithData:data];
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        showMessage([UIApplication sharedApplication].keyWindow, err, nil);
        [self startV3RegisetCaptchaCode];
    }];
}
- (void)webViewTapHandle:(UITapGestureRecognizer *)tap {
    UIWebView *webView = (UIWebView *)tap.view;
    [webView reload];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)setPhoneVerifyCodeLayout {
    [textField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-110);//-150
    }];
    UIButton *button = [UIButton new];
    button.tag = 1002;
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self->textField);
        make.left.mas_equalTo(self->textField.mas_right).mas_offset(8);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(35);
    }];

    button.layer.borderColor = [UIColor whiteColor].CGColor;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.borderWidth = 1;
    button.layer.cornerRadius = 3;
    button.clipsToBounds = YES;
    [button setTitle:@"获取验证码" forState:UIControlStateNormal];
    [button setShowsTouchWhenHighlighted:YES];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(obtainVerifyTaped) forControlEvents:UIControlEventTouchUpInside];
}
- (void)obtainVerifyTaped {
   //WHC_StackView *stackView = (WHC_StackView *)self.superview;
    NSString *phone;
    for (RH_RegistrationViewItem *item in self.superview.subviews) {
        if ([item.contentType isEqualToString:@"110"]) {
            phone = item.textFieldContent;
        }
    }
    NSLog(@"%@", phone);
    if (phone.length != 11) {
        showMessage(self.window, @"请输入正确的手机号码", nil);
        return ;
    }
    [SH_NetWorkService  fetchMobileCodeWithPhoneNumber:phone complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSDictionary *dict = ConvertToClassPointer(NSDictionary, response);
        NSLog(@"%@", dict);
        if ([dict[@"success"] isEqual:@YES]) {
            showMessage(self.window, @"手机验证码已发送", @"");
              self->countDownNumber = 90;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startCountDown) userInfo:nil repeats:YES];
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                self->timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
                dispatch_source_set_timer(self->timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0.0 * NSEC_PER_SEC);
                NSTimeInterval seconds =self->countDownNumber;
                NSDate *endTime = [NSDate dateWithTimeIntervalSinceNow:seconds];//进入后台的时间
                dispatch_source_set_event_handler(self->timer, ^{
                    NSTimeInterval  intinterval = [endTime timeIntervalSinceNow];
                    NSString *str = [NSString stringWithFormat:@"%f",intinterval];
                    int time = [str intValue];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIButton *button = [self viewWithTag:1002];
                        if (time > 0) {
                            button.enabled = NO;
                            button.layer.borderColor =[UIColor  whiteColor].CGColor;// colorWithRGB(168, 168, 168).CGColor;
                            [button setTitle:[NSString stringWithFormat:@"%d",time] forState:UIControlStateNormal];
                            [button setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];//colorWithRGB(168, 168, 168)
                        }else {
                            dispatch_source_cancel(self->timer);
                            button.layer.borderColor = [UIColor  whiteColor].CGColor;// colorWithRGB(20, 90, 180).CGColor; //colorWithRGB(20, 90, 180)
                            [button setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
                            [button setTitle:@"获取验证码" forState:UIControlStateNormal];
                            button.enabled = YES;
                        }
                    });
                   
                });
            dispatch_resume(self->timer);

//            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                showMessage(self.window, @"发送失败", @"");
            });
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        showMessage(self.window, err, nil);
    }];
}
/*
- (void)startCountDown {
    NSLog(@"%s", __func__);
        countDownNumber--;
        UIButton *button = [self viewWithTag:1002];
        if (countDownNumber > 0) {
            button.enabled = NO;
            button.layer.borderColor =[UIColor  whiteColor].CGColor;// colorWithRGB(168, 168, 168).CGColor;
            [button setTitle:[NSString stringWithFormat:@"%lds",(long)countDownNumber] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];//colorWithRGB(168, 168, 168)
        }else {
            [self.timer invalidate];
            button.layer.borderColor = [UIColor  whiteColor].CGColor;// colorWithRGB(20, 90, 180).CGColor; //colorWithRGB(20, 90, 180)
            [button setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
            [button setTitle:@"获取验证码" forState:UIControlStateNormal];
            button.enabled = YES;
        }
}
*/
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self validateNumber:string];
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet *tmpSet = [NSCharacterSet characterSetWithCharactersInString:@""];;
    if ([fieldModel.name isEqualToString:@"username"]) {
        tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM!@#$_"];
    }
    if ([fieldModel.name isEqualToString:@"password"]) {
        tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM!@#$_"];
        if (textField.text.length + number.length > 20) {
            return NO;
        }
    }
    if ([fieldModel.name isEqualToString:@"password2"]) {
        tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM!@#$_"];
        if (textField.text.length + number.length > 20) {
            return NO;
        }
    }
    if ([fieldModel.name isEqualToString:@"verificationCode"]) {
        tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM"];
    }
    if ([fieldModel.name isEqualToString:@"304"]) {
        tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM_"];
    }
    if ([fieldModel.name isEqualToString:@"110"]) {
        tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        if (textField.text.length + number.length > 11) {
            return NO;
        }
    }
    if ([fieldModel.name isEqualToString:@"110verify"]) {
        tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    }
    if ([fieldModel.name isEqualToString:@"201"]) {
        tmpSet = [NSCharacterSet characterSetWithCharactersInString:@".0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM@_"];
    }
    if ([fieldModel.name isEqualToString:@"realName"]) {
        tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM!@#$_"];
        return YES;
    }
    if ([fieldModel.name isEqualToString:@"301"]) {
        tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    }
    if ([fieldModel.name isEqualToString:@"paymentPassword"]) {
        tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        if (textField.text.length + number.length > 6) {
            return NO;
        }
    }
    if ([fieldModel.name isEqualToString:@"paymentPassword2"]) {
        tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        if (textField.text.length + number.length > 6) {
            return NO;
        }
    }
    if ([fieldModel.name isEqualToString:@"regCode"]) {
        tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM"];
    }
    if ([fieldModel.name isEqualToString:@"securityIssues2"]) {
//        tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        return YES;
    }
//    tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM!@#$_"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"changeImageView_VerfyCode" object:self];
}
@end
