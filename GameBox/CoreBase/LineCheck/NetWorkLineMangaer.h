//
//  NetWorkLineMangaer.h
//  GameBox
//
//  Created by shin on 2018/7/4.
//  Copyright © 2018年 shin. All rights reserved.
//

#import <Foundation/Foundation.h>


/*
 * 线路的管理单利
 * 数据访问的url、host等信息来自此单利
 */
@interface NetWorkLineMangaer : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, strong) NSString *currentIP;
@property (nonatomic, strong) NSString *currentHttpType;
@property (nonatomic, strong) NSString *currentPort;
@property (nonatomic, strong) NSString *currentPreUrl;
@property (nonatomic, strong) NSString *currentHost;
@property (nonatomic, strong) NSString *currentCookie;
@property (nonatomic, strong) NSString *currentSID;

@end
