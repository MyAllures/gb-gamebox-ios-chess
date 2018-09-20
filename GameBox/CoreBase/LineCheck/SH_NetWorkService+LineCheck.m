//
//  SH_NetWorkService+LineCheck.m
//  GameBox
//
//  Created by shin on 2018/6/26.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_NetWorkService+LineCheck.h"

@implementation SH_NetWorkService (LineCheck)

+ (void)fetchBossAPIFromDNSGroup:(SHFetchBossAPIOneTurn)oneTurn complete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed;
{
    //三个固定的DNS
    NSArray *hosts = @[@"http://203.107.1.33/194768/d?host=apiplay.info",
                       @"http://203.107.1.33/194768/d?host=hpdbtopgolddesign.com",
                       @"http://203.107.1.33/194768/d?host=agpicdance.info"
                       ];
    //将DNS随机打乱 减轻服务器压力
    hosts = [hosts sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        int seed = arc4random_uniform(2);
        if (seed) {
            return [str1 compare:str2];
        } else {
            return [str2 compare:str1];
        }
    }];
    
    //【串行】获取动态boss-api
    __weak typeof(self) weakSelf = self;
    __block BOOL doNext = YES;
    __block int failTimes = 0;
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("gb_fetchBossApi_queue", NULL);
    dispatch_semaphore_t sema = dispatch_semaphore_create(1);
    
    for (NSString *host in hosts) {
        dispatch_group_async(group, queue, ^{
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            if (doNext != YES) {
                //先检测是否需要继续执行 不需要执行则直接跳过本线程
                dispatch_semaphore_signal(sema);
                return ;
            }
            [weakSelf get:host withPublicParameter:NO complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
                if (response) {
                    if (oneTurn) {
                        oneTurn(host, YES);
                    }
                    doNext = NO;
                    if (complete) {
                        complete(httpURLResponse, response);
                    }
                }
                else
                {
                    if (oneTurn) {
                        oneTurn(host, NO);
                    }
                    doNext = YES;
                    failTimes++;
                    if (failTimes == hosts.count) {
                        if (failed) {
                            failed(httpURLResponse, @"从DNS获取Boss-Api失败");
                        }
                    }
                }
                dispatch_semaphore_signal(sema);
            } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
                if (oneTurn) {
                    oneTurn(host, NO);
                }
                doNext = YES;
                failTimes++;
                if (failTimes == hosts.count) {
                    if (failed) {
                        failed(httpURLResponse, @"从DNS获取Boss-Api失败");
                    }
                }
                dispatch_semaphore_signal(sema);
            }];
        });
    }
}

+ (void)fetchIPSFromBossAPIGroup:(NSArray *)bossApiGroup host:(NSString *)host oneTurn:(SHFetchIPSOneTurn)oneTurn complete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed
{
    //将boss-api随机打乱 减轻服务器压力
    bossApiGroup = [bossApiGroup sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        int seed = arc4random_uniform(2);
        if (seed) {
            return [str1 compare:str2];
        } else {
            return [str2 compare:str1];
        }
    }];

    __weak typeof(self) weakSelf = self;
    __block int failTimes = 0;//失败次数
    
    //是否需要通过下一个bossApi请求ips
    //当前bossApi获取ips失败时需要从下一个获取
    __block BOOL doNext = YES;
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("gb_fetchIPs_queue", NULL);
    dispatch_semaphore_t sema = dispatch_semaphore_create(1);
    
    for (NSString *bossApi in bossApiGroup) {
        dispatch_group_async(group, queue, ^{
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            if (doNext != YES) {
                //先检测是否需要继续执行 不需要执行则直接跳过本线程
                dispatch_semaphore_signal(sema);
                return ;
            }
            
            NSString *fetchIPSUrl = [bossApi stringByAppendingString:@"/app/line.html"];
            NSDictionary *parameter = @{@"code":CODE,@"s":S,@"type":@"ips"};
            NSDictionary *header = (host == nil || [host isEqualToString:@""]) ? nil : @{@"Host":host};

            [weakSelf get:fetchIPSUrl withPublicParameter:NO parameter:parameter header:header cache:NO complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
                if (response) {
                    if (oneTurn) {
                        oneTurn(fetchIPSUrl, YES);
                    }
                    doNext = NO;
                    if (complete) {
                        complete(httpURLResponse, response);
                    }
                }
                else
                {
                    if (oneTurn) {
                        oneTurn(fetchIPSUrl, NO);
                    }
                    doNext = YES;
                    failTimes++;
                    if (failTimes == bossApiGroup.count) {
                        if (failed) {
                            failed(httpURLResponse, @"从bossApi列表获取IPS失败");
                        }
                    }
                }
                dispatch_semaphore_signal(sema);
            } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
                if (oneTurn) {
                    oneTurn(fetchIPSUrl, NO);
                }
                doNext = YES;
                failTimes++;
                if (failTimes == bossApiGroup.count) {
                    if (failed) {
                        failed(httpURLResponse, @"从bossApi列表获取IPS失败");
                    }
                }
                dispatch_semaphore_signal(sema);
            }];
        });
    }
}

