//
//  RH_RegistrationViewItem.h
//  gameBoxEx
//
//  Created by Lenny on 2018/3/23.
//  Copyright © 2018年 luis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RH_RegisetInitModel.h"
@interface RH_RegistrationViewItem : UIView

- (void)setRequiredJson:(NSArray<NSString *> *)requiredJson;
- (void)setFieldModel:(FieldModel *)model;
- (void)setTimeZone:(NSString *)zone;
- (void)setBirthDayMin:(NSInteger )start MaxDate:(NSInteger )end;
- (void)setSexModel:(NSArray<SexModel *> *)models;
- (void)setMainCurrencyModel:(NSArray<MainCurrencyModel *> *)models;
- (void)setDefaultLocale:(NSArray<DefaultLocaleModel *> *)models;
- (void)setSecurityIssues:(NSArray<SecurityIssuesModel *> *)models;

- (NSString *)contentType;

- (BOOL)isRequire;

- (NSString *)textFieldContent;
@end
