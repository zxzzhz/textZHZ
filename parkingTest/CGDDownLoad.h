//
//  CGDDownLoad.h
//  Movie
//
//  Created by 王新辉 on 15/9/29.
//  Copyright (c) 2015年 王新辉. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef  void (^CallBack)(NSData *,NSError *);
@interface CGDDownLoad : NSObject
+(void)downloadWithURLStr:(NSString *)urlStr andCallBack:(CallBack)callBack;
@end
