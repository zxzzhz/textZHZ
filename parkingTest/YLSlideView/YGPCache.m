//
//  YGPCache.m
//  cache
//
//  Created by apple on 15/12/21.
//  Copyright © 2015年 nandu. All rights reserved.
//

#import "YGPCache.h"
#import <CommonCrypto/CommonDigest.h>
#import <UIKit/UIKit.h>

static char       *const YGPCacheDiskIOQueue            = "YGPCacheDiskIOQueue";
static char       *const YGPCacheMemoryIOQueue          = "YGPCacheMemoryIOQueue";
static NSString   *const YGPCacheDirectoryName          = @"YLCache";
static NSUInteger  const YGPCacheCacheMemoryObjLimit    = 35; //max count
static NSString   *const YGPCacheAttributeListName      = @"YGPCacheAttributeList";

static inline NSString *YGPCacheMD5(NSString *key){
    
    const char *cStr = [key UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *res = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    
    for (int i = 0; i<CC_MD5_DIGEST_LENGTH; i++){
        [res appendFormat:@"%02x",digest[i]];
    }
    
    return res;
}

@interface YGPCache()

@property (nonatomic,strong) NSFileManager    *fileManager;
@property (nonatomic,copy)   NSString         *cacheDiskPath;
@property (nonatomic,strong) dispatch_queue_t diskIoQueue;
@property (nonatomic,strong) dispatch_queue_t memoryIoQueue;
@property (nonatomic,strong) YGPMemoryCache   *memoryCache;


- (NSString*)ygp_CacheDirectory:(NSString*)cacheDirectory;
- (void)ygp_initMethodWithCacheDirectory:(NSString*)cacheDirectory;

@end

@implementation YGPCache

#pragma mark init
+ (instancetype)sharedManager{

    static YGPCache *_ygp_YGPCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _ygp_YGPCache = [[YGPCache alloc]init];
    });

    return _ygp_YGPCache;
}

- (instancetype)init{
   return [self initWithCacheDirectory:YGPCacheDirectoryName];
}

- (instancetype)initWithCacheDirectory:(NSString*)cacheDirectory{

    self = [super init];
    
    if (self) {
        [self ygp_initMethodWithCacheDirectory:cacheDirectory];
    }
    return self;
}

- (void)ygp_initMethodWithCacheDirectory:(NSString*)cacheDirectory{
    
    _cacheDiskPath = [[self ygp_CacheDirectory:cacheDirectory] copy];
    _diskIoQueue   = dispatch_queue_create(YGPCacheDiskIOQueue, DISPATCH_QUEUE_SERIAL);
    _memoryIoQueue = dispatch_queue_create(YGPCacheMemoryIOQueue, DISPATCH_QUEUE_SERIAL);
    _memoryCache   = [[YGPMemoryCache alloc]init];
    
    [[NSNotificationCenter defaultCenter]addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * __unused note) {
        [_memoryCache removeAllData];
    }];
    
    [[NSNotificationCenter defaultCenter]addObserverForName:UIApplicationWillTerminateNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * __unused note) {
        [_memoryCache removeAllData];
    }];
    
    [[NSNotificationCenter defaultCenter]addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * __unused note) {
        [_memoryCache removeAllData];
    }];
    
    [self setTimeoutInterval:60*60*24*2];
    
    [self clearTimeoutDiskFile];
}


- (NSString*)ygp_CacheDirectory:(NSString*)cacheDirectory{

    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *ygp_cachePath = [docDir stringByAppendingPathComponent:cacheDirectory];
    
    NSLog(@"path %@",ygp_cachePath);
    
    self.fileManager = [[NSFileManager alloc]init];
    BOOL isDir       = false;
    
    if (![_fileManager fileExistsAtPath:ygp_cachePath isDirectory:&isDir]) {
        
        NSError *error = nil;
        
        BOOL res = [_fileManager createDirectoryAtPath:ygp_cachePath
                           withIntermediateDirectories:YES
                                            attributes:nil
                                                 error:&error];
        
        if (!res) {
            NSLog(@"创建文件目录失败 %@",error);
        }
    }
    
    return ygp_cachePath;
}

- (NSString*)ygp_filePathWithKey:(NSString*)key{
    NSString *path = [NSString stringWithFormat:@"%@/%@",_cacheDiskPath,key];
    return path;
}

