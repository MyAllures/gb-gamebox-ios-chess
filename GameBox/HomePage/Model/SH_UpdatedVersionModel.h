//
//  SH_UpdatedVersionModel.h
//  GameBox
//
//  Created by shin on 2018/8/2.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel/JSONModel.h>

@interface SH_UpdatedVersionModel : JSONModel

@property (nonatomic, strong) NSString *appName;
@property (nonatomic, strong) NSString *appType;
@property (nonatomic, strong) NSString *appUrl;
@property (nonatomic, strong) NSString *boxType;
@property (nonatomic, assign) int forceVersion;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *md5;
@property (nonatomic, strong) NSString *memo;
@property (nonatomic, strong) NSString *siteId;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, assign) int versionCode;
@property (nonatomic, strong) NSString *versionName;

@end
