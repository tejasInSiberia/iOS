//
//  ViewController.m
//  Tah Motion Control
//
//  Created by DHIRAJ JADHAO on 21/04/14.
//  Copyright (c) 2014 DHIRAJJADHAO. All rights reserved.
//



#import "ViewController.h"

@interface ViewController ()
{
    NSString *command;
}
@end

@implementation ViewController

@synthesize btHMSoftTableView;
@synthesize Scan;
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
        [self updateall];
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Do any additional setup after loading the view from its nib.
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    sensor = [[SerialGATT alloc] init];
    [sensor setup];
    sensor.delegate = self;
    
    peripheralViewControllerArray = [[NSMutableArray alloc] init];
    
    
    scanner.hidden = YES;
    gestureviewcontroller.hidden = YES;
    
    command = @" ";
    
    
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = .1;
    self.motionManager.gyroUpdateInterval = .1;
    
    
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



- (void) scanTimer:(NSTimer *)timer
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
    ViewController *controller = [peripheralViewControllerArray objectAtIndex:row];
    
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
    ViewController *controller = [peripheralViewControllerArray objectAtIndex:row];
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
    ViewController *controller = [[ViewController alloc] init];
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
    
    
    
    
    
    
    //////// Local Alert Settings
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connected"
                                                    message:@"Your iPhone got Connected to GBox Device"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    
    NSLog(@"Connection Alert Sent");
    /////////////////////////////////////////////
    
    
    
}



-(void)setDisconnect
{
    tvRecv.text= [tvRecv.text stringByAppendingString:@"OK+LOST"];
    
    motion.on = NO;
    
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
    
    
    
}

-(void) updateall
{
    
    if(motion.on)
    {
        
        [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                                 withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                                     [self MotiondPad:accelerometerData.acceleration];
                                                     if(error){
                                                         
                                                         NSLog(@"%@", error);
                                                     }
                                                 }];
        
        
        
        [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
                                        withHandler:^(CMGyroData *gyroData, NSError *error) {
                                            [self outputRotationData:gyroData.rotationRate];
                                        }];
        
        NSLog(@"Motion Sensor Started");
        
    }
    
    else
    {
        
        [self.motionManager startAccelerometerUpdates];
        [self.motionManager stopGyroUpdates];
        
        NSLog(@"Motion Sensor Stopped");
        
    }
    
    
    
    
    
    
}


-(void)outputRotationData:(CMRotationRate)rotation
{
    
    sensvalue.text = [NSString stringWithFormat:@"%.2f",sensslider.value];
    
    //NSLog(@"X Rotation: %.2f", rotation.x);
    //NSLog(@"Y Rotation: %.2f", rotation.y);
    //NSLog(@"Z Rotation: %.2f", rotation.z);
    
    if (rotation.x >= sensslider.value  && !music.touchInside) {
        
        
        
        NSLog(@"Right to Left");
        
        
        
        NSString *end=@"M";
        
        NSString *L = @"5";
        NSString *R = @"6";
        
        command = [NSString stringWithFormat:@"%@%@%@",R,L,end];
        [self sendCommand];
    }
    
    
 
    
    
    
    else if (rotation.x <= -sensslider.value  &&  !music.touchInside)
    {
        
        
        NSLog(@"Left to Right");
        
        
        
        NSString *end=@"M";
        
        NSString *L = @"5";
        NSString *R = @"6";
        
        command = [NSString stringWithFormat:@"%@%@%@",L,R,end];
        
        [self sendCommand];
        
    }
    
    else if (prev.touchInside)
    {
        
        
        NSLog(@"Left Arrow Key");
        
        
        
        NSString *end=@"M";
        
        NSString *L = @"1";
        NSString *R = @"0";
        
        command = [NSString stringWithFormat:@"%@%@%@",L,R,end];
        
        [self sendCommand];
        
    }
    
    if (next.touchInside) {
        
        
        
        NSLog(@"Right Arrow key");
        
        
        
        NSString *end=@"M";
        
        NSString *L = @"2";
        NSString *R = @"0";
        
        command = [NSString stringWithFormat:@"%@%@%@",L,R,end];
        [self sendCommand];
    }
    
    
    
    else if (rotation.z >= sensslider.value  && !music.touchInside ) {
        
        
        
        NSLog(@"Up to Down");
        
        
        
        NSString *end=@"M";
        
        NSString *U = @"3";
        NSString *D = @"4";
        
        command = [NSString stringWithFormat:@"%@%@%@",U,D,end];
        
        [self sendCommand];
        
    }
    
    else if (play.touchInside) {
        
        
        
        NSLog(@"Space Bar");
        
        
        
        NSString *end=@"M";
        
        NSString *U = @"3";
        NSString *D = @"0";
        
        command = [NSString stringWithFormat:@"%@%@%@",U,D,end];
        
        [self sendCommand];
        
    }
    
    
    
    
    else if (rotation.z <= -sensslider.value)
    {
        
        
        
        NSLog(@"Down to Up");
        
        
        
        NSString *end=@"M";
        
        NSString *U = @"3";
        NSString *D = @"4";
        
        command = [NSString stringWithFormat:@"%@%@%@",D,U,end];
        
        [self sendCommand];
    }
    
    
    else if (rotation.x >= 2  && rotation.y <= -2   && rotation.z <= -2)
    {
        
        
        
        NSLog(@"Round and Round");
        
        
        
        NSString *end=@"M";
        
        NSString *X = @"5";
        NSString *Y = @"5";
        
        command = [NSString stringWithFormat:@"%@%@%@",X,Y,end];
        
        [self sendCommand];
    }
    
    
    
    else if(!zoom.touchInside  && !music.touchInside)
    {
        
        
        
        NSString *end=@"M";
        
        NSString *M = @"0";
        NSString *N = @"0";
        
        command = [NSString stringWithFormat:@"%@%@%@",M,N,end];
        
        [self sendCommand];
    }
    
    
}





