//
//  SH_NetWorkService+Promo.h
//  GameBox
//
//  Created by sam on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_NetWorkService.h"

@interface SH_NetWorkService_Promo : SH_NetWorkService


+ (void)getPromoList:(NSInteger )pageNumber
            pageSize:(NSInteger )pageSize
 activityClassifyKey:(NSString *)activityClassifyKey
            complete:(SHNetWorkComplete)complete
              failed:(SHNetWorkFailed)failed;

+(void)startLoadGameNoticeStartTime:(NSString *)startTime
                            endTime:(NSString *)endTime
                         pageNumber:(NSInteger)pageNumber
                           pageSize:(NSInteger)pageSize
                              apiId:(NSInteger)apiId
                           complete:(SHNetWorkComplete)complete
                             failed:(SHNetWorkFailed)failed;


+(void)startLoadSystemNoticeStartTime:(NSString *)startTime
                              endTime:(NSString *)endTime
                           pageNumber:(NSInteger)pageNumber
                             pageSize:(NSInteger)pageSize
                             complete:(SHNetWorkComplete)complete
                               failed:(SHNetWorkFailed)failed;


+(void)startSiteMessageMyMessageWithpageNumber:(NSInteger)pageNumber
                                        pageSize:(NSInteger)pageSize
                                        complete:(SHNetWorkComplete)complete
                                          failed:(SHNetWorkFailed)failed;


+(void)startLoadSystemMessageWithpageNumber:(NSInteger)pageNumber
                                      pageSize:(NSInteger)pageSize
                                      complete:(SHNetWorkComplete)complete
                                        failed:(SHNetWorkFailed)failed;


+(void)startAddApplyDiscountsWithAdvisoryType:(NSString *)advisoryType
                                  advisoryTitle:(NSString *)advisoryTitle
                                advisoryContent:(NSString *)advisoryContent
                                           code:(NSString *)code
                                       complete:(SHNetWorkComplete)complete
                                         failed:(SHNetWorkFailed)failed;


+(void)startAddApplyDiscountsVerify:(SHNetWorkComplete)complete
                               failed:(SHNetWorkFailed)failed;


+(void)startLoadMessageCenterSiteMessageUnReadCount:(SHNetWorkComplete)complete
                                             failed:(SHNetWorkFailed)failed;

+(void)startLoadMyMessageDeleteWithIds:(NSString *)ids
                              complete:(SHNetWorkComplete)complete
                                failed:(SHNetWorkFailed)failed;

+(void)startLoadSystemMessageDetailWithSearchId:(NSString *)searchId
                                         complete:(SHNetWorkComplete)complete
                                           failed:(SHNetWorkFailed)failed;

+(void)startSiteMessageMyMessageDetailWithID:(NSString *)mId
                                      complete:(SHNetWorkComplete)complete
                                        failed:(SHNetWorkFailed)failed;

+(void)startLoadSystemMessageDeleteWithIds:(NSString *)ids
                                    complete:(SHNetWorkComplete)complete
                                      failed:(SHNetWorkFailed)failed;

+(void)startLoadSystemMessageReadYesWithIds:(NSString *)ids
                                     complete:(SHNetWorkComplete)complete
                                       failed:(SHNetWorkFailed)failed;

+(void)startLoadMyMessageReadYesWithIds:(NSString *)ids
                                 complete:(SHNetWorkComplete)complete
                                   failed:(SHNetWorkFailed)failed;

@end
