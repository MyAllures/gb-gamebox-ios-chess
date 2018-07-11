//
//  CLDocumentCachePool.h
//  TaskTracking
//
//  Created by jinguihua on 2017/2/22.
//  Copyright © 2017年 jinguihua. All rights reserved.
//

#import "CLBasicFileCachePool.h"

@interface CLDocumentCachePool : CLBasicFileCachePool
//共享的文档缓存池
+ (CLDocumentCachePool *)sharePool;
//共享的临时文件缓冲池
+ (CLDocumentCachePool *)shareTempCachePool;

////缓存图片和读取图片
//- (void)cacheImage:(UIImage *)image forKey:(NSString *)key async:(BOOL)async;
//- (UIImage *)cacheImageForKey:(NSString *)key;

//缓存对象（通过持续化方法）
- (void)cacheKeyedArchiverDataWithRootObject:(id<NSCoding>)object
                                      forKey:(NSString *)key
                                       async:(BOOL)async;

//读取缓存的对象
- (id)cacheKeyedUnArchiverRootObjectForKey:(NSString *)key;
- (id)cacheKeyedUnArchiverRootObjectForKey:(NSString *)key expectType:(Class)expectType;

@end