- (void)MotiondPad:(CMAcceleration)acceleration
{
    NSLog(@"X acceleration:%.2f",acceleration.x);
    NSLog(@"Y acceleration:%.2f",acceleration.y);
    NSLog(@"Z acceleration:%.2f",acceleration.z);
    
    if (zoom.touchInside  && acceleration.x > 0)
    {
        
        NSString *end=@"M";
        
        NSString *M = @"9";
        NSString *N = @"8";
        
        command = [NSString stringWithFormat:@"%@%@%@",M,N,end];
        
        [self sendCommand];
    }
    
    else if (zoom.touchInside  && acceleration.x < 0)
    {
        
        NSString *end=@"M";
        
        NSString *M = @"9";
        NSString *N = @"9";
        
        command = [NSString stringWithFormat:@"%@%@%@",M,N,end];
        
        [self sendCommand];
    }

    
    else if (music.touchInside  && acceleration.x > 0.6)
    {
        
        NSString *end=@"M";
        
        NSString *M = @"9";
        NSString *N = @"6";
        
        command = [NSString stringWithFormat:@"%@%@%@",M,N,end];
        
        [self sendCommand];
    }
    
    
    else if (music.touchInside  && acceleration.x < -0.6)
    {
        
        NSString *end=@"M";
        
        NSString *M = @"9";
        NSString *N = @"7";
        
        command = [NSString stringWithFormat:@"%@%@%@",M,N,end];
        
        [self sendCommand];
    }

    
    
    
}

- (void)sendCommand
{
    
    //////// Bluetoth Data to be Sent will come below ///////////
    
    NSLog(@"%@",command);  // Shows Commans Value in Xcode O/P WIndow
    
    
    NSData *data = [command dataUsingEncoding:[NSString defaultCStringEncoding]];
    
    
    [sensor write:sensor.activePeripheral data:data];
    
    /////////////////////////////////////////////////////////////
    
    [self updateall];
    
}



- (IBAction)done:(id)sender {
    
    if (scanner.hidden == YES)
    {
        scanner.hidden = NO;
    }
    else
    {
        scanner.hidden = YES;
    }
    
    
}





- (IBAction)motion:(id)sender {
    
    [self updateall];
    
    
}

- (IBAction)dismiss:(id)sender {
    
    gestureviewcontroller.hidden = YES;
}



- (IBAction)gestureview:(id)sender {
    
    

    gestureviewcontroller.hidden = NO;
}

- (IBAction)new:(id)sender {




}



- (IBAction)left:(id)sender {
    
    
    NSString *end=@"M";
    
    NSString *X = @"6";
    NSString *Y = @"1";
    
    command = [NSString stringWithFormat:@"%@%@%@",X,Y,end];
    
    [self sendCommand];
    
    NSLog(@"Left Swipe");
    
}


- (IBAction)right:(id)sender {
    
    
    NSString *end=@"M";
    
    NSString *X = @"6";
    NSString *Y = @"2";
    
    command = [NSString stringWithFormat:@"%@%@%@",X,Y,end];
    [self sendCommand];
    
    NSLog(@"Right Swipe");
    
    
}


- (IBAction)up:(id)sender {
    
    
    NSString *end=@"M";
    
    NSString *X = @"6";
    NSString *Y = @"3";
    
    command = [NSString stringWithFormat:@"%@%@%@",X,Y,end];
    
    [self sendCommand];
    
    
    NSLog(@"Up Swipe");
}

- (IBAction)down:(id)sender {
    
    
    NSString *end=@"M";
    
    NSString *X = @"6";
    NSString *Y = @"4";
    
    command = [NSString stringWithFormat:@"%@%@%@",X,Y,end];
    
    [self sendCommand];
    
    
    NSLog(@"Down Swipe");
    
}

- (IBAction)leftmouseclick:(id)sender {
    
    NSString *end=@"M";
    
    NSString *X = @"7";
    NSString *Y = @"5";
    
    command = [NSString stringWithFormat:@"%@%@%@",X,Y,end];
    
    [self sendCommand];
    
    
    NSLog(@"Left Mouse Click");
    
}





@end
