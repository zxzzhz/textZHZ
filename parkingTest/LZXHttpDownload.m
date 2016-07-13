//
//  LZXHttpDownload.m
//  SNSDemo
//
//  Created by lzxuan on 15/9/21.
//  Copyright (c) 2015年 lzxuan. All rights reserved.
//

#import "LZXHttpDownload.h"

@implementation LZXHttpDownload
- (instancetype)init {
    if (self = [super init]) {
        //创建空对象
        self.downloadData = [[NSMutableData alloc] init];
    }
    return self;
}
//下载的时候把 block代码 提前传入
- (void)downloadDataWithUrl:(NSString *)urlStr successBlock:(DownloadBlock)block failedBlock:(ErrorBlock)errorBlock {
    
    if (_httpRequest) {
        //取消以前的下载
        [_httpRequest cancel];
        _httpRequest = nil;
    }
    //要立即保存block
    self.successBlock = block;
    self.errorBlock = errorBlock;
    
    //url请求
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    //异步下载请求连接
    _httpRequest = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //一旦创建就会立即异步下载
    //每次下载 都要重新 创建 新的连接请求
}
//接收到响应
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //把之前的数据 清空
    self.downloadData.length = 0;
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //拼接 下载的数据
    [self.downloadData appendData:data];
}
//下载完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //下载完成 之后 通知回调block
    if (self.successBlock) {
        //回调block
        self.successBlock(self.downloadData);
    }else {
        NSLog(@"block没有传入");
    }
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"下载失败");
    //下载失败 通知block
    if (self.errorBlock) {
        self.errorBlock(error);
    }
}

@end









