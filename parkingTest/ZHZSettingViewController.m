//
//  ZHZSettingViewController.m
//  parkingTest
//
//  Created by zhanghangzhen on 15/12/29.
//  Copyright © 2015年 zhanghangzhen. All rights reserved.
//

#import "ZHZSettingViewController.h"
#import "ZHZJSViewController.h"
#import "MyControl.h"
#import "KVNProgress.h"

#import "ZHZLBQViewController.h"
#import "AnimationView.h"

/**
 *  随机颜色
 */
#define MJRandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]
@interface ZHZSettingViewController ()
{
    AnimationView*
    _animationView;
}
@property(nonatomic,strong)UISwitch*fullscreenSwitch;

@end
 

@implementation ZHZSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
self.view.backgroundColor = [UIColor colorWithRed:1.000 green:0.849 blue:0.301 alpha:1.000];
    
    // 设置导航栏按钮
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithTitle:@"轮播器" style:UIBarButtonItemStylePlain target:self action:@selector(friendSearch)];
    
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"JS交互" style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    NSArray *arr = [NSArray arrayWithObjects:@"基本的",@"基本+状态",@"基本+状态+大",@"状态",@"成功",@"失败",@"自定义", nil];
    for (int i = 0;  i < 7; i++) {
        UIButton *btn = [MyControl creatButtonWithFrame:CGRectMake(100, 100+10+50*i, 200, 48) target:self sel:@selector(pregress:) tag:i image:nil title:arr[i]];
        btn.backgroundColor = MJRandomColor;
        [self.view addSubview:btn];
    }
    _animationView = [[AnimationView alloc] initWithFrame:CGRectMake(0, 150, self.view.bounds.size.width, 120)];
    [self.view addSubview:_animationView];
    
    
    
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    startButton.frame = CGRectMake(10, 400, 100, 50);
    [startButton addTarget:self action:@selector(startAnimation:) forControlEvents:UIControlEventTouchUpInside];
    [startButton setTitle:@"启动动画" forState:UIControlStateNormal];
    [self.view addSubview:startButton];
    
    UIButton *stopButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    stopButton.frame = CGRectMake(110, 400, 100, 50);
    [stopButton addTarget:self action:@selector(stopAnimation:) forControlEvents:UIControlEventTouchUpInside];
    [stopButton setTitle:@"暂停动画" forState:UIControlStateNormal];
    [self.view addSubview:stopButton];
    
    UIButton *resumeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    resumeButton.frame = CGRectMake(210, 400, 100, 50);
    [resumeButton addTarget:self action:@selector(resumeAnimation:) forControlEvents:UIControlEventTouchUpInside];
    [resumeButton setTitle:@"恢复动画" forState:UIControlStateNormal];
    [self.view addSubview:resumeButton];
    
    
}

-(void)startAnimation:(UIButton *)sender
{
    [_animationView startAnimation];
}


-(void)stopAnimation:(UIButton *)sender
{
    [_animationView stopAnimation];
}

-(void)resumeAnimation:(UIButton *)sender
{
    [_animationView resumeAnimation];
}


-(void)friendSearch{

    [self.navigationController pushViewController:[[ZHZLBQViewController alloc]init] animated:YES];
}


- (void)setupBaseKVNProgressUI
{
    // See the documentation of all appearance propoerties
    [KVNProgress appearance].statusColor = [UIColor darkGrayColor];
    [KVNProgress appearance].statusFont = [UIFont systemFontOfSize:17.0f];
    [KVNProgress appearance].circleStrokeForegroundColor = [UIColor darkGrayColor];
    [KVNProgress appearance].circleStrokeBackgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.3f];
    [KVNProgress appearance].circleFillBackgroundColor = [UIColor clearColor];
    [KVNProgress appearance].backgroundFillColor = [UIColor colorWithWhite:0.9f alpha:0.9f];
    [KVNProgress appearance].backgroundTintColor = [UIColor whiteColor];
    [KVNProgress appearance].successColor = [UIColor darkGrayColor];
    [KVNProgress appearance].errorColor = [UIColor darkGrayColor];
    [KVNProgress appearance].circleSize = 75.0f;
    [KVNProgress appearance].lineWidth = 2.0f;
}

- (void)setupCustomKVNProgressUI
{
    // See the documentation of all appearance propoerties
    [KVNProgress appearance].statusColor = [UIColor whiteColor];
    [KVNProgress appearance].statusFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:15.0f];
    [KVNProgress appearance].circleStrokeForegroundColor = [UIColor whiteColor];
    [KVNProgress appearance].circleStrokeBackgroundColor = [UIColor colorWithWhite:1.0f alpha:0.3f];
    [KVNProgress appearance].circleFillBackgroundColor = [UIColor colorWithWhite:1.0f alpha:0.1f];
    [KVNProgress appearance].backgroundFillColor = [UIColor colorWithRed:0.173f green:0.263f blue:0.856f alpha:0.9f];
    [KVNProgress appearance].backgroundTintColor = [UIColor colorWithRed:0.173f green:0.263f blue:0.856f alpha:1.0f];
    [KVNProgress appearance].successColor = [UIColor whiteColor];
    [KVNProgress appearance].errorColor = [UIColor whiteColor];
    [KVNProgress appearance].circleSize = 110.0f;
    [KVNProgress appearance].lineWidth = 1.0f;
}

