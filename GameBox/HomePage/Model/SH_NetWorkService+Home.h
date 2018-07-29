//
//  SH_NetWorkService+Home.h
//  GameBox
//
//  Created by shin on 2018/7/12.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_NetWorkService.h"

@interface SH_NetWorkService (Home)

+ (void)fetchHomeInfo:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed;

+ (void)fetchGameLink:(NSString *)link complete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed;

+ (void)fetchAnnouncement:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed;

+(void)onekeyrecoveryApiId:(NSString *)apiId
                   Success:(SHNetWorkComplete)success
                      failed:(SHNetWorkFailed)failed;

+ (void)fetchTimeZone:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed;

+ (void)refreshUserSessin:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed;

@end
