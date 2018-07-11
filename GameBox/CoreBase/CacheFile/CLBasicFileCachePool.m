//
//  CLBasicFileCachePool.m
//  TaskTracking
//
//  Created by jinguihua on 2017/2/22.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "CLBasicFileCachePool.h"
#import "help.h"
#import "UIImage+Representation.h"
//----------------------------------------------------------

NSString * const MyFileCacheRootFileFloderName = @"__MyFileCache__";

//----------------------------------------------------------


@implementation CLBasicFileCachePool


#pragma mark -

+ (NSString *)defaultCacheFileFloderName {
    return nil;
}

+ (NSString *)cacheRootFileFloderName {
    return nil;
}

#pragma mark -

- (id)init {
    return [self initWithPathType:CLPathTypeCaches andCacheFileFloderName:nil];
}

- (id)initWithPathType:(CLPathType)pathType {
    return [self initWithPathType:pathType andCacheFileFloderName:nil];
}

- (id)initWithPathType:(CLPathType)pathType andCacheFileFloderName:(NSString *)cacheFileFloderName
{
    if ([self isMemberOfClass:[CLBasicFileCachePool class]]) {
        @throw [NSException exceptionWithName:NSGenericException
                                       reason:@"CLBasicFileCachePool为抽象类不允许初始化"
                                     userInfo:nil];
    }

    self = [super init];

    if (self) {
        _pathType = pathType;
        _cacheFileFloderName = [(cacheFileFloderName.length ? [cacheFileFloderName copy] : [[self class] defaultCacheFileFloderName]) copy];
    }

    return self;
}

#pragma mark -

+ (NSString *)cacheFileFloderPathForType:(CLPathType)pathType withCacheFileFloderName:(NSString *)cacheFileFloderName
{
    return [[CLPathManager pathManagerWithType:pathType andFileFolder:[MyFileCacheRootFileFloderName stringByAppendingPathComponent:[self cacheRootFileFloderName]]] pathForDirectory:cacheFileFloderName];
}

- (NSString *)cacheFileFloderPath
{
    return [[self class] cacheFileFloderPathForType:self.pathType withCacheFileFloderName:self.cacheFileFloderName];
}

+ (NSString *)cacheFileNameForKey:(NSString *)key {
    return key ? hashStrWithStr(key, HashFuncType_MD5) : nil;
}

- (NSString *)createCacheFilePathForKey:(NSString *)key
{
    NSString * fileName = [[self class] cacheFileNameForKey:key];
    return fileName.length ? [self.cacheFileFloderPath stringByAppendingPathComponent:fileName] : nil;
}

#pragma mark -

+ (dispatch_queue_t)cacheFileHandleQueue
{
    static dispatch_queue_t defaultCacheFileHandleQueue = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultCacheFileHandleQueue = dispatch_queue_create("CLBasicFileCachePool.defaultCacheFileHandleQueue", DISPATCH_QUEUE_CONCURRENT);
    });

    return defaultCacheFileHandleQueue;
}

- (NSString *)cacheData:(NSData *)data
{
    NSString * key = getUniqueID();
    [self cacheData:data forKey:key async:NO blockQueue:nil completedBlock:nil];
    return key;
}

- (void)cacheData:(NSData *)data forKey:(NSString *)key async:(BOOL)async {
    [self cacheData:data forKey:key async:async blockQueue:nil completedBlock:nil];
}

- (void)cacheData:(NSData *)data forKey:(NSString *)key async:(BOOL)async blockQueue:(NSOperationQueue *)blockQueue completedBlock:(void (^)(BOOL))completedBlock
{
    if (data == nil || key == nil) {
        @throw [[NSException alloc] initWithName:NSInvalidArgumentException
                                          reason:@"data和key不能为nil"
                                        userInfo:nil];
    }

    //生成回调block的队列
    if (completedBlock && async && blockQueue == nil) {
        blockQueue = [NSOperationQueue currentQueue];
    }

    __block BOOL success = NO;
    void (^block)()  = ^{
        success = [data writeToFile:[self createCacheFilePathForKey:key] atomically:YES];

        if (async && completedBlock) { //异步回调
            [blockQueue addOperationWithBlock:^{
                completedBlock(success);
            }];
        }
    };

    if (async) {
        dispatch_barrier_async([[self class] cacheFileHandleQueue], block);
    }else {
        dispatch_barrier_sync([[self class] cacheFileHandleQueue], block);

        if (completedBlock) { //同步回调
            completedBlock(success);
        }
    }
}

- (NSString *)cacheDataWithFilePath:(NSString *)path
{
    NSString * key = getUniqueID();
    [self cacheDataWithFilePath:path forKey:key async:NO blockQueue:nil completedBlock:nil];
    return key;
}

