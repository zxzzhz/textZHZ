//
//  BluetoothViewController.m
//  parkingTest
//
//  Created by zhanghangzhen on 16/1/26.
//  Copyright © 2016年 zhanghangzhen. All rights reserved.
//

#import "BluetoothViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "MyControl.h"

@interface BluetoothViewController ()<CBCentralManagerDelegate,CBPeripheralDelegate>
{
    CBCentralManager *manager;
}

@property (nonatomic, strong) NSMutableData *data;

@property(nonatomic,strong)CBPeripheral*peripheral;
@property (nonatomic,copy)NSMutableArray*discoverdPeriparals;

@end

@implementation BluetoothViewController
static NSString * const kServiceUUID = @"6BC6543C-2398-4E4A-AF28-E4E0BF58D6BC";
static NSString * const kCharacteristicUUID = @"9D69C18C-186C-45EA-A7DA-6ED7500E9C97";
-(NSMutableData *)data{

    if (_data == nil) {
        _data = [[NSMutableData alloc]init];
    }
    return _data;
}
-(NSMutableArray *)discoverdPeriparals{

    if (_discoverdPeriparals == nil) {
        _discoverdPeriparals = [[NSMutableArray alloc]init];
    }return _discoverdPeriparals;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    UIButton *btn = [MyControl creatButtonWithFrame:CGRectMake(100, 100, 50, 50) target:self sel:@selector(scanPeripherals) tag:0 image:nil title:@"扫描"];
    [self.view addSubview:btn];
    
    UIButton *btn1 = [MyControl creatButtonWithFrame:CGRectMake(200, 100, 50, 50) target:self sel:@selector(concantPeripherals) tag:1 image:nil title:@"连接"];
    [self.view addSubview:btn1];
}
-(void)concantPeripherals{
    if (self.discoverdPeriparals.count > 1) {
        [manager connectPeripheral:[self.discoverdPeriparals firstObject]  options:nil];
    }else{
        NSLog(@"没有找到外设");
    }
}
-(void)scanPeripherals{
    [manager scanForPeripheralsWithServices:nil options:nil];
}
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
        NSString * state = nil;
    switch ([central state])
    {
        case CBCentralManagerStateUnsupported:
            state = @"The platform/hardware doesn't support Bluetooth Low Energy.";
            break;
        case CBCentralManagerStateUnauthorized:
            state = @"The app is not authorized to use Bluetooth Low Energy.";
            break;
        case CBCentralManagerStatePoweredOff:
            state = @"Bluetooth is currently powered off.";
            break;
        case CBCentralManagerStatePoweredOn:
            state = @"work";
            break;
        case CBCentralManagerStateUnknown:
        default:
          break  ;
    }
    NSLog(@"%@",state);
    /**
     *  switch (central.state) {
     case CBCentralManagerStatePoweredOn:
     // Scans for any peripheral
     //            [manager scanForPeripheralsWithServices:@[ [CBUUID UUIDWithString:kServiceUUID] ] options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
     break;
     default:
     NSLog(@"Central Manager did change state");
     UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没有打开蓝牙" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:@"取消", nil];
     [alert show];
     break;
     }

     */
    }
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSString *str = [NSString stringWithFormat:@"Did discover peripheral. peripheral: %@ rssi: %@, UUID: %@ advertisementData: %@ ", peripheral, RSSI, peripheral.identifier.UUIDString, advertisementData];
    NSLog(@"%@",str);
    [self.discoverdPeriparals addObject:peripheral];
    NSLog(@"%ld",self.discoverdPeriparals.count);
    
}
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Did connect to peripheral: %@", peripheral);
    peripheral.delegate = self;
    [central stopScan];
    [peripheral discoverServices:nil];
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error)
    {
        NSLog(@"Discovered services for %@ with error: %@", peripheral.name, [error localizedDescription]);
        return;
    }
    for (CBService *service in peripheral.services)
    {
        NSLog(@"Service found with UUID: %@", service.UUID);
        if ([service.UUID isEqual:[CBUUID UUIDWithString:@"FFE0"]])
        {
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if (error) {
        NSLog(@"Error discovering characteristic: %@", [error localizedDescription]);
        [self cleanup];
        return;
    }
    if ([service.UUID isEqual:[CBUUID UUIDWithString:kServiceUUID]]) {
        for (CBCharacteristic *characteristic in service.characteristics) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kCharacteristicUUID]]) {
                [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            }
        }
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"Error changing notification state: %@", error.localizedDescription);
    }
    // Exits if it's not the transfer characteristic
    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:kCharacteristicUUID]]) {
        return;
    }
    // Notification has started
    if (characteristic.isNotifying) {
        NSLog(@"Notification began on %@", characteristic);
        [peripheral readValueForCharacteristic:characteristic];
    } else { // Notification has stopped
        // so disconnect from the peripheral
        NSLog(@"Notification stopped on %@.  Disconnecting", characteristic);
        [ manager cancelPeripheralConnection:self.peripheral];
    }
}





-(void)cleanup{

    
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
