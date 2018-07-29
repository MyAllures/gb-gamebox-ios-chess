//
//  SH_NetWorkService.h
//  GameBox
//
//  Created by shin on 2018/6/26.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SHNetWorkComplete)(NSHTTPURLResponse *httpURLResponse, id response);
typedef void(^SHNetWorkFailed)(NSHTTPURLResponse *httpURLResponse, NSString *err);

@interface SH_NetWorkService : NSObject

//可选公共参数的get

+ (void)get:(NSString *)url withPublicParameter:(BOOL)withPublicParameter complete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed;
+ (void)get:(NSString *)url withPublicParameter:(BOOL)withPublicParameter parameter:(NSDictionary *)parameter complete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed;
+ (void)get:(NSString *)url withPublicParameter:(BOOL)withPublicParameter parameter:(NSDictionary *)parameter header:(NSDictionary *)header cache:(BOOL)cache complete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed;

//带公共参数的get
+ (void)get:(NSString *)url complete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed;
+ (void)get:(NSString *)url parameter:(NSDictionary *)parameter complete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed;
+ (void)get:(NSString *)url parameter:(NSDictionary *)parameter header:(NSDictionary *)header complete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed;

+ (void)post:(NSString *)url complete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed;
+ (void)post:(NSString *)url parameter:(NSDictionary *)parameter complete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed;
+ (void)post:(NSString *)url parameter:(NSDictionary *)parameter header:(NSDictionary *)header cache:(BOOL)cache complete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed;

@end