+ (void)checkIPFromIPGroup:(NSArray *)ipGroup host:(NSString *)host oneTurn:(SHCheckIPOneTurn)oneTurn failed:(SHNetWorkFailed)failed
{
    __weak typeof(self) weakSelf = self;
    NSArray *checkTypes = @[@"https+8989",@"http+8787",@"https",@"http"];
    __block int failTimes = 0;

    for (int i = 0; i < ipGroup.count; i++) {
        NSString *ip = ipGroup[i];
        //多ip并发check
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_group_t group = dispatch_group_create();
            NSString *queueName = [NSString stringWithFormat:@"gb_checkIP_with_type_queue%i",i];
            dispatch_queue_t queue = dispatch_queue_create([queueName UTF8String], NULL);
            dispatch_semaphore_t sema = dispatch_semaphore_create(1);
            
            for (NSString *checkType in checkTypes) {
                dispatch_group_async(group, queue, ^{
                    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
                    
                    NSArray *checkTypeComp = [checkType componentsSeparatedByString:@"+"];
                    NSString *checkUrl = [NSString stringWithFormat:@"%@://%@%@/__check",checkTypeComp[0],ip,checkTypeComp.count==2?[NSString stringWithFormat:@":%@",checkTypeComp[1]]:@""];
                    [weakSelf get:checkUrl withPublicParameter:NO parameter:nil header:@{@"Host":host} cache:NO detailErr:YES complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
                        if (response) {
                            if ([response isKindOfClass:[NSString class]]) {
                                response = [response stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                                ;
                                if ([[response lowercaseString] isEqualToString:@"ok"]) {
                                    if (oneTurn) {
                                        oneTurn(httpURLResponse , @"", ip, checkType, YES);
                                    }
                                }
                            }
                            else
                            {
                                if (oneTurn) {
                                    oneTurn(httpURLResponse, @"unknown", ip, checkType, NO);
                                }
                                failTimes++;
                                if (failTimes == ipGroup.count*checkTypes.count) {
                                    if (failed) {
                                        failed(httpURLResponse, @"全部ip check失败");
                                    }
                                }
                            }
                        }
                        else
                        {
                            if (oneTurn) {
                                oneTurn(httpURLResponse, @"unknown", ip, checkType, NO);
                            }
                            failTimes++;
                            if (failTimes == ipGroup.count*checkTypes.count) {
                                if (failed) {
                                    failed(httpURLResponse, @"全部ip check失败");
                                }
                            }
                        }
                        dispatch_semaphore_signal(sema);
                    } failed:^(NSHTTPURLResponse *httpURLResponse,  NSString *err) {
                        if (oneTurn) {
                            oneTurn(httpURLResponse, err, ip, checkType, NO);
                        }
                        failTimes++;
                        if (failTimes == ipGroup.count*checkTypes.count) {
                            if (failed) {
                                failed(httpURLResponse, @"全部ip check失败");
                            }
                        }
                        dispatch_semaphore_signal(sema);
                    }];
                });
            }
        });
    }
}

+ (void)uploadLineCheckErr:(NSMutableDictionary *)errDic complete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed
{
    //https://apiplay.info:1344/boss-api/facade/collectAppDomainError.html
    [self post:@"https://apiplay.info:1344/boss-api/6.html" parameter:errDic complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}
@end
