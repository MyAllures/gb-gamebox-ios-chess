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

#define SH_DEFAULT_NETWORK_TIMEOUT 15.0f //默认的超时秒数
#define SH_MAX_NETWORK_CONCURRENT 10 //最大http并发数
#define GB_CURRENT_APPVERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define GB_CURRENT_APPBUILD [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

static AFHTTPSessionManager *sharedManager = nil;

@implementation SH_NetWorkService

+ (AFHTTPSessionManager *)manager {
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

+ (void)get:(NSString *)url withPublicParameter:(BOOL)withPublicParameter parameter:(NSDictionary *)parameter header:(NSDictionary *)header cache:(BOOL)cache complete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed
{
    if (cache) {
        //如果有需要缓存 先读取缓存
        id response = [[SH_CacheManager shareManager] getCacheResponseObjectWithRequestUrl:url params:parameter];
        if (response) {
            if (complete)
            {
                complete(nil, response);
            }
        }
    }

    __weak typeof(self) weakSelf = self;
    AFHTTPSessionManager *manager = [self manager];
    
    //允许非权威机构颁发的证书
    manager.securityPolicy.allowInvalidCertificates = YES;
    //也不验证域名一致性
    manager.securityPolicy.validatesDomainName = NO;
    
    //添加消息头
    //默认header
    NSString *user_agent = [NSString stringWithFormat:@"app_ios, iPhone, chess, %@.%@",GB_CURRENT_APPVERSION, GB_CURRENT_APPBUILD];
    [manager.requestSerializer setValue:user_agent forHTTPHeaderField:@"User-Agent"];
    if (header) {
        for (NSString *key in header.allKeys) {
            [manager.requestSerializer setValue:[header objectForKey:key] forHTTPHeaderField:key];
        }
    }
    
    NSMutableDictionary *mParameter = withPublicParameter ? [self publicParam] : [NSMutableDictionary dictionary];
    if (parameter) {
        [mParameter addEntriesFromDictionary:parameter];
    }
    
    [manager GET:url parameters:mParameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (complete) {
            id response = [weakSelf translateResponseData:responseObject];
            if (cache)
            {
                //如果需要缓存 则缓存数据
                [[SH_CacheManager shareManager] cacheResponseObject:response requestUrl:url params:parameter];
            }

            complete((NSHTTPURLResponse *)task.response, response);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failed) {
            failed((NSHTTPURLResponse *)task.response, error.description);
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
    if (cache) {
        //如果有需要缓存 先读取缓存
        id response = [[SH_CacheManager shareManager] getCacheResponseObjectWithRequestUrl:url params:parameter];
        if (response) {
            if (complete)
            {
                complete(nil, response);
            }
        }
    }
    
    __weak typeof(self) weakSelf = self;
    AFHTTPSessionManager *manager = [self manager];

    //允许非权威机构颁发的证书
    manager.securityPolicy.allowInvalidCertificates = YES;
    //也不验证域名一致性
    manager.securityPolicy.validatesDomainName = NO;
    
    //添加消息头
    //默认header
    NSString *user_agent = [NSString stringWithFormat:@"app_ios, iPhone, chess, %@.%@",GB_CURRENT_APPVERSION, GB_CURRENT_APPBUILD];
    [manager.requestSerializer setValue:user_agent forHTTPHeaderField:@"User-Agent"];
    if (header) {
        for (NSString *key in header.allKeys) {
            [manager.requestSerializer setValue:[header objectForKey:key] forHTTPHeaderField:key];
        }
    }
    
    NSMutableDictionary *mParameter = [self publicParam];
    if (parameter) {
        [mParameter addEntriesFromDictionary:parameter];
    }

    [manager POST:url parameters:mParameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (complete) {
            id response = [weakSelf translateResponseData:responseObject];
            if (cache)
            {
                //如果需要缓存 则缓存数据
                [[SH_CacheManager shareManager] cacheResponseObject:response requestUrl:url params:parameter];
            }

            complete((NSHTTPURLResponse *)task.response, response);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failed) {
            failed((NSHTTPURLResponse *)task.response, error.description);
        }
    }];
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

@end
