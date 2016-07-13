
//
//  ZHZThreeViewController.m
//  parkingTest
//
//  Created by zhanghangzhen on 15/12/31.
//  Copyright © 2015年 zhanghangzhen. All rights reserved.
//

#import "ZHZThreeViewController.h"
#import "ZHZFCollectionViewCell.h"
#import "MyControl.h"

/**
 *  随机颜色
 */
#define MJRandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]
@interface ZHZThreeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>
{
    NSMutableArray *_dataArr;

    UIScrollView*_topScrollView;
    UIView *_tagView;
    NSInteger tag;
    UICollectionView *_baseXollectionView;
    UIButton *btn;
    //毛玻璃效果
    UIVisualEffectView*effectview;
}
@end

@implementation ZHZThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
 
    self.view.backgroundColor = [UIColor colorWithRed:1.000 green:0.446 blue:0.324 alpha:1.000];
    _dataArr = [NSMutableArray arrayWithObjects:@"谷薯类",@"蔬菜类",@"水果类",@"奶制品类",@"豆制品类",@"肉蛋类",@"坚果类",@"酒水类",@"零食类",@"调味品类", nil];
    [self createScrollView];
    [self createCollection];
  
}
//定制顶部滑动视图：
-(void)createScrollView{
    _topScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,64, self.view.frame.size.width, 36)];
    _topScrollView.contentSize = CGSizeMake(70*_dataArr.count, 36);
    _topScrollView.backgroundColor = [UIColor whiteColor];
    _topScrollView.showsHorizontalScrollIndicator = NO;
    _topScrollView.showsVerticalScrollIndicator   = NO;
    _topScrollView.bounces                        = NO;
    for (int i = 0; i< _dataArr.count; i++) {
        btn = [MyControl creatButtonWithFrame:CGRectMake(150+70*i+10*i, 0, 70, 30) target:self sel:@selector(changeView:) tag:100+i image:nil title:_dataArr[i]];
        [_topScrollView addSubview:btn];
        btn.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    [self.view addSubview:_topScrollView];
    _tagView = [[UIView alloc]initWithFrame:CGRectMake(150, 32, 70, 4)];
    _tagView.backgroundColor = [UIColor redColor];
    [_topScrollView addSubview:_tagView];
}
//添加集合视图
-(void)createCollection{
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
    //设置item之间的间距
    flowlayout.minimumInteritemSpacing = 0;
    //设置行间距/Users/qianfeng/Desktop/项目/Hang/Hang.xcodeproj
    flowlayout.minimumLineSpacing = 0;
    //设置滚动方向
    flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //实例化collectionView;
    _baseXollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:flowlayout];
    _baseXollectionView.delegate = self;
    _baseXollectionView.dataSource = self;
    _baseXollectionView.bounces = NO;
    //注册cell
    [_baseXollectionView registerClass:[ZHZFCollectionViewCell class] forCellWithReuseIdentifier:@"ZHZFCollectionViewCell"];
    _baseXollectionView.pagingEnabled = YES;
    [self.view addSubview:_baseXollectionView];
}
//section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//item的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArr.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId= @"ZHZFCollectionViewCell";
    ZHZFCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.color = MJRandomColor;
    cell.backgroundColor = MJRandomColor;
    [cell updataInfo];
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(_baseXollectionView.frame.size.width , _baseXollectionView.frame.size.height);
}

//按钮点击事件
-(void)changeView:(UIButton*)sender{
    //动画效果
    tag = sender.tag - 100;
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:tag inSection:0];
    [UIView animateWithDuration:0.4 animations:^{
        [_baseXollectionView selectItemAtIndexPath:indexpath animated:YES scrollPosition:0];
        _tagView.frame = CGRectMake(150+70*(sender.tag-100)+10*(sender.tag-100), 32, 70, 4);
        _topScrollView.contentOffset = CGPointMake((sender.tag-100)*70, 0);
    } completion:^(BOOL finished) {
        _baseXollectionView.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width*tag, 0);
    }];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _baseXollectionView) {
        //动画效果
        [UIView animateWithDuration:0.4 animations:^{
            _topScrollView.contentOffset = CGPointMake(70*(scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width)+10+10*(scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width), 0);
            _tagView.frame = CGRectMake(150+70*(scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width)+10*(scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width), 34, 70, 4);
        } completion:^(BOOL finished) {
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
