//
//  CLPathManager.m
//  TaskTracking
//
//  Created by jinguihua on 2017/2/22.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "CLPathManager.h"
#import "help.h"

@implementation CLPathManager

#pragma mark -

+ (NSString *)pathForType:(CLPathType)pathType
{
    switch (pathType) {

        case CLPathTypeDocument:
            return  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
            break;

        case CLPathTypeLibrary:
            return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
            break;

        case CLPathTypeCaches:
            return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
            break;

        case CLPathTypeTemp:
            return NSTemporaryDirectory();
            break;

        default:
            return nil;
            break;
    }
}

+ (NSString *)pathForType:(CLPathType)pathType directory:(NSString *)directory
{
    NSString * path = [self pathForType:pathType];
    if (directory.length) {
        path = [path stringByAppendingPathComponent:directory];
    }

    return makeSrueDirectoryExist(path) ? path : nil;
}

+ (NSString *)pathForType:(CLPathType)pathType directory:(NSString *)directory fileName:(NSString *)fileName
{
    NSString * path = [self pathForType:pathType directory:directory];
    return [path stringByAppendingPathComponent:fileName];
}

#pragma mark -

+ (instancetype)pathManagerWithFileFolder:(NSString *)fileFolder {
    return [[CLPathManager alloc] initWithFileFolder:fileFolder];
}

+ (instancetype)pathManagerWithType:(CLPathType)pathType andFileFolder:(NSString *)fileFolder{
    return [[CLPathManager alloc] initWithType:pathType andFileFolder:fileFolder];
}

- (id)init {
    return [self initWithType:CLPathTypeDocument andFileFolder:nil];
}

- (id)initWithFileFolder:(NSString *)fileFolder{
    return [self initWithType:CLPathTypeDocument andFileFolder:fileFolder];
}

- (id)initWithType:(CLPathType)pathType andFileFolder:(NSString *)fileFolder
{
    self = [super init];
    if (self) {
        _pathType = pathType;
        _fileFolder = fileFolder;
    }

    return self;
}

#pragma mark -

- (NSString *)path {
    return [[self class] pathForType:self.pathType directory:self.fileFolder];
}

- (NSString *)pathForFile:(NSString *)fileName {
    return [[self class] pathForType:self.pathType directory:self.fileFolder fileName:fileName];
}

- (NSString *)pathForDirectory:(NSString *)DirectoryName
{
    NSString * path = [self pathForFile:DirectoryName];
    return makeSrueDirectoryExist(path) ? path : nil;
}

@end
