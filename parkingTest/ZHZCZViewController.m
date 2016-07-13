//
//  ZHZCZViewController.m
//  parkingTest
//
//  Created by zhanghangzhen on 16/2/16.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import "ZHZCZViewController.h"
#import "JKAlertDialog.h"
#import "MyControl.h"
#import "CircularLock.h"
@interface ZHZCZViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _table;
}
@end

@implementation ZHZCZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"触摸回调传值";
    _table=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 270, 1000) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    self.view.backgroundColor = [UIColor colorWithRed:1.000 green:0.939 blue:0.483 alpha:1.000];
    UIButton *btn6 = [MyControl creatButtonWithFrame:CGRectMake(100, self.view.frame.size.height- 100, 60, 60) target:self sel:@selector(pay:) tag:7 image:nil title:@"传值"];
    [self.view addSubview:btn6];
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    
    CircularLock *c = [[CircularLock alloc] initWithCenter:CGPointMake(self.view.center.x, self.view.frame.size.height - 100)
                                                    radius:50
                                                  duration:1.5
                                               strokeWidth:15
                                                 ringColor:[UIColor greenColor]
                                               strokeColor:[UIColor whiteColor]
                                               lockedImage:[UIImage imageNamed:@"lockedTransparent.png"]
                                             unlockedImage:[UIImage imageNamed:@"unlocked.png"]
                                                  isLocked:NO
                                         didlockedCallback:^{
                                             [self alertWithMessage:@"locked"];
                                         }
                                       didUnlockedCallback:^{
                                           [self alertWithMessage:@"unlocked"];
                                       }];
    [self.view addSubview:c];
}

- (void)alertWithMessage:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
-(void)pay:(UIButton*)btn{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"选择传值方式" message:@"test" preferredStyle:UIAlertControllerStyleActionSheet];
    
    __weak typeof (self)unself = self;
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"普通" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"这是一个AlertDialog" message:@"这是一个AlertDialog这是一个AlertDialog这是一个AlertDialog这是一个AlertDialog这是一个AlertDialog"];
        
        [alert addButtonWithTitle:@"确定"];
        
        [alert addButton:Button_OTHER withTitle:@"取消" handler:^(JKAlertDialogItem *item) {
            NSLog(@"click %@",item.title);
            UIViewController *view = [[UIViewController alloc]init];
            view.view.backgroundColor = [UIColor redColor];
            [self.navigationController pushViewController:view animated:YES];
        }];;
        [alert addButton:Button_OTHER withTitle:@"ok" handler:^(JKAlertDialogItem *item) {
            NSLog(@"click %@",item.title);
            
        }];
        [alert addButton:Button_OTHER withTitle:@"cancle" handler:^(JKAlertDialogItem *item) {
            NSLog(@"click %@",item.title);
            
        }];
        
        [alert show];

    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"tableView" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"提示" message:@""];
        alert.contentView =  _table;
        
        [alert addButtonWithTitle:@"确定"];
        
        [alert addButton:Button_OTHER withTitle:@"取消" handler:^(JKAlertDialogItem *item) {
            NSLog(@"click %@",item.title);
        }];;
        [alert addButton:Button_OTHER withTitle:@"ok" handler:^(JKAlertDialogItem *item) {
            NSLog(@"click %@",item.title);
            
        }];
        [alert addButton:Button_OTHER withTitle:@"cancle" handler:^(JKAlertDialogItem *item) {
            NSLog(@"click %@",item.title);
            
        }];
        
        [alert show];

        
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"scrollView" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        JKAlertDialog *alert = [[JKAlertDialog alloc]initWithTitle:@"提示" message:@""];
        alert.buttonWidth = 100;
        alert.contentView =  _table;
        
        [alert addButtonWithTitle:@"确定"];
        
        [alert addButton:Button_OTHER withTitle:@"取消" handler:^(JKAlertDialogItem *item) {
            NSLog(@"click %@",item.title);
        }];;
        [alert addButton:Button_OTHER withTitle:@"ok" handler:^(JKAlertDialogItem *item) {
            NSLog(@"click %@",item.title);
            
        }];
        [alert addButton:Button_OTHER withTitle:@"cancle" handler:^(JKAlertDialogItem *item) {
            NSLog(@"click %@",item.title);
            
        }];
        
        [alert show];

    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"系统" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"这是一个Alert这是一个A" message:@"这是一个Alert这是一个Alert这是一个Alert这是一个Alerterlert这是一个Alert" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alert show];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"取消");
    }]];
    //必须 模态跳转
    [self presentViewController:actionSheet animated:YES completion:nil];

}
#pragma --mark table
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //config the cell
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"asdgagaga");
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"选择传值方式" message:@"test" preferredStyle:UIAlertControllerStyleActionSheet];
    
    __weak typeof (self)unself = self;
   
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"代理" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([unself.delegate respondsToSelector:@selector(backValue:)]) {
            [unself.delegate backValue:[UIColor redColor]];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"block" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
            self.block([UIColor yellowColor]);
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"通知" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }]];
 
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"NSUserDefaults" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"UIApplication" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"取消");
    }]];
    //必须 模态跳转
    [self presentViewController:actionSheet animated:YES completion:nil];
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
