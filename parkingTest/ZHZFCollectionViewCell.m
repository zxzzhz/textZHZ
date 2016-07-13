//
//  ZHZFCollectionViewCell.m
//  parkingTest
//
//  Created by zhanghangzhen on 15/12/31.
//  Copyright © 2015年 zhanghangzhen. All rights reserved.
//

#import "ZHZFCollectionViewCell.h"
#import "MJRefresh.h"

@implementation ZHZFCollectionViewCell

-(void)updataInfo{
     IS_FINISH = YES;
     if (_dataArr== nil) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    [_dataArr removeAllObjects];
    [_tableView reloadData];
    //数据加载
    [self downloadDetailData];
    
    if (_tableView== nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.contentView addSubview:_tableView];
        [self setRefresh];
    }
}
//刷新
-(void)setRefresh{
         //添加下拉刷新
//    [_tableView addHeaderWithTarget:self action:@selector(headerrefreshing)];
//         //设置头部提示
//         _tableView.headerPullToRefreshText=@"下拉刷新";
//         _tableView.headerReleaseToRefreshText = @"松开即可";
//         _tableView.headerRefreshingText = @"下载中";
//    上啦加载数据
    [_tableView addFooterWithTarget:self action:@selector(footerrefreshing)];
    //设置底部提示
    _tableView.footerPullToRefreshText = @"上啦数据加载";
    _tableView.footerReleaseToRefreshText = @"上啦加载";
    _tableView.footerRefreshingText = @"正在加载";
}
-(void)footerrefreshing{
    if (IS_FINISH) {
         [self downloadDetailData];
    }else{
        [_tableView footerEndRefreshing];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已经加载完了" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (void)downloadDetailData{
    // 1.添加假数据
    for (int i = 0;  i < 5; i++) {
        [_dataArr addObject:@"喜泊客"];
    }
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [_tableView reloadData];
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_tableView footerEndRefreshing];
    });
}
-(void)createAlert{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请检查网络" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
#pragma mark -tableView的代理方法-
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = _dataArr[indexPath.row];
    cell.backgroundColor = self.color;
    return cell;
}

@end
