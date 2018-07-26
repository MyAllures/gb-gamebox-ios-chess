//
//  SH_SystemNotificationModel.h
//  GameBox
//
//  Created by sam on 2018/7/12.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "JSONModel.h"

@interface SH_SystemNotificationModel : JSONModel

@property (nonatomic, strong) NSString <Optional> *content;
@property (nonatomic, strong) NSString <Optional> *id;
@property (nonatomic, strong) NSString <Optional> *link;
@property (nonatomic, assign) NSInteger publishTime;
@property (nonatomic, assign) NSInteger read;
@property (nonatomic, strong) NSString <Optional> *searchId;
@property (nonatomic, strong) NSString <Optional> *title;

@end
