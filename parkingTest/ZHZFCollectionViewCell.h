//
//  ZHZFCollectionViewCell.h
//  parkingTest
//
//  Created by zhanghangzhen on 15/12/31.
//  Copyright © 2015年 zhanghangzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHZFCollectionViewCell : UICollectionViewCell<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArr;
    UITableView *_tableView;
    //刷新状态
    BOOL IS_FINISH;
}

@property(strong,nonatomic)UIColor *color;
-(void)updataInfo;


@end
