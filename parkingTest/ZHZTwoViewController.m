//
//  ZHZTwoViewController.m
//  parkingTest
//
//  Created by zhanghangzhen on 15/12/30.
//  Copyright © 2015年 zhanghangzhen. All rights reserved.
//

#import "ZHZTwoViewController.h"
#import <MessageUI/MessageUI.h>
#import "MyControl.h"

#import "ZHZAliViewController.h"
#import "ZHZWxinViewController.h"
#import "ZHZViewController.h"
#import "ScanningViewController.h"
#import "SSVideoPlayContainer.h"
#import "SSVideoPlayController.h"

@interface ZHZTwoViewController ()<MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPopoverPresentationControllerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIViewController *contentVC;
     UITableView *_reaultTableView;
}
@property(nonatomic,copy)NSMutableArray *dataArr;

@end

@implementation ZHZTwoViewController
-(NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [[NSMutableArray alloc]init];
        for (int i = 0; i < 10;  i ++) {
            [_dataArr addObject:@"刘亦菲"];
        }
    }return _dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:1.000 green:0.845 blue:0.382 alpha:1.000];
    
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    UIButton *btn = [MyControl creatButtonWithFrame:CGRectMake(50, 100, 60, 60) target:self sel:@selector(send:) tag:1 image:nil title:@"发送"];
    [self.view addSubview:btn];
    UIButton *btn1 = [MyControl creatButtonWithFrame:CGRectMake(120, 100, 60, 60) target:self sel:@selector(pic:) tag:2 image:nil title:@"照片"];
    [self.view addSubview:btn1];
    UIButton *btn2 = [MyControl creatButtonWithFrame:CGRectMake(200, 100, 60, 60) target:self sel:@selector(paopao:) tag:3 image:nil title:@"泡泡"];
    [self.view addSubview:btn2];
    UIButton *btn3 = [MyControl creatButtonWithFrame:CGRectMake(120, 200, 60, 60) target:self sel:@selector(pay:) tag:4 image:nil title:@"支付宝"];
    [self.view addSubview:btn3];
    UIButton *btn4 = [MyControl creatButtonWithFrame:CGRectMake(200, 200, 60, 60) target:self sel:@selector(pay:) tag:5 image:nil title:@"微信"];
    [self.view addSubview:btn4];
    UIButton *btn5 = [MyControl creatButtonWithFrame:CGRectMake(200, 300, 60, 60) target:self sel:@selector(pay:) tag:6 image:nil title:@"时间"];
    [self.view addSubview:btn5];
    UIButton *btn6 = [MyControl creatButtonWithFrame:CGRectMake(100, 300, 60, 60) target:self sel:@selector(pay:) tag:7 image:nil title:@"传值"];
    [self.view addSubview:btn6];

    UIButton *btn7 = [MyControl creatButtonWithFrame:CGRectMake(100, 400, 60, 60) target:self sel:@selector(pay:) tag:8 image:nil title:@"扫瞄"];
    [self.view addSubview:btn7];
    UIButton *btn8 = [MyControl creatButtonWithFrame:CGRectMake(200, 400, 60, 60) target:self sel:@selector(pay:) tag:9 image:nil title:@"扫瞄"];
    [self.view addSubview:btn8];

    
    
}
-(void)pay:(UIButton*)btn{

    switch (btn.tag) {
        case 4:
        {
            NSLog(@"zhifubao");
            ZHZAliViewController *oneVC = [[ZHZAliViewController alloc]init];
            [self.navigationController pushViewController:oneVC animated:YES];
        
        }
            break;
        case 5:
        {
            ZHZWxinViewController *oneVC = [[ZHZWxinViewController alloc]init];
            [self.navigationController pushViewController:oneVC animated:YES];
            NSLog(@"weixin");
        }
            break;
            
            case 6:
        {
            ZHZViewController *oneVc = [ZHZViewController new];
            [self.navigationController pushViewController:oneVc animated:YES];
        
        }break;
        case 7:
        {
            ZHZViewController *oneVc = [ZHZViewController new];
            [self.navigationController pushViewController:oneVc animated:YES];
            
        }break;
        case 8:
        {
            
            ScanningViewController * sVC = [[ScanningViewController alloc]init];
            sVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:sVC animated:YES];
            
        }break;
        case 9:
        {
            NSArray *paths = @[@"http://data.vod.itc.cn/?prod=app&new=/194/216/JBUeCIHV4s394vYk3nbgt2.mp4",
                               @"http://data.vod.itc.cn/?prod=app&new=/5/36/aUe9kB0906IvkI5UCpq11K.mp4",
                               @"http://data.vod.itc.cn/?prod=app&new=/10/66/eCGPkAewSVqy9P57hvB11D.mp4",
                               @"http://data.vod.itc.cn/?prod=app&new=/125/206/g586XlZhJQBGTnFDS75cPF.mp4",
                               [[NSBundle mainBundle]pathForResource:@"test" ofType:@"mp4"]
                               ];
            NSArray *names = @[@"First Love",@"I Kiss You in My Dreams",@"Take You Over",@"Keep Finding a Way",@"You're Beautiful"];
            NSMutableArray *videoList = [NSMutableArray array];
            for (NSInteger i = 0; i<paths.count; i++) {
                SSVideoModel *model = [[SSVideoModel alloc]init];
                model.path = paths[i];
                model.name = names[i];
                [videoList addObject:model];
            }
            SSVideoPlayController *playController = [[SSVideoPlayController alloc]initWithVideoList:videoList];
            SSVideoPlayContainer *playContainer = [[SSVideoPlayContainer alloc]initWithRootViewController:playController];
            [self presentViewController:playContainer animated:NO completion:nil];
            
        }break;
        default:
            break;
    }
}
-(void)paopao:(UIButton*)btn{
    //创建一个内容视图控制器
    if (!contentVC) {
        contentVC = [[UIViewController alloc]init];
    }
    if (!_reaultTableView) {
        _reaultTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 120, [UIScreen mainScreen].bounds.size.height-300) style:UITableViewStylePlain];
        _reaultTableView.delegate = self;
        _reaultTableView.dataSource = self;
        _reaultTableView.alpha = 0.7;
        _reaultTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    }
    [contentVC.view addSubview:_reaultTableView];
    //北京se
    contentVC.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //弹出模式
    contentVC.modalPresentationStyle = UIModalPresentationPopover;
    //内容大小
    contentVC.preferredContentSize = CGSizeMake(120, [UIScreen mainScreen].bounds.size.height-300);
    //获取泡泡控制器
    UIPopoverPresentationController *popoverC = contentVC.popoverPresentationController;
    //弹出依赖视图
    popoverC.sourceView = btn;
    popoverC.sourceRect = btn.bounds;
    //设置代理
    popoverC.delegate = self;
    //显示泡泡
    [self presentViewController:contentVC animated:YES completion:^{
    }];
}
#pragma mark -UIPopoverPresentationControllerDelegate代理方法-
//如果想在IOS8以上的iPhone 中 看到这个效果 要实现这个代理方法
-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}
-(void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    [contentVC dismissViewControllerAnimated:YES completion:^{
        
    }];
    NSLog(@"泡泡消失了");
}

