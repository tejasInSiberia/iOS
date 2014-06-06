//
//  SettingsViewController.m
//  TAH
//
//  Created by DHIRAJ JADHAO on 09/02/14.
//  Copyright (c) 2014 DHIRAJJADHAO. All rights reserved.
//

#import "SettingsViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "RefreshControl.h"

@interface SettingsViewController ()
{
    NSString *value;
}
@end

@implementation SettingsViewController

@synthesize TAHTableView;

@synthesize sensor;
@synthesize peripheralViewControllerArray;
@synthesize HMSoftUUID;
@synthesize tvRecv;
@synthesize rssi_container;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    requiredName.text = [defaults objectForKey:@"DeviceName"];
    
    
    
    
    
    // Do any additional setup after loading the view from its nib.
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    sensor = [[SerialGATT alloc] init];
    [sensor setup];
    sensor.delegate = self;
    
    peripheralViewControllerArray = [[NSMutableArray alloc] init];
    
    
    
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.TAHTableView];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    
}

- (void)viewDidUnload
{
    [self setTAHTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewDidDisappear:(BOOL)animated
{
    if (sensor.activePeripheral.state)
    {
        [self setDisconnect];  // Disconnect from TAH Board before transiting to different view.
    }
    
}



- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    
    double delayInSeconds = 5.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [refreshControl endRefreshing];
    });
    
    [self scanTAHDevices];
    
}


-(void) scanTAHDevices
{
    
    if ([sensor activePeripheral]) {
        if (sensor.activePeripheral.state == CBPeripheralStateConnected) {
            [sensor.manager cancelPeripheralConnection:sensor.activePeripheral];
            sensor.activePeripheral = nil;
        }
    }
    
    if ([sensor peripherals]) {
        sensor.peripherals = nil;
        [peripheralViewControllerArray removeAllObjects];
        [TAHTableView reloadData];
    }
    
    sensor.delegate = self;
    printf("now we are searching device...\n");
        [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scanTimer:) userInfo:nil repeats:NO];
    
    [sensor findHMSoftPeripherals:5];
    
    
}


-(void) scanTimer:(NSTimer *)timer
{
    
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.peripheralViewControllerArray count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    SettingsViewController *controller = [peripheralViewControllerArray objectAtIndex:row];
    
    if (sensor.activePeripheral && sensor.activePeripheral != controller.peripheral) {
        [sensor disconnect:sensor.activePeripheral];
    }
    
    sensor.activePeripheral = controller.peripheral;
    [sensor connect:sensor.activePeripheral];
    [sensor stopScan];
 
    
    
    
    //[self.navigationController pushViewController:controller animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"peripheral";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    // Configure the cell
    NSUInteger row = [indexPath row];
    SettingsViewController *controller = [peripheralViewControllerArray objectAtIndex:row];
    CBPeripheral *peripheral = [controller peripheral];
    cell.textLabel.text = peripheral.name;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    cell.textLabel.textColor = [UIColor colorWithRed:0.0 / 255.0 green:174.0 / 255.0 blue:239.0 / 255.0 alpha:1.0];
    
    return cell;
}


#pragma mark - HMSoftSensorDelegate
-(void)sensorReady
{
    //TODO: it seems useless right now.
}

-(void) peripheralFound:(CBPeripheral *)peripheral
{
    SettingsViewController *controller = [[SettingsViewController alloc] init];
    controller.peripheral = peripheral;
    controller.sensor = sensor;
    [peripheralViewControllerArray addObject:controller];
    [TAHTableView reloadData];
}



//recv data
-(void) serialGATTCharValueUpdated:(NSString *)UUID value:(NSData *)data
{
    value = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    tvRecv.text= [tvRecv.text stringByAppendingString:value];
}




-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [requiredName resignFirstResponder];
    [requiredPassword resignFirstResponder];
    return YES;
}


-(void)setConnect
{
    CFStringRef s = CFUUIDCreateString(kCFAllocatorDefault, (__bridge CFUUIDRef )sensor.activePeripheral.identifier);
    HMSoftUUID.text = (__bridge NSString*)s;
    value = @"OK+CONN";
    
    ConnectedDeviceName.text = self.sensor.activePeripheral.name;
    requiredName.text = self.sensor.activePeripheral.name;
    
    
    
    [self updateDeviceStatus];
    
    
    //////// Local Alert Settings
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connected"
                                                    message:@"Your iPhone got Connected to TAH Device"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    
    NSLog(@"Connection Alert Sent");
    /////////////////////////////////////////////
    
    
    
}