#pragma mark Disk add get remove
- (void)setDataToDiskWithData:(NSData*)data
                       forKey:(NSString*)key{
   
    NSAssert(data || data.length > 0, @"The cached data is nil ");
    NSAssert(key.length > 0, @"The cached key error");

    dispatch_async(self.diskIoQueue, ^{
        
        BOOL      isCacheSuccess;
        NSData   *writeData    = data;
        NSString *path         = [self ygp_filePathWithKey:YGPCacheMD5(key)];
        
        isCacheSuccess  = [writeData writeToFile:path atomically:YES];
        
        [self addTimeoutListForKey:YGPCacheMD5(key)];
        
    });
}


- (void)dataFromDiskForKey:(NSString*)key
                     block:(YGPCacheDataCacheObjectBlock)block{
    
   
    NSAssert(key.length > 0, @"The cached key error");
    
    dispatch_async(self.diskIoQueue, ^{
    
        NSData *cacheData = nil;
        
        // Memory cache data
        // 查看内存中
        cacheData = [_memoryCache objectForKey:key];
       
        if (cacheData) {
            
            if (block){
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(cacheData,key);
                });
            }
        }else{
            
            NSString *path = [self ygp_filePathWithKey:YGPCacheMD5(key)];
            
            if ([_fileManager fileExistsAtPath:path]) {
                cacheData = [NSData dataWithContentsOfFile:path options:0 error:nil];
            }
            
            // data write the memory
            if (cacheData) {
                [_memoryCache setData:cacheData forKey:key];
            }
           
            if (block){
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(cacheData,key);
                   
                });
            }
        }
    });
}

- (void)removeDiskCacheDataForKey:(NSString *)key{
    
    NSAssert(key.length > 0, @"The cached key error");
    
    dispatch_async(self.diskIoQueue, ^{
        
        [_fileManager removeItemAtPath:YGPCacheMD5(key) error:nil];
        [self removeMemoryCacheDataForKey:YGPCacheMD5(key)];
        
    });
}

- (void)removeDiskAllData{

    dispatch_async(self.diskIoQueue, ^{
        
        NSDirectoryEnumerator * fileEnumerator = [_fileManager enumeratorAtPath:_cacheDiskPath];
        
        for (NSString *fileName in fileEnumerator) {
            [_fileManager removeItemAtPath:fileName error:nil];
        }
        
    });
}

- (BOOL)isDataExistOnDiskForKey:(NSString *)key{
    
    __block BOOL isContains  = NO;
    dispatch_sync(self.diskIoQueue, ^{
        
        NSString *path = [self ygp_filePathWithKey:YGPCacheMD5(key)];
        if ([_fileManager fileExistsAtPath:path]) {
            isContains = YES;
        }
    });
    
    return isContains;
}

#pragma mark Memory add get remove
- (void)setDataToMemoryWithData:(NSData*)data
                         forKey:(NSString*)key{

    [self.memoryCache setData:data forKey:key];
}

- (void)dataFromMemoryForKey:(NSString*)key
                         block:(YGPCacheDataCacheObjectBlock)block{
    
    NSAssert(key.length > 0, @"The cached key error");
    
    dispatch_async(_memoryIoQueue, ^{
        
        [self dataFromDiskForKey:key block:^(NSData *data ,NSString *akey) {
            
            if (block) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(data,akey);
                });
            }
        }];

    });
}

- (void)removeMemoryCacheDataForKey:(NSString*)key{
    [_memoryCache removeDataForKey:key];
}

- (void)removeMemoryAllData{
    [_memoryCache removeAllData];
}

- (BOOL)containsMemoryObjectForKey:(NSString *)key{
    return [_memoryCache containsDataForKey:key];
}

#pragma mark 

- (float)diskCacheSize{

    __block float folderSize = 0;
    
    if (![_fileManager fileExistsAtPath:_cacheDiskPath])
        return 0;
    
    dispatch_sync(self.diskIoQueue, ^{
        
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtPath:_cacheDiskPath];
        
        for (NSString *fileName in fileEnumerator) {
            
            NSString *filePath = [_cacheDiskPath stringByAppendingPathComponent:fileName];
            folderSize += [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize];

        }
    });
    
    return folderSize / (1024.0 * 1024.0); //Mb
}

- (NSUInteger)diskCacheFileCount{

    __block NSUInteger fileCount = 0;
  
    dispatch_sync(self.diskIoQueue, ^{
  
        NSDirectoryEnumerator *fileEnumerator = [_fileManager enumeratorAtPath:_cacheDiskPath];
        fileCount = [[fileEnumerator allObjects] count];
        
    });
    
   return fileCount;
}
+ (NSData*)dataWithObject:(id)object{

    return [NSKeyedArchiver archivedDataWithRootObject:object];
}

