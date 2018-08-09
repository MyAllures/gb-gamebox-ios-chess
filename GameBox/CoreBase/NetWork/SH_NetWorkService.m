//
//  SH_NetWorkService.m
//  GameBox
//
//  Created by shin on 2018/6/26.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_NetWorkService.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import "SH_CacheManager.h"
#import "SH_HttpErrManager.h"

//其他宏配置
#define SH_DEFAULT_NETWORK_TIMEOUT 15.0f //默认的超时秒数
#define SH_MAX_NETWORK_CONCURRENT 10 //最大http并发数

static BOOL isNetworkingOK = YES;//网络状态 默认畅通

@implementation SH_NetWorkService

+ (AFHTTPSessionManager *)manager {
    __weak typeof(self) weakSelf = self;

    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
            manager = [AFHTTPSessionManager manager];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
            manager.responseSerializer.acceptableContentTypes =
            [NSSet setWithArray:@[@"application/json",@"text/html",@"text/json",@"text/plain",@"text/javascript",@"text/xml",@"image/*",@"image/jpeg"]];
            manager.requestSerializer.timeoutInterval = SH_DEFAULT_NETWORK_TIMEOUT;
            manager.operationQueue.maxConcurrentOperationCount = SH_MAX_NETWORK_CONCURRENT;
            //监控网络状态
            [weakSelf isNetWorkStatusOK:^(BOOL ok) {
                isNetworkingOK = ok;
                if (!ok) {
                    showErrorMessage([UIApplication sharedApplication].keyWindow, nil, @"暂无网络");
                }
            }];
        }
    });
    return manager;
}

+ (void)configTimeOut:(CGFloat)sec
{
    [self manager].requestSerializer.timeoutInterval = sec;
}

+ (void)get:(NSString *)url withPublicParameter:(BOOL)withPublicParameter complete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed
{
    [self get:url withPublicParameter:withPublicParameter parameter:nil complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}

+ (void)get:(NSString *)url withPublicParameter:(BOOL)withPublicParameter parameter:(NSDictionary *)parameter complete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed
{
    [self get:url withPublicParameter:withPublicParameter parameter:parameter header:nil cache:NO complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        if (failed) {
            failed(httpURLResponse,err);
        }
    }];
}

+ (void)get:(NSString *)url withPublicParameter:(BOOL)withPublicParameter parameter:(NSDictionary *)parameter header:(NSDictionary *)header cache:(BOOL)cache detailErr:(BOOL)detailErr complete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed
{
    __weak typeof(self) weakSelf = self;
    if (isNetworkingOK) {
        //先从cache读取
        [weakSelf readFromCache:cache url:url parameter:parameter complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
            if (complete) {
                complete(httpURLResponse, response);
            }
        }];
        
        //配置HTTPSessionManager
        AFHTTPSessionManager *manager = [self configHTTPSessionManager:header];
        
        //配置parameters
        NSMutableDictionary *mParameter = [self appendParameter:parameter withPublicParameter:withPublicParameter];
        
        [manager GET:url parameters:mParameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //统一处理respones并回调
            [weakSelf dealResultWithUrl:url parameter:parameter header:header cache:cache task:task responseObject:responseObject complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
                if (complete) {
                    complete(httpURLResponse, response);
                }
            } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
                if (failed) {
                    failed(httpURLResponse, err);
                }
            }];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failed) {
                failed((NSHTTPURLResponse *)task.response, detailErr ? error.description : @"访问失败");
            }
        }];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            showErrorMessage([UIApplication sharedApplication].keyWindow, nil, @"网络链接失败");
        });
        if (failed) {
            failed(nil, @"网络链接失败");
        }
    }
}

+ (void)get:(NSString *)url withPublicParameter:(BOOL)withPublicParameter parameter:(NSDictionary *)parameter header:(NSDictionary *)header cache:(BOOL)cache complete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed
{
    [self get:url withPublicParameter:withPublicParameter parameter:parameter header:header cache:cache detailErr:NO complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        if (failed) {
            failed(httpURLResponse,err);
        }
    }];
}

+ (void)get:(NSString *)url complete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed
{
    [self get:url withPublicParameter:YES parameter:nil complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        if (failed) {
            failed(httpURLResponse,err);
        }
    }];
}

