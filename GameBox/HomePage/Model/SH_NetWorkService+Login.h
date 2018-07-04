//
//  SH_NetWorkService+Login.h
//  GameBox
//
//  Created by shin on 2018/7/4.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_NetWorkService.h"

@interface SH_NetWorkService (Login)

+ (void)login:(NSString *)userName psw:(NSString *)psw verfyCode:(NSString *)verfyCode complete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed;

@end
