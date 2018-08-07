//
//  SH_SysMsgDataListModel.h
//  GameBox
//
//  Created by sam on 2018/7/14.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SH_SysMsgDataListModel : JSONModel

@property (strong, nonatomic) NSString <Optional> *content;
@property (assign, nonatomic) NSInteger id;
@property (strong, nonatomic) NSString <Optional> *link;
@property (assign, nonatomic) NSInteger publishTime;
@property (assign, nonatomic) BOOL read;
@property (strong, nonatomic) NSString <Optional> *searchId;
@property (strong, nonatomic) NSString <Optional> *title;

@property (assign, nonatomic) BOOL selected;

@end
