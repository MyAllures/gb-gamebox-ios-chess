//
//  RH_RegisetInitModel.h
//  gameBoxEx
//
//  Created by Richard on 2018/3/23.
//  Copyright © 2018年 luis. All rights reserved.
//

//#import "RH_BasicModel.h"

@interface IpLocaleModel :JSONModel
@property (nonatomic , strong , readonly) NSString              * region;
@property (nonatomic , strong , readonly) NSString              * country;
@property (nonatomic , strong , readonly) NSString              * city;

@end

@interface ParamsModel :JSONModel
@property (nonatomic , assign ,readonly) NSInteger              minDate;
@property (nonatomic , strong ,readonly) IpLocaleModel          * ipLocaleModel;
@property (nonatomic , strong , readonly) NSString              * timezone;
@property (nonatomic , strong , readonly) NSString              * registCode;
@property (nonatomic , strong , readonly) NSString              * currency;
@property (nonatomic , assign , readonly) NSInteger              maxDate;

@end

@interface SignUpDataMapModel :JSONModel
@property (nonatomic , strong , readonly) NSString              * realName;
@property (nonatomic , strong , readonly) NSString              * sex;
@property (nonatomic , strong , readonly) NSString              * m110;
@property (nonatomic , strong , readonly) NSString              * defaultLocale;
@property (nonatomic , strong , readonly) NSString              * m201;
@property (nonatomic , strong , readonly) NSString              * paymentPassword;
@property (nonatomic , strong , readonly) NSString              * birthday;
@property (nonatomic , strong , readonly) NSString              * defaultTimezone;
@property (nonatomic , strong , readonly) NSString              * password;
@property (nonatomic , strong , readonly) NSString              * mainCurrency;
@property (nonatomic , strong , readonly) NSString              * securityIssues;
@property (nonatomic , strong , readonly) NSString              * m301;
@property (nonatomic , strong , readonly) NSString              * username;
@property (nonatomic , strong , readonly) NSString              * m304;

@end

@interface FieldModel :JSONModel
@property (nonatomic , strong , readonly)NSString              * isRequired;
@property (nonatomic , strong , readonly) NSString              * status;
@property (nonatomic , strong , readonly) NSString              * isRegField;
@property (nonatomic , assign , readonly) NSInteger              mId;
@property (nonatomic , assign ,readonly) NSInteger              sort;
@property (nonatomic , assign ,readonly) BOOL              derail;
@property (nonatomic , assign , readonly) BOOL              bulitIn;
@property (nonatomic , strong , readonly) NSString              * isOnly;
@property (nonatomic , strong , readonly) NSString              * i18nName;
@property (nonatomic , strong ) NSString              * name;

@end

@interface SexModel :JSONModel
@property (nonatomic , strong , readonly) NSString              * mValue;
@property (nonatomic , strong , readonly) NSString              * mText;

@end

@interface DefaultLocaleModel :JSONModel
@property (nonatomic , strong , readonly) NSString              * mValue;
@property (nonatomic , strong , readonly) NSString              * mText;

@end

@interface MainCurrencyModel :JSONModel
@property (nonatomic , strong , readonly) NSString              * mValue;
@property (nonatomic , strong , readonly) NSString              * mText;

@end

@interface SecurityIssuesModel :JSONModel
@property (nonatomic , strong , readonly) NSString              * mValue;
@property (nonatomic , strong , readonly) NSString              * mText;

@end

@interface SelectOptionModel :JSONModel

@property (nonatomic , strong , readonly)  NSArray<SexModel *>              * sexModel;
@property (nonatomic , strong , readonly)  NSArray<DefaultLocaleModel *>          * defaultLocaleModel;
@property (nonatomic , strong , readonly)  NSArray<MainCurrencyModel *>              * mainCurrencyModel;
@property (nonatomic , strong , readonly)  NSArray<SecurityIssuesModel *>              * securityIssuesModel;

@end

@interface RH_RegisetInitModel :JSONModel

@property (nonatomic , strong , readonly) ParamsModel              * paramsModel;
@property (nonatomic , strong , readonly) SignUpDataMapModel              * signUpDataMapModel;
@property (nonatomic , strong , readonly) NSArray<NSString *>              * requiredJson;
@property (nonatomic , strong , readonly) NSArray<FieldModel *>              * fieldModel;
@property (nonatomic , assign , readonly) BOOL              isPhone;
@property (nonatomic , assign , readonly) BOOL              isRequiredForRegisterCode;
@property (nonatomic , assign , readonly) BOOL              isEmail;
@property (nonatomic , strong , readonly) SelectOptionModel              * selectOptionModel;
@property (nonatomic , assign , readonly) BOOL              registCodeField;

@end