+ (void)get:(NSString *)url parameter:(NSDictionary *)parameter complete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed
{
    [self get:url withPublicParameter:YES parameter:parameter header:nil cache:NO complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}

+ (void)get:(NSString *)url parameter:(NSDictionary *)parameter header:(NSDictionary *)header complete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed
{
    [self get:url withPublicParameter:YES parameter:parameter header:header cache:NO complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse,response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}

+ (void)post:(NSString *)url complete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed
{
    [self post:url parameter:nil complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}

+ (void)post:(NSString *)url parameter:(NSDictionary *)parameter complete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed
{
    [self post:url parameter:parameter header:nil cache:NO complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
        if (complete) {
            complete(httpURLResponse, response);
        }
    } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
        if (failed) {
            failed(httpURLResponse, err);
        }
    }];
}

+ (void)post:(NSString *)url parameter:(NSDictionary *)parameter header:(NSDictionary *)header cache:(BOOL)cache complete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed
{
    __weak typeof(self) weakSelf = self;

    //先检测网络是否链接
    if (isNetworkingOK) {
        //先从cache读取
        [weakSelf readFromCache:cache url:url parameter:parameter complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
            if (complete) {
                complete(httpURLResponse, response);
            }
        }];
        
        //配置HTTPSessionManager
        AFHTTPSessionManager *manager = [self configHTTPSessionManager:header];
        
        //配置parameters
        NSMutableDictionary *mParameter = [self appendParameter:parameter withPublicParameter:YES];
        
        [manager POST:url parameters:mParameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //统一处理respones并回调
            [weakSelf dealResultWithUrl:url parameter:parameter header:header cache:cache task:task responseObject:responseObject complete:^(NSHTTPURLResponse *httpURLResponse, id response) {
                if (complete) {
                    complete(httpURLResponse, response);
                }
            } failed:^(NSHTTPURLResponse *httpURLResponse, NSString *err) {
                if (failed) {
                    failed(httpURLResponse, err);
                }
            }];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failed) {
                failed((NSHTTPURLResponse *)task.response, @"访问失败");
            }
        }];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            showErrorMessage([UIApplication sharedApplication].keyWindow, nil, @"网络链接失败");
        });
        if (failed) {
            failed(nil, @"网络链接失败");
        }
    }
}

#pragma mark - Private M

+ (NSMutableDictionary *)publicParam
{
    //公共请求参数
    NSMutableDictionary *mParameter = [NSMutableDictionary dictionary];
    [mParameter setValue:@"app_ios" forKey:@"terminal"] ;
    [mParameter setValue:@"True" forKey:@"is_native"] ;
    [mParameter setValue:@"3.0" forKey:@"version"] ;
    [mParameter setValue:@"zh_CN" forKey:@"locale"] ;
    [mParameter setValue:@"black" forKey:@"theme"] ;
    [mParameter setValue:@"2x" forKey:@"resolution"] ;
    return mParameter;
}

+ (id)translateResponseData:(NSData *)data
{
    NSError *error;
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (responseObject == nil || error) {
        //不能转换成对象
        //转换为字符串
        NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (responseString) {
            return responseString;
        }
        else
        {
            //字符串转换失败则直接返回data
            return data;
        }
    }
    else
    {
        //只记得转换为对象输出
        return responseObject;
    }
}

+ (void)isNetWorkStatusOK:(SHNetWorkCheckComplete)complete
{
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [reachabilityManager startMonitoring];
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusUnknown || status == AFNetworkReachabilityStatusNotReachable) {
            //未知网络或无网络
            if (complete) {
                complete(NO);
            }
        }
        else
        {
            //网络通畅
            if (complete) {
                complete(YES);
            }
        }
    }];
}

