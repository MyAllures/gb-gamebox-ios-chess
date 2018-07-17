//
//  SH_NetWorkService+UserCenter.h
//  GameBox
//
//  Created by Paul on 2018/7/17.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_NetWorkService.h"

@interface SH_NetWorkService (UserCenter)

/**
 资金记录

 @param startDate  开始时间
 @param endDate 结束时间
 @param type 类型（ 存款 取款 返水）
 @param pageNumber 页码
 @param pageSize 一页显示多少条
 */
+(void)fetchDepositList:(NSString*)startDate
                EndDate:(NSString*)endDate
             SearchType:(NSString*)type
             PageNumber:(NSInteger)pageNumber
               PageSize:(NSInteger)pageSize
               complete:(SHNetWorkComplete)complete
                  failed:(SHNetWorkFailed)failed;
+(void)fetchDepositPulldownListComplete:(SHNetWorkComplete)complete
                                 failed:(SHNetWorkFailed)failed;
+(void)fetchDepositListDetail:(NSString*)Id
                     complete:(SHNetWorkComplete)complete
                       failed:(SHNetWorkFailed)failed;
@end
