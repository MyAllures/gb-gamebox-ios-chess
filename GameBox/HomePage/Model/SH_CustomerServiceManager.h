//
//  SH_CustomerServiceManager.h
//  GameBox
//
//  Created by shin on 2018/7/31.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SH_CustomerServiceFetchSuccess)(NSString *url);
typedef void(^SH_CustomerServiceFetchFailed)();

@interface SH_CustomerServiceManager : NSObject

+ (instancetype)sharedManager;

- (void)open;
@end
