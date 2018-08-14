//
//  SH_ColorsJsonManager.h
//  GameBox
//
//  Created by shin on 2018/8/14.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SH_ColorsJsonManager : NSObject

+ (instancetype)sharedManager;

- (NSDictionary *)obj;

@end
