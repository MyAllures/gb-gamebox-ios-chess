//
//  CLPathManager.h
//  TaskTracking
//
//  Created by jinguihua on 2017/2/22.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,CLPathType) {
    CLPathTypeDocument,
    CLPathTypeLibrary,
    CLPathTypeCaches,
    CLPathTypeTemp,
    CLPathTypeCount
};

@interface CLPathManager : NSObject

+ (NSString *)pathForType:(CLPathType)pathType;
+ (NSString *)pathForType:(CLPathType)pathType directory:(NSString *)directory;
+ (NSString *)pathForType:(CLPathType)pathType directory:(NSString *)directory fileName:(NSString *)fileName;

+ (instancetype)pathManagerWithFileFolder:(NSString *)fileFolder;
+ (instancetype)pathManagerWithType:(CLPathType)pathType andFileFolder:(NSString *)fileFolder;

- (id)initWithFileFolder:(NSString *)fileFolder;
- (id)initWithType:(CLPathType)pathType andFileFolder:(NSString *)fileFolder;

@property(nonatomic) CLPathType pathType;
@property(nonatomic,strong) NSString *fileFolder;

- (NSString *)path;
- (NSString *)pathForFile:(NSString *)fileName;
- (NSString *)pathForDirectory:(NSString *)DirectoryName;


@end

