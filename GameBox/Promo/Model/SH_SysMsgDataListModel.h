//
//  SH_SysMsgDataListModel.h
//  GameBox
//
//  Created by sam on 2018/7/14.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SH_SysMsgDataListModel : JSONModel
@property (strong, readonly,nonatomic) NSString *content;
@property (assign, nonatomic) NSInteger id;
@property (strong, nonatomic) NSString *link;
@property (assign, nonatomic) NSInteger publishTime;
@property (assign, nonatomic) NSInteger read;
@property (assign, nonatomic) NSInteger searchId;
@property (strong, nonatomic) NSString *title;



@property(nonatomic,readonly,assign)  BOOL selectedFlag ;
-(void)updateSelectedFlag:(BOOL)bFlag ; //更新是否勾选状态
//@property (assign, nonatomic) NSInteger read;
//@property (strong, nonatomic) NSString *replyTitle;
@end