-(void)pregress:(UIButton*)btn{
    switch (btn.tag) {
        case 0:
        {
            if ([self isFullScreen]) {
                [KVNProgress showWithParameters:@{KVNProgressViewParameterFullScreen: @(YES)}];
            } else {
                [KVNProgress show];
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [KVNProgress dismiss];
            });
        }
            break;
        case 1:
        {
            [KVNProgress showWithParameters:@{KVNProgressViewParameterStatus: @"Loading...",
                                              KVNProgressViewParameterBackgroundType: @(KVNProgressBackgroundTypeSolid),
                                              KVNProgressViewParameterFullScreen: @([self isFullScreen])}];
            
            dispatch_main_after(3.0f, ^{
                [KVNProgress dismiss];
            });

        }
            break;
        case 2:
        {
            if ([self isFullScreen]) {
                [KVNProgress showWithParameters:@{KVNProgressViewParameterStatus: @"Loading...",
                                                  KVNProgressViewParameterFullScreen: @(YES)}];
            } else {
                [KVNProgress showWithStatus:@"Loading..."];
            }
            
            dispatch_main_after(3.0f, ^{
                [KVNProgress dismiss];
            });
        }
            break;
        case 3:
        {
            if ([self isFullScreen]) {
                [KVNProgress showProgress:0.0f
                               parameters:@{KVNProgressViewParameterStatus: @"Loading with progress...",
                                            KVNProgressViewParameterFullScreen: @(YES)}];
            } else {
                [KVNProgress showProgress:0.0f
                                   status:@"Loading with progress..."];
            }
            
            [self updateProgress];
            
            dispatch_main_after(2.7f, ^{
                [KVNProgress updateStatus:@"You can change to a multiline status text dynamically!"];
            });
            dispatch_main_after(5.5f, ^{
                [self showSuccess];
            });

        }
            break;
        case 4:
        {
            [self showSuccess];
        }
            break;
        case 5:
        {
            [self showError];
        }
            break;
        case 6:
        {
            [self setupCustomKVNProgressUI];
            
            if ([self isFullScreen]) {
                [KVNProgress showProgress:0.0f
                               parameters:@{KVNProgressViewParameterStatus: @"You can custom several things like colors, fonts, circle size, and more!",
                                            KVNProgressViewParameterFullScreen: @(YES)}];
            } else {
                [KVNProgress showProgress:0.0f
                                   status:@"You can custom several things like colors, fonts, circle size, and more!"];
            }
            
            [self updateProgress];
            
            dispatch_main_after(5.5f, ^{
                [self showSuccess];
                [self setupBaseKVNProgressUI];
            });

        }
            break;
            
        default:
            break;
    }
    
}
-(void)showError{

    if ([self isFullScreen]) {
        [KVNProgress showErrorWithParameters:@{KVNProgressViewParameterStatus: @"Error",
                                               KVNProgressViewParameterFullScreen: @(YES)}];
    } else {
        [KVNProgress showErrorWithStatus:@"Error"];
    }
}
-(void)showSuccess{
    if ([self isFullScreen]) {
        [KVNProgress showSuccessWithParameters:@{KVNProgressViewParameterStatus: @"Success",
                                                 KVNProgressViewParameterFullScreen: @(YES)}];
    } else {
        [KVNProgress showSuccessWithStatus:@"Success"];
    }
}

-(void)pop{
    ZHZJSViewController *oneVC = [[ZHZJSViewController alloc]init];
    oneVC.title = @"JS";
    [self.navigationController pushViewController:oneVC animated:YES];
 
}

#pragma mark - Helper

- (void)updateProgress
{
    dispatch_main_after(2.0f, ^{
        [KVNProgress updateProgress:0.3f
                           animated:YES];
    });
    dispatch_main_after(2.5f, ^{
        [KVNProgress updateProgress:0.5f
                           animated:YES];
    });
    dispatch_main_after(2.8f, ^{
        [KVNProgress updateProgress:0.6f
                           animated:YES];
    });
    dispatch_main_after(3.7f, ^{
        [KVNProgress updateProgress:0.93f
                           animated:YES];
    });
    dispatch_main_after(5.0f, ^{
        [KVNProgress updateProgress:1.0f
                           animated:YES];
    });
}

- (BOOL)isFullScreen
{
    return [self.fullscreenSwitch isOn];
}

static void dispatch_main_after(NSTimeInterval delay, void (^block)(void))
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        block();
    });
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
