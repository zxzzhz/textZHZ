//
//  ZHZCZViewController.h
//  parkingTest
//
//  Created by zhanghangzhen on 16/2/16.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BackValue<NSObject>
//回传数据的协议方法
-(void)backValue:(UIColor *)string;
@end

@interface ZHZCZViewController : UIViewController

@property(nonatomic,weak)id<BackValue>delegate;
@property(nonatomic,copy)void (^block)(UIColor *);
@end
