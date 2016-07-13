//
//  ZHZViewController.m
//  parkingTest
//
//  Created by zhanghangzhen on 16/1/5.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import "ZHZViewController.h"
#import "HSDatePickerViewController.h"
#import "MyControl.h"

#import "ZHZCZViewController.h"
@interface ZHZViewController ()<HSDatePickerViewControllerDelegate,BackValue>
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) NSDate *selectedDate;

@end

@implementation ZHZViewController
-(void)backValue:(UIColor *)string{
    self.view.backgroundColor = string;
    
}
- (IBAction)btnClick:(id)sender {
    
    HSDatePickerViewController *hsdpvc = [HSDatePickerViewController new];
    hsdpvc.delegate = self;
    if (self.selectedDate) {
        hsdpvc.date = self.selectedDate;
    }
    [self presentViewController:hsdpvc animated:YES completion:nil];
}
#pragma mark - HSDatePickerViewControllerDelegate
- (void)hsDatePickerPickedDate:(NSDate *)date {
    NSLog(@"Date picked %@", date);
    NSDateFormatter *dateFormater = [NSDateFormatter new];
    dateFormater.dateFormat = @"yyyy.MM.dd HH:mm:ss";
    self.timeLabel.text = [dateFormater stringFromDate:date];
    self.selectedDate = date;
}

//optional
- (void)hsDatePickerDidDismissWithQuitMethod:(HSDatePickerQuitMethod)method {
    NSLog(@"Picker did dismiss with %lu", method);
}

//optional
- (void)hsDatePickerWillDismissWithQuitMethod:(HSDatePickerQuitMethod)method {
    NSLog(@"Picker will dismiss with %lu", method);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn6 = [MyControl creatButtonWithFrame:CGRectMake(100, self.view.frame.size.height- 100, 60, 60) target:self sel:@selector(pay:) tag:7 image:nil title:@"传值"];
    [self.view addSubview:btn6];
    
}
-(void)pay:(UIButton*)btn{

    ZHZCZViewController *onc = [[ZHZCZViewController alloc]init];
    onc.delegate = self;
    onc.block = ^(UIColor *color){
        self.view.backgroundColor = color;
    };
    [self.navigationController pushViewController:onc animated:YES];
    
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