#pragma mark -tableView的代理方法-
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = @"cellId";
   
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.accessoryType =1;
            cell.textLabel.adjustsFontSizeToFitWidth = YES;
        }
        cell.textLabel.text = self.dataArr[indexPath.row];
        return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [contentVC dismissViewControllerAnimated:YES completion:nil];
}
-(void)send:(UIButton*)btn {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"分享" message:@"test" preferredStyle:UIAlertControllerStyleActionSheet];
    //增加按钮 和按钮的点击事件
    /*
     UIAlertActionStyleDefault = 0,
     UIAlertActionStyleCancel,
     UIAlertActionStyleDestructive
     */
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"短信" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //当点击 短信按钮的时候 回调这个block
        NSLog(@"短信分享");
        //跳转到一个带短信功能的 界面
        //检测 设备 有没有短信 功能
        if ([MFMessageComposeViewController canSendText]) {
            //创建一个视图控制器 MFMessageComposeViewController这个视图控制器 可以发短信
            MFMessageComposeViewController *message = [[MFMessageComposeViewController alloc] init];
            //支持群发 设置联系人
            message.recipients = @[@"10086",@"10011"];
            //设置内容
            message.body = [NSString stringWithFormat:@"这里有惊喜哟:快来点击下载吧:%@",@"www.baidu.com"];
            //如果要获取发送的状态 要设置代理
            message.messageComposeDelegate = self;
            
            //模态跳转
            [self presentViewController:message animated:YES completion:nil];
            
        }else {
            NSLog(@"不支持sms");
        }
        
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"邮箱" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //当点击 邮箱按钮的时候 回调这个block
        NSLog(@"邮箱分享");
        if ([MFMailComposeViewController canSendMail]) {
            //能发邮件
            MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
            //设置 邮件
            //标题
            [mail setSubject:@"分享爱限免"];
            //设置联系人
            [mail setToRecipients:@[@"421051332@qq.com"]];
            //设置抄送
            [mail setCcRecipients:@[@"421051332@qq.com"]];
            //设置内容   isHTML是否以html 格式显示
            [mail setMessageBody:[NSString stringWithFormat:@"这里有惊喜哟:快来点击下载吧:%@",@"www.baidu.com"] isHTML:YES];
            //增加附件
            NSData *data = UIImagePNGRepresentation([UIImage imageNamed: @"icon.png"]);
            [mail addAttachmentData:data mimeType:@"image/png" fileName:@"icon.png"];
            //设置代理
            mail.mailComposeDelegate = self;
            //模态跳转
            [self presentViewController:mail animated:YES completion:nil];
        }else {
            NSLog(@"不支持email");
        }
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"取消");
    }]];
    //必须 模态跳转
    [self presentViewController:actionSheet animated:YES completion:nil];
}
-(void)pic:(UIButton *)btn{
     UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"选择照片" message:@"test" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //当点击 邮箱按钮的时候 回调这个block
        NSLog(@"拍照");
        //打开照相机拍照
        [self takePhoto];
            }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //当点击 邮箱按钮的时候 回调这个block
        NSLog(@"相册");
        //打开本地相册
        [self LocalPhoto];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"取消");
    }]];
    //必须 模态跳转
    [self presentViewController:actionSheet animated:YES completion:nil];
}
//打开本地相册
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentModalViewController:picker animated:YES];
}
//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentModalViewController:picker animated:YES];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}
#pragma mark - 相册的协议

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    NSLog(@"%@",info);
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        /*
         //图片保存的路径
         //这里将图片放在沙盒的documents文件夹中
         NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
         
         //文件管理器
         NSFileManager *fileManager = [NSFileManager defaultManager];
         //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
         [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
         [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
         
         //得到选择后沙盒中图片的完整路径
         NSString* filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,@"/image.png"];
         
         
         */
        //创建一个选择后图片的小图标放在下方
        //类似微薄选择图后的效果
        //关闭相册界面
        [picker dismissModalViewControllerAnimated:YES];
        UIImageView *smallimage = [[UIImageView alloc] initWithFrame:
                                    CGRectMake(200, 200, 100, 100)];
        smallimage.image = image;
        //加在视图中
        [self.view addSubview:smallimage];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissModalViewControllerAnimated:YES];
}


#pragma mark - 系统邮箱界面的协议
/*
 MFMailComposeResultCancelled,
 MFMailComposeResultSaved,
 MFMailComposeResultSent,
 MFMailComposeResultFailed
 */
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"邮件被取消");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"邮件被保存");
            break;
        case MFMailComposeResultSent:
            NSLog(@"邮件已发送");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"邮件发送失败");
            break;
        default:
            break;
    }
    //邮件界面要模态跳转返回
    [controller dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 短息协议
/*
 MessageComposeResultCancelled,
 MessageComposeResultSent,
 MessageComposeResultFailed
 */
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    //result 发送短信的结果状态
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"短信被取消");
            break;
        case MessageComposeResultSent:
            NSLog(@"短信已发送");
            break;
        case MessageComposeResultFailed:
            NSLog(@"短信发送失败");
            break;
        default:
            break;
    }
}
-(void)back{
[self dismissViewControllerAnimated:YES completion:^{
    NSLog(@"消失");
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
