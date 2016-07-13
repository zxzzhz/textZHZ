//
//  ZHZJSViewController.m
//  parkingTest
//
//  Created by zhanghangzhen on 16/1/6.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import "ZHZJSViewController.h"
#import "ZHZAliViewController.h"
#import "MyControl.h"

#import "ExampleUIWebViewController.h"

#import "ExampleWKWebViewController.h"
#define screenW self.view.frame.size.width
#define screenH self.view.frame.size.height
/**
 *  随机颜色
 */
#define MJRandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]
@interface ZHZJSViewController ()<UIWebViewDelegate,UIAlertViewDelegate>
{
    UIWebView*webview;
}
@end

@implementation ZHZJSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = MJRandomColor;
    
    webview.backgroundColor = [UIColor clearColor];
    
    webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH/2.0)];
    
    //    NSURL * url=[[NSURL alloc]initWithString:@"http://www.baidu.com"];
    NSString * path=[[NSBundle mainBundle] pathForResource:@"a.html" ofType:nil];
    NSURL * url=[NSURL fileURLWithPath:path];
    NSURLRequest * request=[[NSURLRequest alloc]initWithURL:url];
    [webview loadRequest:request];
    webview.delegate=self;
    webview.dataDetectorTypes=UIDataDetectorTypeAll;
    [self.view addSubview:webview];
    
    UIButton *btn3 = [MyControl creatButtonWithFrame:CGRectMake(120, self.view.frame.size.height/2+50, 60, 60) target:self sel:@selector(pay:) tag:4 image:nil title:@"uiwebview"];
    [self.view addSubview:btn3];
    UIButton *btn4 = [MyControl creatButtonWithFrame:CGRectMake(200, self.view.frame.size.height/2+50, 60, 60) target:self sel:@selector(pay:) tag:5 image:nil title:@"wkWebview"];
    [self.view addSubview:btn4];

}
-(void)pay:(UIButton*)btn{

    switch (btn.tag) {
        case 4:
        {
            ExampleUIWebViewController *oneVC = [[ExampleUIWebViewController alloc]init];
            [self.navigationController pushViewController:oneVC animated:YES];
            
        }
            break;
        case 5:
        {
            ExampleWKWebViewController *oneVC = [[ExampleWKWebViewController alloc]init];
            [self.navigationController pushViewController:oneVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

//从oc端像js里面添加数据
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"document.location.href"];
    NSLog(@"currentURL:%@",currentURL);
    NSString *title = [webview stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSLog(@"title:%@",title);
    
    [webview stringByEvaluatingJavaScriptFromString:@"hello(1223333)"];
    
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *scheme = request.URL.scheme;
    NSString *host = request.URL.host;
    
    NSLog(@"host:%@",host);
    NSLog(@"scheme:%@",scheme);
    NSLog(@"LLLLLLL%@",request.URL.absoluteString );
    // NSString *param = [request.URL.fragment stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([scheme isEqualToString:@"jsaction"])
    {
        if ([host isEqualToString:@"127.0.0.1"])
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你好啊" preferredStyle:UIAlertControllerStyleAlert];
            // Create the actions.
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"支付" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
                ZHZAliViewController *oneVC = [[ZHZAliViewController alloc]init];
                oneVC.title = @"阿里巴巴";
                [self.navigationController pushViewController:oneVC animated:YES];
            }];
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                NSLog(@"The \"Okay/Cancel\" alert's other action occured.");
            }];
            
            // Add the actions.
            [alertController addAction:cancelAction];
            [alertController addAction:otherAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        
    }
    
    return  YES;
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