+ (id)objectWithData:(NSData*)data{
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

#pragma mark TimeoutList

- (NSMutableDictionary*)getTimeoutList{

    __block NSData *cacheListData  = nil;
    NSMutableDictionary *cacheList = nil;
    NSString * filePath = [self ygp_filePathWithKey:YGPCacheAttributeListName];
    cacheListData = [NSData dataWithContentsOfFile:filePath
                                           options:0
                                             error:nil];
    
    if (!cacheListData) {
        cacheList = [[NSMutableDictionary alloc]init];
    }else{
        cacheList = [[NSJSONSerialization JSONObjectWithData:cacheListData
                                                    options:kNilOptions
                                                      error:nil] mutableCopy];
    }
    
    return cacheList;
    
}

- (void)addTimeoutListForKey:(NSString*)key{

    //每次添加缓存数据的将在缓存列表中添加一个时间戳
    
    NSTimeInterval now = [[NSDate date] timeIntervalSinceReferenceDate];

    NSMutableDictionary *cacheList = [[NSMutableDictionary alloc]init];
    [cacheList addEntriesFromDictionary:[self getTimeoutList]];
    
    [cacheList setObject:[NSString stringWithFormat:@"%f",now] forKey:key];
    
    [self cacheTimeListForData:cacheList];

}

- (void)clearTimeoutDiskFile{

    
    NSTimeInterval now             = [[NSDate date] timeIntervalSinceReferenceDate];
    NSMutableArray *timeoutKeys    = [[NSMutableArray alloc]init];
    NSMutableDictionary *cacheList = [[NSMutableDictionary alloc]init];
    
    [cacheList addEntriesFromDictionary:[self getTimeoutList]];
    
    for (NSString *key in cacheList) {
        
        if (([cacheList[key] doubleValue] - now) >= _timeoutInterval) {
            [[NSFileManager defaultManager] removeItemAtPath:cacheList[key] error:nil];
            [timeoutKeys addObject:key];
           
        }
    }
    
    [cacheList removeObjectsForKeys:timeoutKeys];
    [self cacheTimeListForData:cacheList];
    
}

- (void)cacheTimeListForData:(NSMutableDictionary*)dict{

    NSData *cacheListData = [NSJSONSerialization dataWithJSONObject:dict
                                                            options:NSJSONWritingPrettyPrinted
                                                              error:nil];
    
    [cacheListData writeToFile:[self ygp_filePathWithKey:YGPCacheAttributeListName] atomically:YES];
}


@end

#pragma mark memory cache
@interface YGPMemoryCacheNode :NSObject
@property (nonatomic,copy)   NSString       *key;
@property (nonatomic,assign) NSTimeInterval accessedTime;
@property (nonatomic,assign) NSUInteger     accessedCount;
@end

@implementation YGPMemoryCacheNode

- (instancetype)initWithKey:(NSString*)key forAccessedCount:(NSUInteger)AccessedCount{

    self = [super init];
    
    if (self) {
        _key               = [key copy];
        _accessedCount     = AccessedCount;
        NSTimeInterval now = [[NSDate date] timeIntervalSinceReferenceDate];
        _accessedTime      = now;
        
    }
    return self;
}
@end

static inline YGPMemoryCacheNode *memoryCacheNode(NSString *key,NSUInteger accessedCount){

    YGPMemoryCacheNode * cacheNode = [[YGPMemoryCacheNode alloc]initWithKey:key
                                                           forAccessedCount:accessedCount];

    return cacheNode;
}

@interface YGPMemoryCache()
{
    NSMutableDictionary *_cacheData;
    NSMutableArray      *_recentlyAccessedKeys;
    NSMutableDictionary *_recentlyNode;
    NSTimeInterval       _recentlyHandleTime;
    NSUInteger           _minAccessedCount;
}
@property (nonatomic,strong) dispatch_queue_t memoryIoQueue;
@end


@implementation YGPMemoryCache

+ (instancetype)sharedManager{
    
    static YGPMemoryCache *_ygp_YGPMemoryCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _ygp_YGPMemoryCache = [[YGPMemoryCache alloc]init];
    });
    return _ygp_YGPMemoryCache;
}

- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        _cacheData            = [[NSMutableDictionary alloc]init];
        _recentlyNode         = [[NSMutableDictionary alloc]init];
        _recentlyAccessedKeys = [[NSMutableArray alloc]init];
        _recentlyHandleTime   = [[NSDate date] timeIntervalSinceReferenceDate];
        _minAccessedCount     = 1;
        _memoryCacheCountLimit = YGPCacheCacheMemoryObjLimit;
        _memoryIoQueue         = dispatch_queue_create(YGPCacheMemoryIOQueue, DISPATCH_QUEUE_SERIAL);
        
        
    }
    return self;
}

