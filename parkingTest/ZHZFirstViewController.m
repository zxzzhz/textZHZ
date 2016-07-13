//
//  ZHZFirstViewController.m
//  parkingTest
//
//  Created by zhanghangzhen on 15/12/29.
//  Copyright © 2015年 zhanghangzhen. All rights reserved.
//

#import "ZHZFirstViewController.h"
#import "ZHZTitleView.h"
#import "ZHZOneViewController.h"
#import "ZHZThreeViewController.h"
#import "MJRefresh.h"
#import "MJCollectionViewController.h"
#import "DropDownViewController.h"
#import "CCWebViewController.h"
#import "BluetoothViewController.h"

#import "AppDelegate.h"



@interface ZHZFirstViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    UITableView *_tableView;
    int flag[26];
}
@property(nonatomic,copy)NSMutableArray *dataArr;
@property(nonatomic,copy)NSMutableArray *abcArr;


@end

@implementation ZHZFirstViewController
-(NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc]init];
        for (int i = 0; i< 10; i++) {
            [_dataArr addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    return _dataArr;
}
-(NSMutableArray *)abcArr{
    if (_abcArr== nil) {
         _abcArr = [[NSMutableArray alloc]initWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z", nil];
    }return _abcArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor redColor];
    
    // 设置导航栏按钮
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithTitle:@"张" style:UIBarButtonItemStylePlain target:self action:@selector(friendSearch)];
    
    self.navigationItem.leftBarButtonItem = leftBtn;
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
    
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    // 设置导航栏中间的标题按钮
    ZHZTitleView *titleButton = [[ZHZTitleView alloc] init];
    // 设置文字
    [titleButton setTitle:@"首页" forState:UIControlStateNormal];
    // 设置图标
    [titleButton setImage:[UIImage imageWithName:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
    // 设置背景
    [titleButton setBackgroundImage:[UIImage resizedImage:@"navigationbar_filter_background_highlighted"] forState:UIControlStateHighlighted];
    // 设置尺寸
    titleButton.width = 100;
    titleButton.height = 35;
    // 监听按钮点击
    [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleButton;
    
    [self  setTableView];
    AppDelegate *dele = [[UIApplication sharedApplication] delegate];
    dele.block = ^(UIColor *color){
        self.view.backgroundColor = color;
        
    };
}
-(void)titleClick:(UIButton*)sender{

    NSLog(@"%ld",(long)sender.tag);
}
-(void)setTableView{

    _tableView  = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    // 2.集成刷新控件
    [self setupRefresh];
}
/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
#warning 自动刷新(一进入程序就下拉刷新)
    [_tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    _tableView.headerPullToRefreshText = @"下拉可以刷新了";
    _tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    _tableView.headerRefreshingText = @"刷新中……";
    
    _tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
     _tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    _tableView.footerRefreshingText = @"加载中……";
}
- (void)headerRereshing
{
    // 1.添加假数据

        [self.dataArr insertObject:@"喜泊客" atIndex:0];
    
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [_tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_tableView headerEndRefreshing];
    });
}

- (void)footerRereshing
{
    // 1.添加假数据
           [self.dataArr addObject:@"喜泊客"];
 
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [_tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_tableView footerEndRefreshing];
    });
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 26;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

   return flag[section] == 1?self.dataArr.count:0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y-2, self.view.frame.size.width, 2)];
        view.backgroundColor = [UIColor redColor];

        [cell.contentView addSubview:view];
    }
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_tableView.editing) {
        return;
    }
    
    switch (indexPath.section) {
        case 0:
        {
            MJCollectionViewController *oneVC = [[MJCollectionViewController alloc]init];
            [self.navigationController pushViewController:oneVC animated:YES];
        }
            break;
        case 1:
        {
            ZHZOneViewController *one = [[ZHZOneViewController alloc] init];
            one.title = @"多选删除";
            [self.navigationController pushViewController:one animated:YES];
        }
            break;
        case 2:
        {
            ZHZThreeViewController *one = [[ZHZThreeViewController alloc] init];
            one.title = @"新闻联动";
            [self.navigationController pushViewController:one animated:YES];
        }
            break;
        case 3:
        {
            DropDownViewController *oneVC = [DropDownViewController new];
            oneVC.title = @"下拉菜单";
            oneVC.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController pushViewController:oneVC animated:YES];
        }
            break;
        case 4:
        {
[CCWebViewController showWithContro:self withUrlStr:@"http://m.jd.com/" withTitle:@"京东"];
        }
            break;
            
        case 5:
        {
            BluetoothViewController *oneVC = [[BluetoothViewController alloc]init];
            [self.navigationController pushViewController:oneVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}
-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.abcArr;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete ;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//哪几行可以移动(可移动的行数小于等于可编辑的行数)
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
 
    return YES;
}
//移动cell时的操作
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
    
    if (sourceIndexPath != destinationIndexPath) {
        id object = [self.dataArr objectAtIndex:sourceIndexPath.row];
        [self.dataArr removeObjectAtIndex:sourceIndexPath.row];
        if (destinationIndexPath.row > [self.dataArr count]) {
            [self.dataArr addObject:object];
        }
        else {
            [self.dataArr insertObject:object atIndex:destinationIndexPath.row];
        }
     }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.dataArr removeObjectAtIndex:indexPath.row];
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [_tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];

}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    return @"哇哈哈";
}
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{
    //    if (proposedDestinationIndexPath.row > 3) {
    //        return sourceIndexPath;
    //    }
    return proposedDestinationIndexPath;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
//    view.tag = 100+section;
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
        label.tag = 100+section;
    label.text = self.abcArr[section];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    label.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [label addGestureRecognizer:tap];
     return label;
}

-(void)tap:(UITapGestureRecognizer*)tap{
    
    NSInteger section = tap.view.tag - 100;
    flag [section] ^= 1;
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:section];
    [_tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
}




-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 1;
}
/**
 *  点击了遮盖
 */
- (void)coverClick
{
//    HMLog(@"coverClick---");
}

- (void)friendSearch
{
    
    NSLog(@"zhanghangzhen");
//    HMLog(@"friendSearch---");
    
    ZHZOneViewController *one = [[ZHZOneViewController alloc] init];
    one.title = @"OneVc";
    [self.navigationController pushViewController:one animated:YES];
}

- (void)pop
{
    _tableView.editing = !_tableView.editing;
    if (_tableView.editing) {
        self.navigationItem.rightBarButtonItem.title = @"完成";
    }else{
        self.navigationItem.rightBarButtonItem.title = @"编辑";

    }
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [UIView animateWithDuration:0.5 animations:^{
        self.tabBarController.tabBar.alpha = 0;
    }];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [UIView animateWithDuration:0.5 animations:^{
        self.tabBarController.tabBar.alpha = 1;
//        self.tabBarController.tabBar.backgroundColor = [UIColor colorWithHue:0.8 saturation:0.5 brightness:0.5 alpha:0.5];
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