- (void)cacheDataWithFilePath:(NSString *)path forKey:(NSString *)key async:(BOOL)async {
    [self cacheDataWithFilePath:path forKey:key async:async blockQueue:nil completedBlock:nil];
}

- (void)cacheDataWithFilePath:(NSString *)path
                       forKey:(NSString *)key
                        async:(BOOL)async
                   blockQueue:(NSOperationQueue *)blockQueue
               completedBlock:(void (^)(BOOL))completedBlock
{
    if (path.length == 0 || key == nil) {
        @throw [[NSException alloc] initWithName:NSInvalidArgumentException
                                          reason:@"path和key不能为nil"
                                        userInfo:nil];
    }

    //生成回调block的队列
    if (completedBlock && async && blockQueue == nil) {
        blockQueue = [NSOperationQueue currentQueue];
    }

    __block NSError * error = nil;
    void (^block)()  = ^{
        [[NSFileManager defaultManager] copyItemAtPath:path
                                                toPath:[self createCacheFilePathForKey:key]
                                                 error:&error];
        if (error) {
            NSLog(@"缓存文件失败 error = %@",error);
        }

        if (async && completedBlock) { //异步回调
            [blockQueue addOperationWithBlock:^{
                completedBlock(error != nil);
            }];
        }
    };

    if (async) {
        dispatch_barrier_async([[self class] cacheFileHandleQueue],block);
    }else{
        dispatch_barrier_sync([[self class] cacheFileHandleQueue],block);

        if (completedBlock) { //同步回调
            completedBlock(error != nil);
        }
    }
}

- (NSString *)cacheImageToFile:(UIImage *)image
{
    NSString * imagekey = getUniqueID();
    [self cacheImageToFile:image key:imagekey async:NO blockQueue:nil completedBlock:nil];
    return imagekey;
}

- (void)cacheImageToFile:(UIImage *)image forKey:(NSString *)key async:(BOOL)async {
    [self cacheImageToFile:image key:key async:async blockQueue:nil completedBlock:nil];
}

- (void)cacheImageToFile:(UIImage *)image
                     key:(NSString *)key
                   async:(BOOL)async
              blockQueue:(NSOperationQueue *)blockQueue
          completedBlock:(void(^)(NSString * path))completedBlock
{
    if (image == nil || key.length == 0) {
        @throw [[NSException alloc] initWithName:NSInvalidArgumentException
                                          reason:@"image或key不能为nil"
                                        userInfo:nil];
    }

    //生成回调block的队列
    if (completedBlock && async && blockQueue == nil) {
        blockQueue = [NSOperationQueue currentQueue];
    }

    __block BOOL success = NO;
    __block NSString * path = nil;
    void (^block)()  = ^{

        //生成路径并写入
        path = [self createCacheFilePathForKey:key];
        success = [[image representationData:1.f] writeToFile:path atomically:YES];

        if (async && completedBlock) { //异步回调
            [blockQueue addOperationWithBlock:^{
                if (success) {
                    completedBlock(path);
                }else {
                    completedBlock(nil);
                }
            }];
        }
    };

    if (async) {
        dispatch_barrier_async([[self class] cacheFileHandleQueue], block);
    }else {
        dispatch_barrier_sync([[self class] cacheFileHandleQueue], block);

        if (completedBlock) { //同步回调
            if (success) {
                completedBlock(path);
            }else {
                completedBlock(nil);
            }
        }
    }
}

- (NSString *)cacheFilePathForKey:(NSString *)key
{
    if(key) {

        __block NSString * filePath = [self createCacheFilePathForKey:key];
        dispatch_sync([[self class] cacheFileHandleQueue],^{
            if (!fileExistAtPath(filePath)) {
                filePath = nil;
            }
        });

        return filePath;
    }

    return nil;
}

- (NSURL *)cacheFileURLForKey:(NSString *)key
{
    NSString * path = [self cacheFilePathForKey:key];

    if (path.length) {
        return [NSURL fileURLWithPath:path];
    }else {
        return nil;
    }
}

- (NSData *)cacheFileDataForKey:(NSString *)key
{
    __block NSData * data = nil;

    NSString * filePath = [self cacheFilePathForKey:key];

    if (filePath) {
        dispatch_sync([[self class] cacheFileHandleQueue], ^{
            data = [NSData dataWithContentsOfFile:filePath];
        });
    }

    return data;
}

- (BOOL)hadCacheFileForKey:(NSString *)key {
    return [self cacheFilePathForKey:key] != nil;
}

- (void)removeCacheFileForKey:(NSString *)key async:(BOOL)async {
    [self removeCacheFileForPath:[self cacheFilePathForKey:key] async:async];
}

