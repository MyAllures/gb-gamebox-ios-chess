//
//  SH_RegistView.m
//  GameBox
//
//  Created by Paul on 2018/7/11.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_RegistView.h"
#import "SH_NetWorkService+RegistAPI.h"
#import "RH_RegisetInitModel.h"
#import "RH_RegistrationViewItem.h"

@interface SH_RegistView()
{
    RH_RegisetInitModel *registrationInitModel;
    BOOL isAgreedServiceTerm;
}

@property(nonatomic,strong)UIScrollView * scrollview;
@property(nonatomic,strong,readonly)UIView *stackView;
@property(nonatomic,strong) NSArray * temp;
@end
@implementation SH_RegistView
@synthesize stackView = _stackView;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)init{
    if (self = [super init]) {
        [self startV3RegisetInit];
        isAgreedServiceTerm = YES;
    }
    return  self;
}

-(void)startV3RegisetInit{
    [SH_NetWorkService  fetchV3RegisetInit:^(NSHTTPURLResponse *httpURLResponse, id response) {
        NSLog(@"%@",response);
        self->registrationInitModel =ConvertToClassPointer(RH_RegisetInitModel, response);
        [self configUI];
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
         NSLog(@"%@",err);
    }];
    
}
#pragma mark -- 配置UI
-(void)configUI{
    [self.scrollview  addSubview: self.stackView];
    [self.stackView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scrollview.mas_top).mas_offset(8);
        make.leading.mas_equalTo(self.scrollview.mas_leading).mas_offset(8);
        make.centerX.mas_equalTo(self.scrollview.mas_centerX).mas_offset(0);
        make.height.mas_equalTo( 600);
    }];
    
    NSMutableArray * temp = [NSMutableArray  array];
    for (FieldModel *field in registrationInitModel.field) {
        if ([field.name isEqualToString:@"regCode"]) {
            RH_RegistrationViewItem *item = [[RH_RegistrationViewItem alloc] init];
            [item setFieldModel:field];
            [item setRequiredJson:registrationInitModel.requiredJson];
            [self.stackView addSubview:item];
            [temp addObject:item];
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                if (temp.count==1) {
                    make.top.leading.mas_equalTo(self.stackView);
                }else{
                    make.leading.mas_equalTo(self.stackView);
                    RH_RegistrationViewItem * obj = temp[temp.count-2];
                    make.top.mas_equalTo(obj.mas_bottom).mas_offset(0);
                }
                make.trailing.mas_equalTo(self.stackView);
                make.height.mas_equalTo(60);
            }];
        }
     }

    for (FieldModel *field in registrationInitModel.field) {
        if ([field.name isEqualToString:@"regCode"]) {
            continue;
        }
        if ([field.name isEqualToString:@"serviceTerms"]) {
            continue;
        }
        if ([field.name isEqualToString:@"verificationCode"]) {
            continue ;
        }
        RH_RegistrationViewItem *item = [[RH_RegistrationViewItem alloc] init];
        [item setFieldModel:field];
        if ([field.name isEqualToString:@"defaultTimezone"]) {
            [item setTimeZone:registrationInitModel.params.timezone];
        }
        if ([field.name isEqualToString:@"birthday"]) {
            [item setBirthDayMin:registrationInitModel.params.minDate MaxDate:registrationInitModel.params.maxDate];
        }
        if ([field.name isEqualToString:@"sex"]) {
            [item setSexModel:registrationInitModel.selectOption.sex];
        }
        if ([field.name isEqualToString:@"mainCurrency"]) {
            [item setMainCurrencyModel:registrationInitModel.selectOption.mainCurrencyModel];
        }
        if ([field.name isEqualToString:@"defaultLocale"]) {
            [item setDefaultLocale:registrationInitModel.selectOption.defaultLocaleModel];
        }
        if ([field.name isEqualToString:@"securityIssues"]) {
            [item setSecurityIssues:registrationInitModel.selectOption.securityIssuesModel];
        }
        [self.stackView addSubview:item];
        [temp addObject:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            if (temp.count==1) {
                make.top.leading.mas_equalTo(self.stackView);
            }else{
                make.leading.mas_equalTo(self.stackView);
                RH_RegistrationViewItem * obj = temp[temp.count-2];
                make.top.mas_equalTo(obj.mas_bottom).mas_offset(0);
            }
            make.trailing.mas_equalTo(self.stackView);
            make.height.mas_equalTo(60);
        }];
        
        if ([field.name isEqualToString:@"password"]) {
            RH_RegistrationViewItem *item = [[RH_RegistrationViewItem alloc] init];
            FieldModel *field = [[FieldModel alloc] init];
            field.name = @"password2";
            [item setFieldModel:field];
            [self.stackView addSubview:item];
            [temp addObject:item];
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                if (temp.count==1) {
                    make.top.leading.mas_equalTo(self.stackView);
                }else{
                    make.leading.mas_equalTo(self.stackView);
                    RH_RegistrationViewItem * obj = temp[temp.count-2];
                    make.top.mas_equalTo(obj.mas_bottom).mas_offset(0);
                }
                make.trailing.mas_equalTo(self.stackView);
                make.height.mas_equalTo(60);
            }];
        }
        if (registrationInitModel.isPhone) {
            if ([field.name isEqualToString:@"110"]) {
                RH_RegistrationViewItem *item = [[RH_RegistrationViewItem alloc] init];
                FieldModel *field = [[FieldModel alloc] init];
                field.name = @"110verify";
                [item setFieldModel:field];
                [self.stackView addSubview:item];
                [temp addObject:item];
                [item mas_makeConstraints:^(MASConstraintMaker *make) {
                    if (temp.count==1) {
                        make.top.leading.mas_equalTo(self.stackView);
                    }else{
                        make.leading.mas_equalTo(self.stackView);
                        RH_RegistrationViewItem * obj = temp[temp.count-2];
                        make.top.mas_equalTo(obj.mas_bottom).mas_offset(0);
                    }
                    make.trailing.mas_equalTo(self.stackView);
                    make.height.mas_equalTo(60);
                }];
            }
        }
        if ([field.name isEqualToString:@"paymentPassword"]) {
            RH_RegistrationViewItem *item = [[RH_RegistrationViewItem alloc] init];
            FieldModel *field = [[FieldModel alloc] init];
            field.name = @"paymentPassword2";
            [item setFieldModel:field];
            [self.stackView addSubview:item];
            [temp addObject:item];
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                if (temp.count==1) {
                    make.top.leading.mas_equalTo(self.stackView);
                }else{
                    make.leading.mas_equalTo(self.stackView);
                    RH_RegistrationViewItem * obj = temp[temp.count-2];
                    make.top.mas_equalTo(obj.mas_bottom).mas_offset(0);
                }
                make.trailing.mas_equalTo(self.stackView);
                make.height.mas_equalTo(60);
            }];
        }
        if ([field.name isEqualToString:@"securityIssues"]) {
            RH_RegistrationViewItem *item = [[RH_RegistrationViewItem alloc] init];
            FieldModel *field = [[FieldModel alloc] init];
            field.name = @"securityIssues2";
            [item setFieldModel:field];
            [self.stackView addSubview:item];
            [temp addObject:item];
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                if (temp.count==1) {
                    make.top.leading.mas_equalTo(self.stackView);
                }else{
                    make.leading.mas_equalTo(self.stackView);
                    RH_RegistrationViewItem * obj = temp[temp.count-2];
                    make.top.mas_equalTo(obj.mas_bottom).mas_offset(0);
                }
                make.trailing.mas_equalTo(self.stackView);
                make.height.mas_equalTo(60);
            }];
        }
        [item setRequiredJson:registrationInitModel.requiredJson];
    }
    for (FieldModel *f in registrationInitModel.field) {
        if ([f.name isEqualToString:@"verificationCode"]) {
            RH_RegistrationViewItem *item = [[RH_RegistrationViewItem alloc] init];
            FieldModel *field = [[FieldModel alloc] init];
            field.name = @"verificationCode";
            [item setFieldModel:field];
            [self.stackView addSubview:item];
            [item setRequiredJson:registrationInitModel.requiredJson];
            [temp addObject:item];
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                if (temp.count==1) {
                    make.top.leading.mas_equalTo(self.stackView);
                }else{
                    make.leading.mas_equalTo(self.stackView);
                    RH_RegistrationViewItem * obj = temp[temp.count-2];
                    make.top.mas_equalTo(obj.mas_bottom).mas_offset(0);
                }
                make.trailing.mas_equalTo(self.stackView);
                make.height.mas_equalTo(60);
            }];
        }
    }
    [self.stackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(temp.count*60);
    }];
    [self layoutIfNeeded];
