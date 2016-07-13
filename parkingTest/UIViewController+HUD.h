//
//  UIViewController+HUD.h
//  Park
//
//  Created by  apple on 15/7/28.
//  Copyright (c) 2015年  apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HUD)

- (void)showHudInView:(UIView *)view hint:(NSString *)hint;

- (void)hideHud;

- (void)showHint:(NSString *)hint;

// 从默认(showHint:)显示的位置再往上(下)yOffset
- (void)showHint:(NSString *)hint yOffset:(float)yOffset;

- (void)showDetailHint:(NSString *)hint yOffset:(float)yOffset;

@end