-(void)updateDeviceStatus
{
    
    
    if([value isEqual: @"OK+CONN"])
	{
        
        devicestatus.textColor = [UIColor greenColor];
        devicestatus.text = @"Connected";
        
    }
    
    
    
    
}




-(void)setDisconnect
{
    tvRecv.text= [tvRecv.text stringByAppendingString:@"OK+LOST"];
    [sensor disconnect:sensor.activePeripheral];
    devicestatus.textColor = [UIColor whiteColor];
    devicestatus.text = @"Disconnected";
    
}







- (IBAction)changeName:(id)sender {
    
    if (sensor.activePeripheral.state)
    {
        //NSData *data = [@"AT+NAME" dataUsingEncoding:[NSString defaultCStringEncoding]];
        
        NSData *AT = [@"AT+NAME" dataUsingEncoding:[NSString defaultCStringEncoding]];
        
        
        
        NSData *DeviceName = [requiredName.text dataUsingEncoding:[NSString defaultCStringEncoding]];
        
        //NSString *DeviceName = [NSString stringWithFormat:@"%@", requiredName.text];
        
        
        NSMutableData *name = [NSMutableData data];
        [name appendData:AT];
        [name appendData:DeviceName];
        
        
        
        
        [sensor write:sensor.activePeripheral data:name];
        
        NSString *string= [NSString stringWithUTF8String:[name bytes]];
        
        
        NSLog(@"%@",string);
        
        
        [self resetTAH];
        
        [self setDisconnect];
        
        //////// Local Alert Settings
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TAH Device Name Changed"
                                                        message:@"Name of your TAH Device has been successfully changed"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        
        NSLog(@"Name Change Alert Sent");
        /////////////////////////////////////////////
    }
    
    else
    {
        //////// Local Alert Settings
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connect to Device"
                                                        message:@"Please Connect to TAH device first"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        
        NSLog(@"Name Change Alert Sent");
        /////////////////////////////////////////////
    }
    
    
}

- (IBAction)changePassword:(id)sender
{
    
    if (sensor.activePeripheral.state)
    {
        
        
        NSData *pairwithpin = [@"AT+TYPE2" dataUsingEncoding:[NSString defaultCStringEncoding]];
        
        [sensor write:sensor.activePeripheral data:pairwithpin];
        
        NSLog(@"Device Pairing set to with PIN");
        
        
        
        NSData *AT = [@"AT+PASS" dataUsingEncoding:[NSString defaultCStringEncoding]];
        NSData *DevicePassword = [requiredPassword.text dataUsingEncoding:[NSString defaultCStringEncoding]];
        
        NSMutableData *name = [NSMutableData data];
        [name appendData:AT];
        [name appendData:DevicePassword];
        
        
        [sensor write:sensor.activePeripheral data:name];
        
        NSString *string= [NSString stringWithUTF8String:[name bytes]];
        NSLog(@"Password Changed To: %@",string);
        
        
        [self resetTAH];
        
        [self setDisconnect];
        
        //////// Local Alert Settings
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TAH Device Password Changed"
                                                        message:@"Password of your TAH Device has been successfully changed"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        
        NSLog(@"Password Change Alert Sent");
        /////////////////////////////////////////////
    
    }
    
    else
    {
        //////// Local Alert Settings
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connect to Device"
                                                        message:@"Please Connect to TAH device first"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        
        NSLog(@"Name Change Alert Sent");
        /////////////////////////////////////////////
    }
    
    
    
    
    
    
    
}

- (IBAction)turnoffpin:(id)sender
{
 
        NSData *pairwithpin = [@"AT+TYPE0" dataUsingEncoding:[NSString defaultCStringEncoding]];
        
        [sensor write:sensor.activePeripheral data:pairwithpin];
        
        NSLog(@"Device Pairing with PIN OFF");
        
        requiredPassword.enabled = NO;
        changePassword.enabled = NO;
        
        [self resetTAH];
        
    
        
  
}


-(void)resetTAH
{
    
    NSData *AT1 = [@"AT+RESET" dataUsingEncoding:[NSString defaultCStringEncoding]];
    
    [sensor write:sensor.activePeripheral data:AT1];
    
    NSString *reset= [NSString stringWithUTF8String:[AT1 bytes]];
    
    NSLog(@"%@",reset);
    
}


@end
