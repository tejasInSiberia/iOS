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
@synthesize TAHUUID;
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
    
    requiredPassword.enabled = NO; // disables device password field
    requiredPassword.alpha = 0.2;
    
    
    // Do any additional setup after loading the view from its nib.
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    sensor = [[TAHble alloc] init];
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
    
    [self updateDeviceStatus];
    
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
    
    [sensor findTAHPeripherals:5];
    
    
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


#pragma mark - TAHSensorDelegate
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



//received data

-(void) TAHbleCharValueUpdated:(NSString *)UUID value:(NSData *)data
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
    TAHUUID.text = (__bridge NSString*)s;
    value = @"OK+CONN";
    

    
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
    
    
    if(sensor.activePeripheral.state)
	{
        
        
        ConnectedDeviceName.text = self.sensor.activePeripheral.name;  // Sets connected device name
        requiredName.text = self.sensor.activePeripheral.name;
        
        devicestatus.textColor = [UIColor greenColor];
        devicestatus.text = @"Connected";

        
    }
    
    else
    {
    
        devicestatus.textColor = [UIColor whiteColor];
        devicestatus.text = @"Disconnected";
    
    }
    
    
    
    
}




-(void)setDisconnect
{

    tvRecv.text= [tvRecv.text stringByAppendingString:@"OK+LOST"];
    [sensor disconnect:sensor.activePeripheral];
    
    [self updateDeviceStatus];
    
}






- (IBAction)ApplySettings:(id)sender
{
    if (sensor.activePeripheral.state)
    {
       
        
        
        
        [sensor setTAHDeviceName:sensor.activePeripheral Name:requiredName.text];
        NSLog(@"Name Changed to: %@",requiredName.text);
        

        [sensor setTAHSecurityPin:sensor.activePeripheral Pin:requiredPassword.text];
        NSLog(@"Password Changed To: %@",requiredPassword.text);
        

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
        
        
        [sensor resetTAH:sensor.activePeripheral]; //resets TAH
        
        
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
    
    
    [self updateDeviceStatus];
}


- (IBAction)turnoffpin:(id)sender
{
    
    [sensor setTAHSecurityType:sensor.activePeripheral WithPin:NO];
    NSLog(@"Device Pairing with PIN OFF");
    
    requiredPassword.enabled = NO;
    requiredPassword.alpha = 0.2;
    
    
}

- (IBAction)turnonpin:(id)sender {
    
    [sensor setTAHSecurityType:sensor.activePeripheral WithPin:YES];
    NSLog(@"Device Pairing with PIN OFF");
    
    requiredPassword.enabled = YES;
    requiredPassword.alpha = 1.0;
}

@end
