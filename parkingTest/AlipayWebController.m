//
//  AlipayWebController.m
//  Park
//
//  Created by chenxi on 15/11/22.
//  Copyright © 2015年  apple. All rights reserved.
//

#import "AlipayWebController.h"
#import "UIViewController+HUD.h"

@interface AlipayWebController ()<UIWebViewDelegate>
{
    UIWebView *_webView;
}

@end

@implementation AlipayWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *barBtn =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(alipayWebBackAction)];
    self.navigationItem.leftBarButtonItem = barBtn;
    _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.strUrl]];
    [_webView loadRequest:request];
}
- (void)alipayWebBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIWebviewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *scheme = request.URL.scheme;
    NSString *host = request.URL.host;
    NSLog(@"host:%@",host);
    NSLog(@"scheme:%@",scheme);
    NSLog(@"LLLLLLL%@",request.URL.absoluteString );
    
    if ([request.URL.scheme isEqualToString:@"alipays"]) {
        NSString *str = [request.URL.absoluteString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@",str);
        //  alipays://platformapi/startapp?appId=20000067&url=https://mapi.alipay.com/gateway.do?_input_charset=utf-8&access_info={"channel":"ALIPAYAPP"}&external_sign_no=s4dymBKb&notify_url=http://b2c.ezparking.com.cn/rtpi-service/alipay/gateway.do&partner=2088021659301977&product_code=GENERAL_WITHHOLDING_P&return_url=yoparking://account&scene=INDUSTRY|CARRENTAL&service=alipay.dut.customer.agreement.page.sign&sign=db287a1fcd2933ce11352b92e6a0862e&sign_type=MD5&_t=1452739979909
       //alipays://platformapi/startapp?appId=20000067&url=https://mapi.alipay.com/gateway.do?_input_charset=utf-8&access_info={"channel":"ALIPAYAPP"}&notify_url=http://b2c.ezparking.com.cn/rtpi-service/alipay/gateway.do&out_trade_no=20090297&partner=2088021659301977&payment_type=1&return_url=yoparking://order&seller_id=2088021659301977&service=alipay.wap.create.direct.pay.by.user&show_url=http://book.ezparking.com.cn/book/&sign=97d8cec7e9568ac4ade7e2ca54377173&sign_type=MD5&subject=约停车&total_fee=0.20&_t=1452740072959
    }
    return  YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
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
