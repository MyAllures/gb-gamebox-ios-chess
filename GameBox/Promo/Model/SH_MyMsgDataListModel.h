//
//  SH_MyMsgDataListModel.h
//  GameBox
//
//  Created by sam on 2018/7/16.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "JSONModel.h"

@interface SH_MyMsgDataListModel : JSONModel
@property (strong, nonatomic) NSString *advisoryContent;
@property (assign, nonatomic) NSInteger advisoryTime;
@property (strong, nonatomic) NSString *advisoryTitle;
@property (assign, nonatomic) NSInteger id;
@property (assign, nonatomic) NSInteger read;
//@property (strong, nonatomic) NSString *replyTitle;

@end
