//
//  ZHZOneViewController.m
//  parkingTest
//
//  Created by zhanghangzhen on 15/12/29.
//  Copyright © 2015年 zhanghangzhen. All rights reserved.
//
#import "ZHZOneViewController.h"

// 获取当前设备可用内存及所占内存的头文件

#import <sys/sysctl.h>

#import <mach/mach.h>

//#import <mach/host_info.h>
//#import <mach/mach_host.h>
//#import <mach/task_info.h>
//#import <mach/task.h>



@interface ZHZOneViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
}

@property(nonatomic,copy)NSMutableArray *dataArray;//临时用假数据代替

@property (nonatomic, copy) NSMutableArray *removeList;//勾选时要删除的数据

@property(nonatomic,strong)UIBarButtonItem *rightBtn;
@end

@implementation ZHZOneViewController

//获得设备型号

-(NSString *)getCurrentDeviceModel:(UIViewController *)controller
{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] init];
        [_dataArray addObject:[NSString stringWithFormat:@"剩余内存：%.2f",[self availableMemory]]];
        [_dataArray addObject:[NSString stringWithFormat:@"运行内存%.2f",[self usedMemory]]];
        [_dataArray addObject:[self usedSpaceAndfreeSpace]];
        [_dataArray addObject:[self getCurrentDeviceModel:self]];
        //手机序列号
        UIDevice *device=[[UIDevice alloc] init];
        NSString* identifierNumber =[NSString stringWithFormat:@"设备识别码:%@",device.identifierForVendor.UUIDString];
        [_dataArray addObject:identifierNumber];
        [_dataArray addObject:[NSString stringWithFormat:@"设备所有者的名称:%@",device.name]];
        [_dataArray addObject:[NSString stringWithFormat:@"设备的类别:%@",device.model]];
        [_dataArray addObject:[NSString stringWithFormat:@"设备的的本地化版本:%@",device.localizedModel]];
        [_dataArray addObject:[NSString stringWithFormat:@"设备运行的系统:%@",device.systemName]];
        [_dataArray addObject:[NSString stringWithFormat:@"当前系统的版本:%@",device.systemVersion]];
        [self addObject];
        
    }return _dataArray;
}
-(void)addObject{
    
 NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
    [_dataArray addObject:[NSString stringWithFormat:@"当当前应用名称:%@",dic[@"CFBundleDisplayName"]]];
    [_dataArray addObject:[NSString stringWithFormat:@"当前应用软件版本:%@",dic[@"CFBundleShortVersionString"]]];
    [_dataArray addObject:[NSString stringWithFormat:@"当前应用版本号码:%@",dic[@"CFBundleVersion"]]];
}
-(NSMutableArray *)removeList{
    if (_removeList == nil) {
        _removeList = [[NSMutableArray alloc]init];
    }return _removeList;
}
// 获取当前设备可用内存(单位：MB）
- (double)availableMemory
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),HOST_VM_INFO,(host_info_t)&vmStats,&infoCount);
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    return ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0/1024.0;
}
-(NSString*)usedSpaceAndfreeSpace{
    
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] ;
    NSFileManager* fileManager = [[NSFileManager alloc ]init];
    NSDictionary *fileSysAttributes = [fileManager attributesOfFileSystemForPath:path error:nil];
    NSNumber *freeSpace = [fileSysAttributes objectForKey:NSFileSystemFreeSize];
    NSNumber *totalSpace = [fileSysAttributes objectForKey:NSFileSystemSize];
    NSString  * str= [NSString stringWithFormat:@"已占用%0.1fG/剩余%0.1fG",([totalSpace longLongValue] - [freeSpace longLongValue])/1024.0/1024.0/1024.0,[freeSpace longLongValue]/1024.0/1024.0/1024.0];
    return str;
    
}
// 获取当前任务所占用的内存（单位：MB）
- (double)usedMemory

{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),TASK_BASIC_INFO,(task_info_t)&taskInfo,&infoCount);
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    return taskInfo.resident_size / 1024.0 / 1024.0;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:1.000 green:0.549 blue:0.890 alpha:0.800];
    [self initAllData];
    NSLog(@"%@",[NSString stringWithFormat:@"%.2f",[self availableMemory]]);
}

//实现操作

-(void)initAllData

{
    //1:必须首先加载tableview
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height )];
    [self.view addSubview:_tableView];
    _tableView.delegate= self;
    
    _tableView.dataSource = self;
    
    self.view.backgroundColor = [UIColor whiteColor];
    _rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"删除"style:UIBarButtonItemStyleDone target:self action:@selector(toggleEdit:)];
    self.navigationItem.rightBarButtonItem = _rightBtn;
}
//多选删除操作（其实很简单，重点理解这里）

-(void)toggleEdit:(id)sender {
    
    [_tableView setEditing:!_tableView.editing animated:YES];//能出那个??勾选删除
    if (_tableView.editing){
    [self.navigationItem.rightBarButtonItem setTitle:@"确定"];
    } else {
        [self.navigationItem.rightBarButtonItem setTitle:@"删除"];
        if (self.removeList.count > 0) {
            [_dataArray removeObjectsInArray:self.removeList];//删除已经勾选的数据
            [_tableView reloadData];//重新加载
            [self.removeList removeAllObjects];//清空已经勾选了的数据列表
        }
    }
}
- (NSInteger)tableView:(UITableView *)tableView

 numberOfRowsInSection:(NSInteger)section {
    
    return [self.dataArray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *DeleteMeCellIdentifier = @"DeleteMeCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DeleteMeCellIdentifier];
    [tableView setSeparatorColor:[UIColor blueColor]];  //设置分割线为蓝色
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DeleteMeCellIdentifier];
    }
    NSInteger row = [indexPath row];
    cell.textLabel.text = [self.dataArray objectAtIndex:row];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    return cell;
}

#pragma mark -
#pragma mark Table View Data Source Methods
 
//编辑样式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
//添加一项
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    id addObject = [self.dataArray objectAtIndex:row];
    [self.removeList addObject:addObject];
    
}
//取消一项
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    id deleteObject = [self.dataArray objectAtIndex:row];
    [self.removeList removeObject:deleteObject];
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
