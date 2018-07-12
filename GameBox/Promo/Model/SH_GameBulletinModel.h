//
//  SH_GameBulletinModel.h
//  GameBox
//
//  Created by sam on 2018/7/12.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "JSONModel.h"

@interface SH_GameBulletinModel : JSONModel
@property (nonatomic, strong) NSString *context;
@property (nonatomic, strong) NSString *gameName;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *title;

@property (nonatomic, assign) NSInteger publishTime;
@end
