//
//  SH_NetWorkService+Promo.h
//  GameBox
//
//  Created by sam on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_NetWorkService.h"

@interface SH_NetWorkService_Promo : SH_NetWorkService

#pragma mark - 获取优惠主界面列表
+ (void)getPromoList:(NSInteger )pageNumber
            pageSize:(NSInteger )pageSize
 activityClassifyKey:(NSString *)activityClassifyKey
            complete:(SHNetWorkComplete)complete
              failed:(SHNetWorkFailed)failed;

#pragma mark - 获取游戏公告
+(void)startLoadGameNoticeStartTime:(NSString *)startTime
                            endTime:(NSString *)endTime
                         pageNumber:(NSInteger)pageNumber
                           pageSize:(NSInteger)pageSize
                              apiId:(NSInteger)apiId
                           complete:(SHNetWorkComplete)complete
                             failed:(SHNetWorkFailed)failed;

#pragma mark - 获取系统公告
+(void)startLoadSystemNoticeStartTime:(NSString *)startTime
                              endTime:(NSString *)endTime
                           pageNumber:(NSInteger)pageNumber
                             pageSize:(NSInteger)pageSize
                             complete:(SHNetWorkComplete)complete
                               failed:(SHNetWorkFailed)failed;

#pragma mark - 站点信息  我的消息
+(void)startSiteMessageMyMessageWithpageNumber:(NSInteger)pageNumber
                                        pageSize:(NSInteger)pageSize
                                        complete:(SHNetWorkComplete)complete
                                          failed:(SHNetWorkFailed)failed;

#pragma mark - 站点信息  系统消息
+(void)startLoadSystemMessageWithpageNumber:(NSInteger)pageNumber
                                      pageSize:(NSInteger)pageSize
                                      complete:(SHNetWorkComplete)complete
                                        failed:(SHNetWorkFailed)failed;

#pragma mark  - 获取站点消息-系统消息&&我的消息 未读消息的条数
+(void)startLoadMessageCenterSiteMessageUnReadCount:(SHNetWorkComplete)complete
                                             failed:(SHNetWorkFailed)failed;

@end