- (void)setData:(NSData*)data forKey:(NSString*)key{

    NSAssert(data || data.length > 0, @"The cached data is nil ");
    NSAssert(key.length > 0, @"The cached key error");
    
    dispatch_async(_memoryIoQueue, ^{
        
       [_cacheData setObject:data forKey:YGPCacheMD5(key)];
        
    });
    
}

- (NSData*)objectForKey:(NSString*)key{
    
     NSAssert(key.length > 0, @"The cached key error");
    
    __block NSData *cacheData = nil;
    
    dispatch_sync(_memoryIoQueue, ^{
        
        [self timeoutObjForKey:key];
        
        cacheData = _cacheData[YGPCacheMD5(key)];
        
    });
    
    return cacheData;
}

- (void)removeAllData{
    
    dispatch_async(_memoryIoQueue, ^{
    
        [_cacheData            removeAllObjects];
        [_recentlyAccessedKeys removeAllObjects];
        [_recentlyNode         removeAllObjects];
    });
}

- (void)removeDataForKey:(NSString*)key{

     NSAssert(key.length > 0, @"The cached key error");
    
    dispatch_async(_memoryIoQueue, ^{
        
        [_cacheData removeObjectForKey:YGPCacheMD5(key)];
        if ([_recentlyAccessedKeys containsObject:YGPCacheMD5(key)]) {
            [_recentlyAccessedKeys removeObject:YGPCacheMD5(key)];
            [_recentlyNode         removeObjectForKey:YGPCacheMD5(key)];
        }
    });
}

- (BOOL)containsDataForKey:(NSString*)key{

    __block BOOL isContains = NO;
    
    dispatch_sync(_memoryIoQueue, ^{
        if (_cacheData[YGPCacheMD5(key)]) {
            isContains = YES;
        }
    });
    
    return isContains;
}

- (void)timeoutObjForKey:(NSString*)key{

    /*
     
     获取一个缓存数据，就将其移动到队列的最顶端，队列内越后的数据就是调用得最少次的
     设置一个内存LIMIT 最大值，当缓存数据超过了最大值。每次有新的数据进入列队，就会讲
     列队的最后一个缓存数据移除掉。
     
     每个缓存数据都会组建成一个结构体 里面包含 （访问次数 ，访问时间）
     每隔3分钟的时候就会去调用 队列  将访问次数最小和访问时间离现在最久的数据将其出列
     
     */
    
    YGPMemoryCacheNode *node = nil;
    
    if ([_recentlyAccessedKeys containsObject:YGPCacheMD5(key)]) {
        [_recentlyAccessedKeys removeObject:YGPCacheMD5(key)];
        
        node = _recentlyNode[YGPCacheMD5(key)];
        [_recentlyNode removeObjectForKey:YGPCacheMD5(key)];
    }
    
    [_recentlyAccessedKeys insertObject:YGPCacheMD5(key) atIndex:0];
    
    //增加内存访问的计时和时间
    NSUInteger accessedCount = 1;
    if (node)accessedCount   = node.accessedCount+1;
    
    //获取最小的访问数
    if (accessedCount < _minAccessedCount) _minAccessedCount = accessedCount;
    
    [_recentlyNode setObject:memoryCacheNode(YGPCacheMD5(key), accessedCount) forKey:YGPCacheMD5(key)];
    
    //移除近期不访问
    if (_recentlyAccessedKeys.count >= YGPCacheCacheMemoryObjLimit) {
        NSString *lastObjKey = [_recentlyAccessedKeys lastObject];
        [_cacheData    removeObjectForKey:lastObjKey];
        [_recentlyNode removeObjectForKey:lastObjKey];
    }

    //remove timeout data
    NSTimeInterval now     = [[NSDate date] timeIntervalSinceReferenceDate];
    NSTimeInterval timeout = 60 * 5;
    
    if ((now - _recentlyHandleTime) > timeout) {
        
        [_recentlyNode enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            YGPMemoryCacheNode *node = (YGPMemoryCacheNode*)obj;
            
            if ((now - node.accessedTime) >= timeout && node.accessedCount <= _minAccessedCount) {
                
                [_cacheData            removeObjectForKey:key];
                [_recentlyNode         removeObjectForKey:key];
                [_recentlyAccessedKeys removeObject:key];
                
            }
        }];
    }
    
    _recentlyHandleTime = now;
}

@end










// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com