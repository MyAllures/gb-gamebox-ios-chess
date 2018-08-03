//
//  SH_HttpErrManager.h
//  GameBox
//
//  Created by shin on 2018/7/31.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SH_HttpErrManagerFetchTargetVCComplete)(UIViewController *vc);

@interface SH_HttpErrManager : NSObject

+ (void)dealWithErrCode:(int)code;

@end
