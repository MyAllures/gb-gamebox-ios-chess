//
//  RH_RegisetInitModel.h
//  gameBoxEx
//
//  Created by Richard on 2018/3/23.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface IpLocaleModel :JSONModel
@property (nonatomic , copy ) NSString              * region;
@property (nonatomic , copy ) NSString              * country;
@property (nonatomic , copy ) NSString              * city;

@end

@interface ParamsModel :JSONModel
@property (nonatomic , assign ) NSInteger              minDate;
@property (nonatomic , strong ) IpLocaleModel          * ipLocale;
@property (nonatomic , copy ) NSString              * timezone;
@property (nonatomic , copy ) NSString              * registCode;
@property (nonatomic , copy ) NSString              * currency;
@property (nonatomic , assign ) NSInteger              maxDate;

@end

@interface SignUpDataMapModel :JSONModel
@property (nonatomic , copy ) NSString              * realName;
@property (nonatomic , copy ) NSString              * sex;
@property (nonatomic , copy ) NSString              * m110;
@property (nonatomic , copy ) NSString              * defaultLocale;
@property (nonatomic , copy ) NSString              * m201;
@property (nonatomic , copy ) NSString              * paymentPassword;
@property (nonatomic , copy ) NSString              * birthday;
@property (nonatomic , copy ) NSString              * defaultTimezone;
@property (nonatomic , copy ) NSString              * password;
@property (nonatomic , copy ) NSString              * mainCurrency;
@property (nonatomic , copy ) NSString              * securityIssues;
@property (nonatomic , copy ) NSString              * m301;
@property (nonatomic , copy ) NSString              * username;
@property (nonatomic , copy ) NSString              * m304;

@end

@protocol  FieldModel;
@interface FieldModel :JSONModel
@property (nonatomic , copy )NSString              * isRequired;
@property (nonatomic , copy ) NSString              * status;
@property (nonatomic , copy ) NSString              * isRegField;
@property (nonatomic , assign ) NSInteger              mId;
@property (nonatomic , assign ,readonly) NSInteger              sort;
@property (nonatomic , assign ,readonly) BOOL              derail;
@property (nonatomic , assign ) BOOL              bulitIn;
@property (nonatomic , copy ) NSString              * isOnly;
@property (nonatomic , copy ) NSString              * i18nName;
@property (nonatomic , copy ) NSString              * name;

@end

@protocol SexModel ;
@interface SexModel :JSONModel
@property (nonatomic , copy ) NSString              * mValue;
@property (nonatomic , copy ) NSString              * mText;

@end

@protocol  DefaultLocaleModel;
@interface DefaultLocaleModel :JSONModel
@property (nonatomic , copy ) NSString              * mValue;
@property (nonatomic , copy ) NSString              * mText;

@end

@protocol  MainCurrencyModel;
@interface MainCurrencyModel :JSONModel
@property (nonatomic , copy ) NSString              * mValue;
@property (nonatomic , copy ) NSString              * mText;

@end

@protocol  SecurityIssuesModel;
@interface SecurityIssuesModel :JSONModel
@property (nonatomic , copy ) NSString              * mValue;
@property (nonatomic , copy ) NSString              * mText;

@end


@interface SelectOptionModel :JSONModel

@property (nonatomic , strong )  NSArray<Optional, SexModel >              * sex;
@property (nonatomic , strong )  NSArray<Optional,DefaultLocaleModel>      * defaultLocale;
@property (nonatomic , strong )  NSArray<Optional,MainCurrencyModel >      * mainCurrency;
@property (nonatomic , strong )  NSArray<Optional,SecurityIssuesModel >    * securityIssues;

@end

@class  ParamsModel;
@interface RH_RegisetInitModel :JSONModel

@property (nonatomic , strong ) ParamsModel              * params;
@property (nonatomic , strong ) SignUpDataMapModel              * signUpDataMap;
@property (nonatomic , strong ) NSArray<Optional>              * requiredJson;
@property (nonatomic , strong ) NSArray<Optional,FieldModel >              * field;
@property (nonatomic , assign ) BOOL              isPhone;
@property (nonatomic , assign ) BOOL              isRequiredForRegisterCode;
@property (nonatomic , assign ) BOOL              isEmail;
@property (nonatomic , strong ) SelectOptionModel              * selectOption;
@property (nonatomic , assign ) BOOL              registCodeField;

@end