//处理回调结果
+ (void)dealResultWithUrl:(NSString *)url parameter:(NSDictionary *)parameter header:(NSDictionary *)header cache:(BOOL)cache task:(NSURLSessionDataTask * _Nonnull)task responseObject:(id  _Nullable) responseObject complete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed
{
    id response = [self translateResponseData:responseObject];
    //先做code判断看是否需要做特点错误码的统一回调
    if ([response isKindOfClass:[NSDictionary class]]) {
        if ([[response allKeys] containsObject:@"code"]) {
            int code = [response[@"code"] intValue];
            if (code == SH_API_ERRORCODE_403 ||
                code == SH_API_ERRORCODE_404 ||
                code == SH_API_ERRORCODE_500 ||
                code == SH_API_ERRORCODE_502 ||
                code == SH_API_ERRORCODE_600 ||
                code == SH_API_ERRORCODE_601 ||
                code == SH_API_ERRORCODE_602 ||
                code == SH_API_ERRORCODE_603 ||
                code == SH_API_ERRORCODE_604 ||
                code == SH_API_ERRORCODE_605 ||
                code == SH_API_ERRORCODE_606 ||
                code == SH_API_ERRORCODE_607 ||
                code == SH_API_ERRORCODE_608 ||
                code == SH_API_ERRORCODE_609 ||
                code == SH_API_ERRORCODE_1001) {
                //统一处理
                [SH_HttpErrManager dealWithErrCode:code];
                if (failed) {
                    NSString *errDes = @"";
                    if (code == SH_API_ERRORCODE_403)
                    {
                        errDes = @"无权限访问";
                    }
                    else if (code == SH_API_ERRORCODE_404) {
                        errDes = @"请求链接或页面找不到";
                    }
                    else if (code == SH_API_ERRORCODE_500) {
                        errDes = @"代码错误";
                    }
                    else if (code == SH_API_ERRORCODE_502) {
                        errDes = @"网络连接错误";
                    }
                    else if (code == SH_API_ERRORCODE_600) {
                        errDes = @"session已过期";
                    }
                    else if (code == SH_API_ERRORCODE_601) {
                        errDes = @"需要输入安全密码";
                    }
                    else if (code == SH_API_ERRORCODE_602) {
                        errDes = @"服务忙";
                    }
                    else if (code == SH_API_ERRORCODE_603) {
                        errDes = @"域名不存在";
                    }
                    else if (code == SH_API_ERRORCODE_604) {
                        errDes = @"临时域名过期";
                    }
                    else if (code == SH_API_ERRORCODE_605) {
                        errDes = @"ip被限制";
                    }
                    else if (code == SH_API_ERRORCODE_606)
                    {
                        errDes = @"您的账号在其他设备登录";
                    }
                    else if (code == SH_API_ERRORCODE_607)
                    {
                        errDes = @"站点维护";
                    }
                    else if (code == SH_API_ERRORCODE_608)
                    {
                        errDes = @"重复请求";
                    }
                    else if (code == SH_API_ERRORCODE_609)
                    {
                        errDes = @"站点不存在";
                    }
                    else if (code == SH_API_ERRORCODE_1001)
                    {
                        errDes = @"请先登录";
                    }
                    failed((NSHTTPURLResponse *)task.response, errDes);
                }
            }
            else
            {
                //不是以上特定的错误
                //才会缓存responseObject
                if (cache)
                {
                    //如果需要缓存 则缓存数据
                    [[SH_CacheManager shareManager] cacheResponseObject:responseObject requestUrl:url params:parameter];
                }
                
                if (complete) {
                    complete((NSHTTPURLResponse *)task.response, response);
                }
            }
        }
        else
        {
            if (complete) {
                complete((NSHTTPURLResponse *)task.response, response);
            }
        }
    }
    else
    {
        if (complete) {
            complete((NSHTTPURLResponse *)task.response, response);
        }
    }
}

+ (void)readFromCache:(BOOL)cache url:(NSString *)url parameter:(NSDictionary *)parameter complete:(SHNetWorkComplete)complete
{
    if (cache) {
        //如果有需要缓存 先读取缓存
        id responseObject = [[SH_CacheManager shareManager] getCacheResponseObjectWithRequestUrl:url params:parameter];
        if (responseObject) {
            id response = [self translateResponseData:responseObject];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (complete)
                {
                    complete(nil, response);
                }
            });
        }
    }
}

+ (AFHTTPSessionManager *)configHTTPSessionManager:(NSDictionary *)header
{
    AFHTTPSessionManager *manager = [self manager];
    
    //允许非权威机构颁发的证书
    manager.securityPolicy.allowInvalidCertificates = YES;
    //也不验证域名一致性
    manager.securityPolicy.validatesDomainName = NO;
    
    //添加消息头
    //默认header
    NSString *user_agent = [NSString stringWithFormat:@"app_ios, iPhone, chess, %@.%@",GB_CURRENT_APPVERSION, GB_CURRENT_APPBUILD];
    [manager.requestSerializer setValue:user_agent forHTTPHeaderField:@"User-Agent"];
    [manager.requestSerializer setValue:[NetWorkLineMangaer sharedManager].currentCookie forHTTPHeaderField:@"Cookie"];
    if (header) {
        for (NSString *key in header.allKeys) {
            [manager.requestSerializer setValue:[header objectForKey:key] forHTTPHeaderField:key];
        }
    }
    
    return manager;
}

+ (NSMutableDictionary *)appendParameter:(NSDictionary *)parameter withPublicParameter:(BOOL)withPublicParameter
{
    NSMutableDictionary *mParameter = withPublicParameter ? [self publicParam] : [NSMutableDictionary dictionary];
    if (parameter) {
        [mParameter addEntriesFromDictionary:parameter];
    }
    return mParameter;
}

@end
