//
//  SH_RingManager.h
//  GameBox
//
//  Created by shin on 2018/7/12.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SH_RingManager : NSObject

+ (instancetype)sharedManager;

- (void)playBGM;
- (void)pauseBGM;
- (void)playMoneyRing;
- (void)playAlertRing;
- (void)playErrRing;

@end