//    self.temp = temp;
    RH_RegistrationViewItem * obj = [RH_RegistrationViewItem  new];
    [obj  setSubViewArray:temp];
    self.scrollview.contentSize = CGSizeMake(self.frameWidth, temp.count*60+150);
    [self setupBottomView];
}

- (void)setupBottomView {
    UIButton *button_Check = [UIButton new];
    button_Check.tag = 1023;
    [self.scrollview addSubview:button_Check];
    [button_Check mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.stackView.mas_bottom).mas_offset(20);
        make.leading.mas_equalTo(8);
        make.width.height.mas_equalTo(25);
    }];
    
    [button_Check setSelected:YES];
    [button_Check setImage:ImageWithName(@"choose") forState:UIControlStateNormal];
    [button_Check addTarget:self action:@selector(button_CheckHandle:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *label = [UIButton new];
    [self.scrollview addSubview:label];
    [label  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(button_Check.mas_trailing).mas_offset(10);
        make.centerY.mas_equalTo(button_Check);
        
    }];

    label.titleLabel.font = [UIFont systemFontOfSize:15];
    [label setTitleColor:colorWithRGB(168, 168, 168) forState:UIControlStateNormal]; ;
    [label setTitle:@"注册条款" forState:UIControlStateNormal];
    [label addTarget:self action:@selector(zhucetiaokuan) forControlEvents:UIControlEventTouchUpInside];
    UIButton *button = [UIButton new];
    [self.scrollview addSubview:button];
    [button  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(button_Check.mas_bottom).mas_offset(20);
        make.centerX.mas_equalTo(self.scrollview);
        make.leading.mas_equalTo(button_Check);
        make.height.mas_equalTo(44);
    }];
    
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    [button setTitle:@"立即注册" forState:UIControlStateNormal];
    [button setBackgroundColor:colorWithRGB(20, 90, 180)];
    [button addTarget:self action:@selector(buttonRegistrationHandle) forControlEvents:UIControlEventTouchUpInside];
}

