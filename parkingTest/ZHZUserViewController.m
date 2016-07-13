//
//  ZHZUserViewController.m
//  parkingTest
//
//  Created by zhanghangzhen on 15/12/29.
//  Copyright © 2015年 zhanghangzhen. All rights reserved.
//

#import "ZHZUserViewController.h"
#import "SUserTableViewController.h"
#import "SUserDB.h"

#import "YLSlideView/YLSlideView.h"
#import "YLSlideConfig.h"
#import "YLSlideView/YLSlideCell.h"
#import "AlipayWebController.h"
#import "AppDelegate.h"

#import "ZHZBtnViewController.h"
/**
 *  随机颜色
 */
#define MJRandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]
@interface ZHZUserViewController ()<YLSlideViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    YLSlideView * _slideView;
    NSArray *colors;
    NSArray *_testArray;
    NSUInteger indexTag;
}
@end

@implementation ZHZUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:1.000 green:0.545 blue:0.705 alpha:1.000];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"数据库" style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
    
    self.navigationItem.rightBarButtonItem = rightBtn;
    [self setup];
   
}

-(void)setup{

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars =NO;
    self.modalPresentationCapturesStatusBarAppearance =NO;
    self.navigationController.navigationBar.translucent =NO;
    
    colors = @[[UIColor redColor],[UIColor yellowColor],[UIColor blackColor],[UIColor redColor],[UIColor yellowColor],[UIColor blackColor],[UIColor redColor],[UIColor yellowColor],[UIColor blackColor],[UIColor redColor],[UIColor yellowColor],[UIColor blackColor],[UIColor redColor],[UIColor yellowColor],[UIColor blackColor],[UIColor redColor],];
    
    _slideView = [[YLSlideView alloc]initWithFrame:CGRectMake(0, 0,
                                                              SCREEN_WIDTH_YLSLIDE,
                                                              SCREEN_HEIGHT_YLSLIDE-64)
                                         forTitles:@[@"有书头条",
                                                     @"头条",
                                                     @"要闻",
                                                     @"有书头条",
                                                     @"头条",
                                                     @"要闻",
                                                     @"有书头条",
                                                     @"头条",
                                                     @"要闻",@"头条",
                                                     @"要闻",
                                                     @"有书头条",
                                                     @"头条",
                                                     @"要闻",
                                                     @"有书头条",
                                                     @"头条"]];
    
    _slideView.backgroundColor = [UIColor whiteColor];
    _slideView.delegate        = self;
    [self.view addSubview:_slideView];

}
-(void)pop{
    SUserDB * db = [[SUserDB alloc] init];
    [db createDataBase];
    SUserTableViewController * controller =   [[SUserTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:controller animated:YES];
}


- (NSInteger)columnNumber{
    return colors.count;
}

- (YLSlideCell *)slideView:(YLSlideView *)slideView
         cellForRowAtIndex:(NSUInteger)index{
    
    YLSlideCell * cell = [slideView dequeueReusableCell];
    
    if (!cell) {
        cell = [[YLSlideCell alloc]initWithFrame:CGRectMake(0, 0, 320, 500)
                                           style:UITableViewStylePlain];
        cell.delegate   = self;
        cell.dataSource = self;
    }
    
    //    cell.backgroundColor = colors[index];
    
    
    return cell;
}
- (void)slideVisibleView:(YLSlideCell *)cell forIndex:(NSUInteger)index{
    indexTag = index;
    NSLog(@"index :%@   ",@(index) );
    [cell reloadData]; //刷新TableView
    NSLog(@"刷新数据");
}
  #pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 20;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *Identifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    
    cell.textLabel.text = [@(arc4random()%1000) stringValue];
    cell.contentView.backgroundColor = MJRandomColor;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexTag) {
        case 0:
        {
            NSLog(@"aaa");
            ZHZBtnViewController *oneVC = [[ZHZBtnViewController alloc]init];
            oneVC.view.backgroundColor = MJRandomColor;
            [self.navigationController pushViewController:oneVC animated:YES];
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
            AlipayWebController *oneVC = [[AlipayWebController alloc]init];
            
         
            
//               https://ds.alipay.com/?scheme=alipays%3A%2F%2Fplatformapi%2Fstartapp%3FappId%3D20000067%26url%3Dhttps%253A%252F%252Fmapi.alipay.com%252Fgateway.do%253F_input_charset%253Dutf-8%2526access_info%253D%257B%2522channel%2522%253A%2522ALIPAYAPP%2522%257D%2526external_sign_no%253Ds4dymBKb%2526notify_url%253Dhttp%253A%252F%252Fb2c.ezparking.com.cn%252Frtpi-service%252Falipay%252Fgateway.do%2526partner%253D2088021659301977%2526product_code%253DGENERAL_WITHHOLDING_P%2526return_url%253Dyoparking%253A%252F%252Faccount%2526scene%253DINDUSTRY%257CCARRENTAL%2526service%253Dalipay.dut.customer.agreement.page.sign%2526sign%253Ddb287a1fcd2933ce11352b92e6a0862e%2526sign_type%253DMD5
            
            
            //https://ds.alipay.com/?scheme=alipays%3A%2F%2Fplatformapi%2Fstartapp%3FappId%3D20000067%26url%3Dhttps%253A%252F%252Fmapi.alipay.com%252Fgateway.do%253F_input_charset%253Dutf-8%2526access_info%253D%257B%2522channel%2522%253A%2522ALIPAYAPP%2522%257D%2526notify_url%253Dhttp%253A%252F%252Fb2c.ezparking.com.cn%252Frtpi-service%252Falipay%252Fgateway.do%2526out_trade_no%253D20090297%2526partner%253D2088021659301977%2526payment_type%253D1%2526return_url%253Dyoparking%253A%252F%252Forder%2526seller_id%253D2088021659301977%2526service%253Dalipay.wap.create.direct.pay.by.user%2526show_url%253Dhttp%253A%252F%252Fbook.ezparking.com.cn%252Fbook%252F%2526sign%253D97d8cec7e9568ac4ade7e2ca54377173%2526sign_type%253DMD5%2526subject%253D%25E7%25BA%25A6%25E5%2581%259C%25E8%25BD%25A6%2526total_fee%253D0.2
            oneVC.strUrl = @"https://ds.alipay.com/?scheme=alipays%3A%2F%2Fplatformapi%2Fstartapp%3FappId%3D20000067%26url%3Dhttps%253A%252F%252Fmapi.alipay.com%252Fgateway.do%253F_input_charset%253Dutf-8%2526access_info%253D%257B%2522channel%2522%253A%2522ALIPAYAPP%2522%257D%2526notify_url%253Dhttp%253A%252F%252Fb2c.ezparking.com.cn%252Frtpi-service%252Falipay%252Fgateway.do%2526out_trade_no%253D20090297%2526partner%253D2088021659301977%2526payment_type%253D1%2526return_url%253Dyoparking%253A%252F%252Forder%2526seller_id%253D2088021659301977%2526service%253Dalipay.wap.create.direct.pay.by.user%2526show_url%253Dhttp%253A%252F%252Fbook.ezparking.com.cn%252Fbook%252F%2526sign%253D97d8cec7e9568ac4ade7e2ca54377173%2526sign_type%253DMD5%2526subject%253D%25E7%25BA%25A6%25E5%2581%259C%25E8%25BD%25A6%2526total_fee%253D0.2";
            [self.navigationController pushViewController:oneVC animated:YES];
            NSLog(@"ccc");

        }
            break;
        case 3:
        {
            NSLog(@"ddd");

        }
            break;
            
        default:
            break;
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [UIView animateWithDuration:0.2 animations:^{
        self.tabBarController.tabBar.alpha = 0;
    }];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [UIView animateWithDuration:0.2 animations:^{
        self.tabBarController.tabBar.alpha = 1;
        self.tabBarController.tabBar.backgroundColor = [UIColor colorWithHue:0.8 saturation:0.5 brightness:0.5 alpha:0.5];
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
