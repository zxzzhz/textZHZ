//
//  ZHZTabBarVC.m
//  parkingTest
//
//  Created by zhanghangzhen on 15/12/29.
//  Copyright © 2015年 zhanghangzhen. All rights reserved.
//

#import "ZHZTabBarVC.h"
#import "ZHZTabBar.h"

#import "ZHZNavitationVC.h"
#import "ZHZMapViewController.h"
#import "ZHZUserViewController.h"
#import "ZHZSettingViewController.h"
#import "ZHZFirstViewController.h"
#import "ZHZTwoViewController.h"






@interface ZHZTabBarVC ()<ZHZTabBarDelegate>

@end

@implementation ZHZTabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加所有的子控制器
    [self addAllChildVcs];
    
    // 创建自定义tabbar
    [self addCustomTabBar];
}
-(void)addCustomTabBar{
    // 创建自定义tabbar
    ZHZTabBar *customTabBar = [[ZHZTabBar alloc] init];
    customTabBar.tabBarDelegate = self;
    // 更换系统自带的tabbar
    [self setValue:customTabBar forKeyPath:@"tabBar"];

}
-(void)addAllChildVcs{
    ZHZFirstViewController *home = [[ZHZFirstViewController alloc] init];
    [self addOneChlildVc:home title:@"首页" imageName:@"tabbar_home" selectedImageName:@"tabbar_home_selected"];
    ZHZUserViewController *message = [[ZHZUserViewController alloc] init];
    [self addOneChlildVc:message title:@"用户" imageName:@"tabbar_message_center" selectedImageName:@"tabbar_message_center_selected"];
    ZHZSettingViewController *discover = [[ZHZSettingViewController alloc] init];
    [self addOneChlildVc:discover title:@"设置" imageName:@"tabbar_discover" selectedImageName:@"tabbar_discover_selected"];
    ZHZMapViewController *profile = [[ZHZMapViewController alloc] init];
    [self addOneChlildVc:profile title:@"地图" imageName:@"tabbar_profile" selectedImageName:@"tabbar_profile_selected"];
    
}

/**
 *  添加一个子控制器
 *
 *  @param childVc           子控制器对象
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)addOneChlildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    // 设置标题
    childVc.title = title;
    
    // 设置图标
    childVc.tabBarItem.image = [UIImage imageWithName:imageName];
    
    // 设置tabBarItem的普通文字颜色
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[UITextAttributeTextColor] = [UIColor blackColor];
    textAttrs[UITextAttributeFont] = [UIFont systemFontOfSize:10];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置tabBarItem的选中文字颜色
    NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
    selectedTextAttrs[UITextAttributeTextColor] = [UIColor orangeColor];
    [childVc.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    
    // 设置选中的图标
    UIImage *selectedImage = [UIImage imageWithName:selectedImageName];
    if (iOS7) {
        // 声明这张图片用原图(别渲染)
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    childVc.tabBarItem.selectedImage = selectedImage;
    
    // 添加为tabbar控制器的子控制器
    ZHZNavitationVC *nav = [[ZHZNavitationVC alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
}


-(void)tabBarDidClickedPlusButton:(ZHZTabBar *)tabBar{

    ZHZTwoViewController *oneVC = [[ZHZTwoViewController alloc]init];
    ZHZNavitationVC *nav = [[ZHZNavitationVC alloc]initWithRootViewController:oneVC];
    [self presentViewController:nav animated:YES completion:^{
        NSLog(@"zhanghanz ");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
