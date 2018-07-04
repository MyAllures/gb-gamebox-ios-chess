//
//  SH_NetWorkService+LineCheck.h
//  GameBox
//
//  Created by shin on 2018/6/26.
//  Copyright © 2018年 shin. All rights reserved.
//

#import "SH_NetWorkService.h"

//线路检测【第一步】中 每检测完毕一个DNS的回调
typedef void(^SHFetchBossAPIOneTurn)(NSString *dns, BOOL success);
//线路检测【第二步】中 每检测完毕一个bossapi的回调
typedef void(^SHFetchIPSOneTurn)(NSString *bossapi, BOOL success);
//线路检测【第三步】中 每检测完毕一个ip的回调
typedef void(^SHCheckIPOneTurn)(NSString *ip, NSString *checkType, BOOL success);

@interface SH_NetWorkService (LineCheck)

/**
 线路检测【第一步】
 从三个DNS获取boss-api
 
 @param oneTurn 没检测完毕一个DNS的回调 返回检测的dns和检测结果
 @param complete 得到boss-api信息
 @param failed 返回错误信息 展示在界面上
 */
+ (void)fetchBossAPIFromDNSGroup:(SHFetchBossAPIOneTurn)oneTurn complete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed;

/**
 线路检测【第二步】
 从boss-api列表中获取ips

 @param bossApiGroup 从第一步获取到的bossapi列表
 @param host 从第一步获取到的host
 @param oneTurn 每检测完毕一个bossApi的回调 返回检测的bossApi和检测结果
 @param complete 得到boss-api信息
 @param failed 返回错误信息 展示在界面上
 */
+ (void)fetchIPSFromBossAPIGroup:(NSArray *)bossApiGroup host:(NSString *)host oneTurn:(SHFetchIPSOneTurn)oneTurn complete:(SHNetWorkComplete)complete failed:(SHNetWorkFailed)failed;


/**
 线路检测【第三步】
 check ip


 @param ipGroup 从第二步中拿到的ips
 @param host 从第二步中拿到的
 @param oneTurn 每check完一个ip的回调 返回ip 类型 和 check结果
 @param failed 返回错误信息 展示在界面上
 */
+ (void)checkIPFromIPGroup:(NSArray *)ipGroup host:(NSString *)host oneTurn:(SHCheckIPOneTurn)oneTurn failed:(SHNetWorkFailed)failed;

@end
