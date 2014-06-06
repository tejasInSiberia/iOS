//
//  SettingsViewController.m
//  GBox
//
//  Created by DHIRAJ JADHAO on 09/02/14.
//  Copyright (c) 2014 DHIRAJJADHAO. All rights reserved.
//

#import "SettingsViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize btHMSoftTableView;
@synthesize Scan;
@synthesize sensor;
@synthesize peripheralViewControllerArray;
@synthesize HMSoftUUID;
@synthesize tvRecv;
@synthesize rssi_container;
@synthesize GBoxName;
@synthesize ConnectedDevice;
@synthesize GBoxPassword;


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
    GBoxName.text = [defaults objectForKey:@"DeviceName"];
    
    
    
    
    
    // Do any additional setup after loading the view from its nib.
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    sensor = [[SerialGATT alloc] init];
    [sensor setup];
    sensor.delegate = self;
    
    peripheralViewControllerArray = [[NSMutableArray alloc] init];
    
}

- (void)viewDidUnload
{
    [self setBtHMSoftTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void) scanTimer:(NSTimer *)timer
{
    [Scan setTitle:@"Scan" forState:UIControlStateNormal];
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
    
    [Scan setTitle:@"Scan" forState:UIControlStateNormal];
    
    
    
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
    //cell.detailTextLabel.text = [NSString stringWithFormat:<#(NSString *), ...#>
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
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
    [btHMSoftTableView reloadData];
}



//recv data
-(void) serialGATTCharValueUpdated:(NSString *)UUID value:(NSData *)data
{
    NSString *value = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    tvRecv.text= [tvRecv.text stringByAppendingString:value];
}




-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


-(void)setConnect
{
    CFStringRef s = CFUUIDCreateString(kCFAllocatorDefault, (__bridge CFUUIDRef )sensor.activePeripheral.identifier);
    HMSoftUUID.text = (__bridge NSString*)s;
    tvRecv.text = @"OK+CONN";
    
    ConnectedDevice.text = self.sensor.activePeripheral.name;
    GBoxName.text = self.sensor.activePeripheral.name;
    
    
    
    [self updateDeviceStatus];
    
    
    //////// Local Alert Settings
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connected"
                                                    message:@"Your iPhone got Connected to GBox Device"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    
    NSLog(@"Connection Alert Sent");
    /////////////////////////////////////////////

    
    
}


-(void)updateDeviceStatus
{
    
    
    if([tvRecv.text isEqual: @"OK+CONN"])
	{
        
        devicestatus.textColor = [UIColor greenColor];
        devicestatus.text = @"Connected";
        
    }
    
    
    
    
}




-(void)setDisconnect
{
    tvRecv.text= [tvRecv.text stringByAppendingString:@"OK+LOST"];
    
    devicestatus.textColor = [UIColor whiteColor];
    devicestatus.text = @"Disconnected";
    
}




- (IBAction)Back:(id)sender
{
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}



- (IBAction)scanHMSoftDevices:(id)sender
{
    if ([sensor activePeripheral]) {
        if (sensor.activePeripheral.state == CBPeripheralStateConnected)
        {
            [sensor.manager cancelPeripheralConnection:sensor.activePeripheral];
            sensor.activePeripheral = nil;
        }
    }
    
    if ([sensor peripherals]) {
        sensor.peripherals = nil;
        [peripheralViewControllerArray removeAllObjects];
        [btHMSoftTableView reloadData];
    }
    
    sensor.delegate = self;
    printf("now we are searching device...\n");
    [Scan setTitle:@"Scanning" forState:UIControlStateNormal];
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scanTimer:) userInfo:nil repeats:NO];
    
    [sensor findHMSoftPeripherals:5];
    
    devicestatus.textColor = [UIColor whiteColor];
    devicestatus.text = @"Disconnected";
    
}

- (IBAction)Set:(id)sender {
 
    
    //NSData *data = [@"AT+NAME" dataUsingEncoding:[NSString defaultCStringEncoding]];
    
    NSData *AT = [@"AT+NAME" dataUsingEncoding:[NSString defaultCStringEncoding]];
    
   
    
    NSData *DeviceName = [GBoxName.text dataUsingEncoding:[NSString defaultCStringEncoding]];
    
    //NSString *DeviceName = [NSString stringWithFormat:@"%@", GBoxName.text];
    
    
    NSMutableData *name = [NSMutableData data];
    [name appendData:AT];
    [name appendData:DeviceName];
    
    
    
    
    [sensor write:sensor.activePeripheral data:name];
    
    NSString *string= [NSString stringWithUTF8String:[name bytes]];
    
   
    NSLog(@"%@",string);
    
    
    [self resetGBox];
    
    [self setDisconnect];
    
    //////// Local Alert Settings
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"GBox Device Name Changed"
                                                    message:@"Name of your GBox Device has been successfully changed"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    
    NSLog(@"Name Change Alert Sent");
    /////////////////////////////////////////////
    
}

- (IBAction)ChangePassword:(id)sender
{
    NSData *AT = [@"AT+PASS" dataUsingEncoding:[NSString defaultCStringEncoding]];
    
    
    
    NSData *DevicePassword = [GBoxPassword.text dataUsingEncoding:[NSString defaultCStringEncoding]];
    
    
    
    
    NSMutableData *name = [NSMutableData data];
    [name appendData:AT];
    [name appendData:DevicePassword];
    
    
    
    
    [sensor write:sensor.activePeripheral data:name];
    
    NSString *string= [NSString stringWithUTF8String:[name bytes]];
    
    
    NSLog(@"Password Changed To: %@",string);
    
    
    [self resetGBox];
    
    [self setDisconnect];
    
    //////// Local Alert Settings
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"GBox Device Password Changed"
                                                    message:@"Password of your GBox Device has been successfully changed"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    
    NSLog(@"Password Change Alert Sent");
    /////////////////////////////////////////////

    
    
    
}


-(void)resetGBox
{

     NSData *AT1 = [@"AT+RESET" dataUsingEncoding:[NSString defaultCStringEncoding]];
    
    [sensor write:sensor.activePeripheral data:AT1];
    
    NSString *reset= [NSString stringWithUTF8String:[AT1 bytes]];
    
    NSLog(@"%@",reset);
    
}


@end
