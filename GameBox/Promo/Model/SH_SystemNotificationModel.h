//
//  SH_SystemNotificationModel.h
//  GameBox
//
//  Created by sam on 2018/7/12.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "JSONModel.h"

@interface SH_SystemNotificationModel : JSONModel
@property (nonatomic, strong) NSString *content;
//@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *searchId;
//@property (nonatomic, strong) NSString *title;

@property (nonatomic, assign) NSInteger publishTime;
//@property (nonatomic, assign) NSInteger read;
@end