- (void)button_CheckHandle:(UIButton *)button {
    
    if ([button isSelected]) {
        [button setSelected:NO];
        [button setImage:ImageWithName(@"not-choose") forState:UIControlStateNormal];
        isAgreedServiceTerm = NO;
    }else {
        [button setSelected:YES];
        [button setImage:ImageWithName(@"choose") forState:UIControlStateNormal];
        isAgreedServiceTerm = YES;
    }
}

- (void)zhucetiaokuan {
//    [self showViewController:[RH_RegisterClauseViewController viewController] sender:nil];
}
- (NSString *)obtainContent:(NSString *)name {
    for (RH_RegistrationViewItem *item in self.stackView.subviews) {
        if ([item.contentType isEqualToString:name]) {
            NSString *content  = [item textFieldContent];
            return content;
        }
    }
    return @"";
}
- (void)buttonRegistrationHandle {
    UIWindow * window = [UIApplication  sharedApplication].keyWindow;
    NSString *regCode = [self obtainContent:@"regCode"];
    for (NSString *obj in registrationInitModel.requiredJson) {
        if ([obj isEqualToString:@"regCode"]) {
            if (registrationInitModel.isRequiredForRegisterCode) {
                if (regCode.length == 0) {
                    showMessage(window, @"请输入邀请码", @"");
                    return ;
                }
            }
        }
    }
    
    NSString *usernama = [self obtainContent:@"username"];
    if (usernama.length == 0) {
        showMessage(window, @"请输入用户名", @"");
        return;
    }
    NSString *password = [self obtainContent:@"password"];
    if (password.length == 0) {
        showMessage(window, @"请输入密码", @"");
        return;
    }
    NSString *password2 = [self obtainContent:@"password2"];
    if (password2.length == 0) {
        showMessage(window, @"请再次输入密码", @"");
        return;
    }
    if (![password isEqualToString:password2]) {
        showMessage(window, @"两次输入的密码不一样", @"");
        return;
    }
    
    NSString *weixin = [self obtainContent:@"304"];
    
    NSString *phone = [self obtainContent:@"110"];
    
    NSString *phoneVerify = [self obtainContent:@"110verify"];
    
    NSString *email = [self obtainContent:@"201"];
    
    NSString *realname = [self obtainContent:@"realName"];
    
    NSString *qq = [self obtainContent:@"301"];
    
    NSString *permission = [self obtainContent:@"paymentPassword"];
    
    NSString *permission2 = [self obtainContent:@"paymentPassword2"];
    
    NSString *timezone = [self obtainContent:@"defaultTimezone"];
    
    NSString *birthday = [self obtainContent:@"birthday"];
    
    NSString *sex = [self obtainContent:@"sex"];
    
    NSString *mainCurrency = [self obtainContent:@"mainCurrency"];
    
    NSString *defaultLocale = [self obtainContent:@"defaultLocale"];
    
    NSString *securityIssues = [self obtainContent:@"securityIssues"];
    NSString *securityIssues2 = [self obtainContent:@"securityIssues2"];
    
    for (NSString *obj in registrationInitModel.requiredJson) {
        if ([obj isEqualToString:@"304"]) {
            if (weixin.length == 0) {
                showMessage(window, @"请输入与微信号", @"");
                return;}
        }
        if ([obj isEqualToString:@"110"]) {
            if (phone.length == 0) {
                showMessage(window, @"请输入手机号", @"");
                return;}
            if (registrationInitModel.isPhone) {
                if (phoneVerify.length == 0) {
                    showMessage(window, @"请输入手机验证码", @"");
                    return;
                }
            }
        }
        if ([obj isEqualToString:@"201"]) {
            if (email.length == 0) {
                showMessage(window, @"请输入邮箱", @"");
                return;}
        }
        if ([obj isEqualToString:@"realName"]) {
            if (realname.length == 0) {
                showMessage(window, @"请输入真实姓名", @"");
                return;}
        }
        if ([obj isEqualToString:@"301"]) {
            if (qq.length == 0) {
                showMessage(window, @"请输入QQ号", @"");
                return;}
        }
        if ([obj isEqualToString:@"paymentPassword"]) {
            if (permission.length == 0) {
                showMessage(window, @"请输入安全密码", @"");
                return;}
            if (permission2.length == 0) {
                showMessage(window, @"请再次输入安全密码", @"");
                return;}
            if (![permission2 isEqualToString:permission]) {
                showMessage(window, @"两次输入的安全密码不一样", @"");
                return;
            }
        }
        
        if ([obj isEqualToString:@"defaultTimezone"]) {
            if (timezone.length == 0) {
                showMessage(window, @"请选择时区", @"");
                return;}
        }
        if ([obj isEqualToString:@"birthday"]) {
            if (birthday.length == 0) {
                showMessage(window, @"请选择生日", @"");
                return;}
        }
        if ([obj isEqualToString:@"sex"]) {
            if (sex.length == 0) {
                showMessage(window, @"请选择性别", @"");
                return;}
        }
        if ([obj isEqualToString:@"mainCurrency"]) {
            if (mainCurrency.length == 0) {
                showMessage(window,@"请选择货币", @"");
                return;}
        }
        if ([obj isEqualToString:@"defaultLocale"]) {
            if (defaultLocale.length == 0) {
                showMessage(window, @"请选择语言", @"");
                return;}
        }
        if ([obj isEqualToString:@"securityIssues"]) {
            if (securityIssues.length == 0) {
                showMessage(window, @"请选择安全问题", @"");
                return;}
            //            if ([obj isEqualToString:@"securityIssues2"]) {
            if (securityIssues2.length == 0) {
                showMessage(window, @"请回答安全问题", @"");
                return;}
            //            }
        }
        
    }
    NSString *verificationCode = [self obtainContent:@"verificationCode"];
    if (verificationCode.length == 0) {
        showMessage(window, @"请输入验证码", @"");
        return;}
    if (isAgreedServiceTerm == NO) {
        showMessage(window, @"请同意注册条款", nil);
        return ;
    }
   /* NSString *registcode = registrationInitModel.paramsModel.registCode ?: @"";
    [self showProgressIndicatorViewWithAnimated:YES title:@"正在注册..."];
    [self.serviceRequest startV3RegisetSubmitWithBirthday:[NSString stringWithFormat:@"%@",birthday] sex:sex permissionPwd:permission defaultTimezone:timezone defaultLocale:defaultLocale phonecontactValue:phone realName:realname defaultCurrency:mainCurrency password:password question1:securityIssues emailValue:email qqValue:qq weixinValue:weixin userName:usernama captchaCode:verificationCode recommendRegisterCode:registcode editType:@"" recommendUserInputCode:regCode confirmPassword:password2 confirmPermissionPwd:permission2 answer1:securityIssues2 termsOfService:@"11" requiredJson:registrationInitModel.requiredJson phoneCode:phoneVerify checkPhone:@"checkPhone"];*/
    
}

#pragma mark --  create scrollView
-(UIScrollView *)scrollview{
    if (!_scrollview) {
        _scrollview = [UIScrollView new];
        [self addSubview:_scrollview];
        [_scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        _scrollview.backgroundColor = [UIColor whiteColor];
        _scrollview.alwaysBounceVertical = YES;
        _scrollview.scrollEnabled = YES;
        _scrollview.showsVerticalScrollIndicator = YES;
        _scrollview.showsHorizontalScrollIndicator = false;
        _scrollview.contentSize = CGSizeMake(self.frameWidth, self.frameHeigh + 200);
    }
    return  _scrollview;
}
-(UIView *)stackView{
    if (!_stackView) {
        _stackView = [UIView  new];
    }
    return  _stackView;
}
-(NSArray *)temp{
    if (!_temp) {
        _temp = [NSArray array];
    }
    return  _temp;
}
@end
