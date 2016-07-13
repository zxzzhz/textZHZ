//
//  ZHZAliViewController.m
//  parkingTest
//
//  Created by zhanghangzhen on 15/12/31.
//  Copyright © 2015年 zhanghangzhen. All rights reserved.
//

#import "ZHZAliViewController.h"
#import "MyControl.h"

#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "PayWayConfig.h"
#import "DataSigner.h"

@interface ZHZAliViewController ()

@end

@implementation ZHZAliViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn3 = [MyControl creatButtonWithFrame:CGRectMake(120, 200, 60, 60) target:self sel:@selector(pay:) tag:4 image:nil title:@"支付宝"];
    [self.view addSubview:btn3];
}
-(void)pay:(UIButton*)btn{
    NSLog(@"阿里支付");
    Order * order =[[Order alloc]init];
    order.partner=PartnerID;
    order.seller=SellerID;
    order.tradeNO=@"15051";
    order.productName=@"iphone6";
    order.productDescription = @"iphone 6降价处理";
    order.amount=@"0.01";
    order.notifyURL=@"http://www.baidu.com";
    order.service=@"mobile.securitypay.pay";
    order.paymentType=@"1";
    order.inputCharset = @"utf-8";
    //超时时间，m分，h时 d天，超时交易自动关闭
    order.itBPay = @"30m";
    //要在URL Scheme中设置同样的字符串
    // 支付宝回调App设置
    // 除了在代码中设置该属性，还需在info.plist中添加URL Scheme，要一致
    // 设置了才能通知你的APP，进行下一步的支付处理，比如说显示订单详情，待发货
    NSString *appScheme = @"alipayDemo";
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    //使用私钥进行数据签名
    id<DataSigner> signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderSpec];
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",orderSpec, signedString, @"RSA"];
        //启动支付宝的客户端
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut333 = %@",resultDic);
            
            NSString *strTitle = resultDic[@"resultStatus"];
            NSString *strMsg = resultDic[@"memo"];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }];
    }
    

    
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
