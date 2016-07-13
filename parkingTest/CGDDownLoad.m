//
//  CGDDownLoad.m
//  Movie
//
//  Created by 王新辉 on 15/9/29.
//  Copyright (c) 2015年 王新辉. All rights reserved.
//

#import "CGDDownLoad.h"

@implementation CGDDownLoad

+(void)downloadWithURLStr:(NSString *)urlStr andCallBack:(CallBack)callBack{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError * error=nil;
        NSData * data=[NSData dataWithContentsOfURL:[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]options:NSDataReadingUncached error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            callBack(data,error);
        });
    });
}

@end

















