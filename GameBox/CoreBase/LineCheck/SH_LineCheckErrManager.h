//
//  SH_LineCheckErrManager.h
//  GameBox
//
//  Created by shin on 2018/8/7.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SH_LineCheckErrManager : NSObject

+ (instancetype)sharedManager;

//收集错误信息
- (void)collectErrInfo:(NSDictionary *)errInfo;
//发送错误信息
- (void)send;
@end
