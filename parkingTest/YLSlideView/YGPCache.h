//
//  YGPCache.h
//  cache
//
//  Created by apple on 15/12/21.
//  Copyright © 2015年 nandu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class YGPMemoryCache;

typedef void(^YGPCacheDataCacheObjectBlock)(NSData *data ,NSString *key);
typedef void(^YGPCacheDataCacheImageBlock)(UIImage *image,NSString *key);

@interface YGPCache : NSObject

@property (nonatomic,assign)NSTimeInterval timeoutInterval;

+ (instancetype)sharedManager;
- (instancetype)initWithCacheDirectory:(NSString*)cacheDirectory;
/**
 *  stored data to disk
 *
 *  @param data           stored data
 *  @param key            stored key
 *  @param completedBlock stored complete block
 *  @param failureBlock   stored fail block
 */
- (void)setDataToDiskWithData:(NSData*)data
                       forKey:(NSString*)key;

/**
 *  stored data to memory
 *
 *  @param data stored data
 *  @param key  stored key
 */
- (void)setDataToMemoryWithData:(NSData*)data
                         forKey:(NSString*)key;
/**
 *  get stored data form Disk
 *
 *  @param key         stored key
 *  @param objectBlock stored Object
 */
- (void)dataFromDiskForKey:(NSString*)key
                     block:(YGPCacheDataCacheObjectBlock)block;

- (void)dataFromMemoryForKey:(NSString*)key
                       block:(YGPCacheDataCacheObjectBlock)block;


/**
 *  remove data from disk
 *
 *  @param key stored key
 */
- (void)removeDiskCacheDataForKey:(NSString*)key;
- (void)removeDiskAllData;

- (void)removeMemoryCacheDataForKey:(NSString*)key;
- (void)removeMemoryAllData;

/*
 * is cache
 */
- (BOOL)isDataExistOnDiskForKey:(NSString*)key;
- (BOOL)containsMemoryObjectForKey:(NSString*)key;

- (float)diskCacheSize;
- (NSUInteger)diskCacheFileCount;

//对象转成NSData
+ (NSData*)dataWithObject:(id)object;
+ (id)objectWithData:(NSData*)data;
@end

@interface YGPMemoryCache : NSObject
@property (nonatomic,assign)NSUInteger memoryCacheCountLimit;

- (void)setData:(NSData*)data forKey:(NSString*)key;
- (NSData*)objectForKey:(NSString*)key;
- (void)removeDataForKey:(NSString*)key;
- (void)removeAllData;
- (BOOL)containsDataForKey:(NSString*)key;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com