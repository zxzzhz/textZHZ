//
//  ZHZWxinViewController.m
//  parkingTest
//
//  Created by zhanghangzhen on 15/12/31.
//  Copyright © 2015年 zhanghangzhen. All rights reserved.
//

#import "ZHZWxinViewController.h"
#import "MyControl.h"

//微信
#import "WXApi.h"
#import "payRequsestHandler.h"

@interface ZHZWxinViewController ()

@end

@implementation ZHZWxinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn4 = [MyControl creatButtonWithFrame:CGRectMake(200, 200, 60, 60) target:self sel:@selector(pay:) tag:5 image:nil title:@"微信"];
    [self.view addSubview:btn4];
}
-(void)pay:(UIButton*)btn{
    NSLog(@"微信支付");
    // 判断微信是否安装
    if ([WXApi isWXAppInstalled]) {
        [self sendPay_demo];
    }
    else
    {
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还未安装微信哟" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}
- (void)sendPay_demo
{
    
        NSError *error;
        //加载一个NSURL对象
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://b2c.ezparking.com.cn/rtpi-service/memberBook/payPage.do?key=a2fc60f33f279c85d76c99ee659e8ba3&id=95970232&type=wxpay"]];
        //将请求的url数据放到NSData对象中
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        [WXApi sendReq:req];
}

//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alter show];
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
