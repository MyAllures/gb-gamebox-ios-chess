//
//  SH_GameBulletinModel.h
//  GameBox
//
//  Created by sam on 2018/7/12.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "JSONModel.h"

@interface SH_GameBulletinModel : JSONModel
@property (nonatomic, strong) NSString <Optional> *context;
@property (nonatomic, strong) NSString <Optional> *gameName;
@property (nonatomic, strong) NSString <Optional> *id;
@property (nonatomic, strong) NSString <Optional> *link;
@property (nonatomic, strong) NSString <Optional> *title;
@property (nonatomic, assign) NSInteger publishTime;

@end
