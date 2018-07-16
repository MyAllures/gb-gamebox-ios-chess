//
//  SH_GameItemModel.h
//  GameBox
//
//  Created by shin on 2018/7/13.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol SH_GameItemModel;

@interface SH_GameItemModel : JSONModel

@property (nonatomic, assign) int autoPay;
@property (nonatomic, strong) NSString <Optional> *apiId;
@property (nonatomic, strong) NSString <Optional> *apiTypeId;
@property (nonatomic, strong) NSString <Optional> *cover;
@property (nonatomic, strong) NSString <Optional> *gameLink;
@property (nonatomic, strong) NSString <Optional> *gameMsg;
@property (nonatomic, strong) NSString <Optional> *name;
@property (nonatomic, strong) NSString <Optional> *type;
@property (nonatomic, strong) NSArray <Optional, SH_GameItemModel> *relation;

@end
