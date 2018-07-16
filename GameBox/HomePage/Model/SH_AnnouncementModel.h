//
//  SH_AnnouncementModel.h
//  GameBox
//
//  Created by shin on 2018/7/16.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <JSONModel/JSONModel.h>
@interface SH_AnnouncementModel : JSONModel

@property (nonatomic, assign) int announcementType;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *countdown;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, assign) NSInteger createUser;
@property (nonatomic, assign) int display;
@property (nonatomic, assign) int id;
@property (nonatomic, assign) NSInteger isTask;
@property (nonatomic, strong) NSString *language;
@property (nonatomic, strong) NSString *orderNum;
@property (nonatomic, assign) NSInteger publishTime;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger updateTime;
@property (nonatomic, assign) NSInteger updateUser;
@end
