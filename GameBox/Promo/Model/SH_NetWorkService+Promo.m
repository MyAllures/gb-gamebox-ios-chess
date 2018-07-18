//
//  SH_NetWorkService+Promo.m
//  GameBox
//
//  Created by sam on 2018/7/10.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_NetWorkService+Promo.h"

@implementation SH_NetWorkService_Promo

#pragma mark - 获取优惠主界面列表
+ (void)getPromoList:(NSInteger )pageNumber pageSize:(NSInteger )pageSize activityClassifyKey:(NSString *)activityClassifyKey complete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed
{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/discountsOrigin/getActivityTypeList.html"];
    NSDictionary *parameter =  @{@"paging.pageNumber":@(pageNumber),@"paging.pageSize":@(pageSize),@"search.activityClassifyKey":activityClassifyKey};
    NSDictionary *header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost};
    [SH_NetWorkService post:url parameter:parameter header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}
#pragma mark - 获取系统公告
+(void)startLoadSystemNoticeStartTime:(NSString *)startTime
                              endTime:(NSString *)endTime
                           pageNumber:(NSInteger)pageNumber
                             pageSize:(NSInteger)pageSize complete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed{
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/mineOrigin/getSysNotice.html"];
    NSDictionary *parameter =  @{@"search.startTime":startTime?:@"",@"search.endTime":endTime?:@"",@"paging.pageNumber":@(pageNumber),@"paging.pageSize":@(pageSize)};
    NSDictionary *header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost, @"Cookie":[NetWorkLineMangaer sharedManager].currentCookie?:@""};
    [SH_NetWorkService post:url parameter:parameter header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}
#pragma mark - 获取游戏公告
+(void)startLoadGameNoticeStartTime:(NSString *)startTime
                            endTime:(NSString *)endTime
                         pageNumber:(NSInteger)pageNumber
                           pageSize:(NSInteger)pageSize
                              apiId:(NSInteger)apiId
                           complete:(SHNetWorkComplete)complete
                             failed:(SHNetWorkFailed)failed {
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/mineOrigin/getGameNotice.html"];
    NSDictionary *parameter;
    if (apiId > 0) {
        parameter =  @{@"search.startTime":startTime,@"search.endTime":endTime?:@"",@"paging.pageNumber":@(pageNumber),@"paging.pageSize":@(pageSize),@"search.apiId":@(apiId)};
    }else{
        parameter =  @{@"search.startTime":startTime,@"search.endTime":endTime?:@"",@"paging.pageNumber":@(pageNumber),@"paging.pageSize":@(pageSize)};
    }
    
    NSDictionary *header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost, @"Cookie":[NetWorkLineMangaer sharedManager].currentCookie?:@""};
    NSLog(@"url====%@",url);
    [SH_NetWorkService post:url parameter:parameter header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}
#pragma mark - 站点信息  我的消息
+(void)startSiteMessageMyMessageWithpageNumber:(NSInteger)pageNumber
                                        pageSize:(NSInteger)pageSize
                                        complete:(SHNetWorkComplete)complete
                                          failed:(SHNetWorkFailed)failed {
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/mineOrigin/advisoryMessage.html"];
    NSDictionary *parameter =  @{@"paging.pageNumber":@(pageNumber),@"paging.pageSize":@(pageSize)};
    NSDictionary *header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost, @"Cookie":[NetWorkLineMangaer sharedManager].currentCookie?:@""};
    [SH_NetWorkService post:url parameter:parameter header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}
#pragma mark - 站点信息  系统消息
+(void)startLoadSystemMessageWithpageNumber:(NSInteger)pageNumber
                                   pageSize:(NSInteger)pageSize
                                   complete:(SHNetWorkComplete)complete
                                     failed:(SHNetWorkFailed)failed {
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/mineOrigin/getSiteSysNotice.html"];
    NSDictionary *parameter =  @{@"paging.pageNumber":@(pageNumber),@"paging.pageSize":@(pageSize)};
    NSDictionary *header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost, @"Cookie":[NetWorkLineMangaer sharedManager].currentCookie?:@""};
    [SH_NetWorkService post:url parameter:parameter header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}

#pragma mark - 站点信息 - 系统消息详情
+(void)startLoadSystemMessageDetailWithSearchId:(NSString *)searchId
                                       complete:(SHNetWorkComplete)complete
                                         failed:(SHNetWorkFailed)failed {
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/mineOrigin/getSiteSysNoticeDetail.html"];
    NSDictionary *parameter =  @{@"searchId":searchId};
    NSDictionary *header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost, @"Cookie":[NetWorkLineMangaer sharedManager].currentCookie?:@""};
    [SH_NetWorkService post:url parameter:parameter header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}
#pragma mark - 发送消息验证
+(void)startAddApplyDiscountsVerify:(SHNetWorkComplete)complete
                             failed:(SHNetWorkFailed)failed {
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/mineOrigin/getNoticeSiteType.html"];
    NSDictionary *parameter =  @{};
    NSDictionary *header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost};
    [SH_NetWorkService post:url parameter:parameter header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}
#pragma mark - 消息中心 发送消息
+(void)startAddApplyDiscountsWithAdvisoryType:(NSString *)advisoryType
                                advisoryTitle:(NSString *)advisoryTitle
                              advisoryContent:(NSString *)advisoryContent
                                         code:(NSString *)code
                                     complete:(SHNetWorkComplete)complete
                                       failed:(SHNetWorkFailed)failed {
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/mineOrigin/addNoticeSite.html"];
    NSDictionary *parameter =  @{@"result.advisoryType":advisoryType,@"result.advisoryTitle":advisoryTitle,@"result.advisoryContent":advisoryContent,@"code":code};
    NSDictionary *header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost, @"Cookie":[NetWorkLineMangaer sharedManager].currentCookie?:@""};
    [SH_NetWorkService post:url parameter:parameter header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}
#pragma mark - 站点信息 - 我的消息删除
+(void)startLoadMyMessageDeleteWithIds:(NSString *)ids
                              complete:(SHNetWorkComplete)complete
                                failed:(SHNetWorkFailed)failed {
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/mineOrigin/deleteAdvisoryMessage.html"];
    NSDictionary *parameter =  @{@"ids":ids};
    NSDictionary *header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost, @"Cookie":[NetWorkLineMangaer sharedManager].currentCookie?:@""};
    [SH_NetWorkService post:url parameter:parameter header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}
#pragma mark - V3 站点信息 系统信息删除
+(void)startLoadSystemMessageDeleteWithIds:(NSString *)ids
                                  complete:(SHNetWorkComplete)complete
                                    failed:(SHNetWorkFailed)failed {
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/mineOrigin/deleteSiteSysNotice.html"];
    NSDictionary *parameter =  @{@"ids":ids};
    NSDictionary *header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost, @"Cookie":[NetWorkLineMangaer sharedManager].currentCookie?:@""};
    [SH_NetWorkService post:url parameter:parameter header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}

#pragma mark  - 获取站点消息-系统消息&&我的消息 未读消息的条数
+(void)startLoadMessageCenterSiteMessageUnReadCount:(SHNetWorkComplete)complete
                                             failed:(SHNetWorkFailed)failed {
    NSString *url = [[NetWorkLineMangaer sharedManager].currentPreUrl stringByAppendingString:@"/mobile-api/mineOrigin/getUnReadCount.html"];
    NSDictionary *parameter =  @{};
    NSDictionary *header = @{@"Host":[NetWorkLineMangaer sharedManager].currentHost};
    [SH_NetWorkService post:url parameter:parameter header:header complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}


@end
