//
//  SH_SysMsgDetailModel.h
//  GameBox
//
//  Created by sam on 2018/7/19.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "JSONModel.h"

@interface SH_SysMsgDetailModel : JSONModel
@property (strong, nonatomic) NSString *content;
@property (assign, readonly ,nonatomic) NSInteger id;
@property (strong, readonly , nonatomic) NSString *link;
@property (assign, nonatomic) NSInteger publishTime;
@property (assign, nonatomic) NSInteger read;
@property (strong, readonly , nonatomic) NSString *searchId;
@property (strong, nonatomic) NSString *title;
@end