- (void)removeCacheFileForPath:(NSString *)path async:(BOOL)async
{
    if (path.length) {

        void (^block)()  = ^{
            [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
        };

        if (async) {
            dispatch_barrier_async([[self class] cacheFileHandleQueue], block);
        }else {
            dispatch_barrier_sync([[self class] cacheFileHandleQueue], block);
        }
    }
}

#pragma mark -

- (void)cacheFilesSizeWithCallBackBlock:(void(^)(long long))callBackBlock
{
    [[self class] cacheFilesSizeWithPathType:self.pathType
                         cacheFileFloderName:self.cacheFileFloderName
                               callBackBlock:callBackBlock];
}

- (long long)cacheFilesSize
{
    return [[self class] cacheFilesSizeWithPathType:self.pathType
                                cacheFileFloderName:self.cacheFileFloderName];
}

- (void)clearCacheFilesWithCompletedBlock:(void (^)())completedBlock
{
    [[self class] clearCacheFilesWithPathType:self.pathType
                          cacheFileFloderName:self.cacheFileFloderName
                               completedBlock:completedBlock];
}

- (void)clearCacheFiles
{
    [[self class] clearCacheFilesWithPathType:self.pathType
                          cacheFileFloderName:self.cacheFileFloderName];
}

#pragma mark -

+ (void)cacheFilesSizeWithPathType:(CLPathType)pathType
               cacheFileFloderName:(NSString *)cacheFileFloderName
                     callBackBlock:(void (^)(long long))callBackBlock
{
    if (callBackBlock) {

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            long long size = [self cacheFilesSizeWithPathType:pathType cacheFileFloderName:cacheFileFloderName];

            dispatch_async(dispatch_get_main_queue(), ^{
                callBackBlock(size);
            });
        });
    }
}

+ (long long)cacheFilesSizeWithPathType:(CLPathType)pathType cacheFileFloderName:(NSString *)cacheFileFloderName
{
    __block long long size = 0;

    dispatch_barrier_sync([[self class] cacheFileHandleQueue],^{
        size = folderSizeAtPath([self cacheFileFloderPathForType:pathType withCacheFileFloderName:cacheFileFloderName]);
    });

    return size;
}

+ (void)allCacheFilesSizeWithCallBackBlock:(void (^)(long long))callBackBlock
{
    if (callBackBlock) {

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            long long size = [self allCacheFilesSize];
            dispatch_async(dispatch_get_main_queue(), ^{
                callBackBlock(size);
            });
        });
    }
}

+ (long long)allCacheFilesSize
{
    __block long long size = 0;
    [self _emumAllExistsRootCacheFileFloderDoSomeThing:^(NSString *path, BOOL *stop) {
        dispatch_barrier_sync([[self class] cacheFileHandleQueue],^{
            size += folderSizeAtPath(path);
        });
    }];

    return size;
}

+ (void)_emumAllExistsRootCacheFileFloderDoSomeThing:(void(^)(NSString * path, BOOL * stop))block
{
    for (CLPathType pathType = 0; pathType < CLPathTypeCount; pathType ++) {

        NSString * path = [[CLPathManager pathForType:pathType] stringByAppendingPathComponent:[MyFileCacheRootFileFloderName stringByAppendingPathComponent:[self cacheRootFileFloderName]]];

        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {

            BOOL stop = NO;

            block(path,&stop);

            if (stop) {
                break;
            }
        }
    }
}

+ (void)clearCacheFilesWithPathType:(CLPathType)pathType
                cacheFileFloderName:(NSString *)cacheFileFloderName
                     completedBlock:(void (^)())completedBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self clearCacheFilesWithPathType:pathType cacheFileFloderName:cacheFileFloderName];

        if (completedBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completedBlock();
            });
        }
    });
}

+ (void)clearCacheFilesWithPathType:(CLPathType)pathType
                cacheFileFloderName:(NSString *)cacheFileFloderName
{
    dispatch_barrier_sync([[self class] cacheFileHandleQueue],^{
        removeItemAtPath([self cacheFileFloderPathForType:pathType withCacheFileFloderName:cacheFileFloderName], NO);
    });
}

+ (void)clearAllCacheFilesWithCompletedBlock:(void (^)())completedBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self clearAllCacheFiles];

        if (completedBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completedBlock();
            });
        }
    });
}

+ (void)clearAllCacheFiles
{
    [self _emumAllExistsRootCacheFileFloderDoSomeThing:^(NSString *path, BOOL *stop) {
        dispatch_barrier_sync([[self class] cacheFileHandleQueue],^{
            removeItemAtPath(path, NO);
        });
    }];
}


@end

