//
//  GBoxFinderViewController.m
//  GBox
//
//  Created by DHIRAJ JADHAO on 15/02/14.
//  Copyright (c) 2014 DHIRAJJADHAO. All rights reserved.
//

#import "GBoxFinderViewController.h"
#import "HomeViewController.h"
#import <MapKit/MapKit.h>
#import "MapViewAnnotation.h"
#import <AudioToolbox/AudioToolbox.h>


@interface GBoxFinderViewController ()

{
    int level;
    int GBoxButtonStatus;
    NSString *value;
    
    NSString *latitudevalue;
    NSString *longitudevalue;
    
    double lati,longi;
    
    
    
}

@end

@implementation GBoxFinderViewController

@synthesize btHMSoftTableView;
@synthesize Scan;
@synthesize sensor;
@synthesize peripheralViewControllerArray;
@synthesize HMSoftUUID;
@synthesize tvRecv;
@synthesize rssi_container;
@synthesize GBoxName;
@synthesize locationManager;
@synthesize mapView;



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
    
  

   [mapView removeAnnotations:mapView.annotations];
    
    // Do any additional setup after loading the view from its nib.
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    sensor = [[SerialGATT alloc] init];
    [sensor setup];
    sensor.delegate = self;
    
    peripheralViewControllerArray = [[NSMutableArray alloc] init];
    

    ////// Retrieving GPS Coordinates
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    latitudevalue = [defaults objectForKey:@"SavedLatitude"];
    longitudevalue = [defaults objectForKey:@"SavedLongitude"];
    GBoxName.text = [defaults objectForKey:@"devicename"];
    
    
    NSLog(@"%@%@%@",latitudevalue,@",",longitudevalue);
    
    
}


- (void)viewDidUnload
{
    [self setBtHMSoftTableView:nil];
    [super viewDidUnload];
    mapView = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)updateBatterylabel
{
    NSString *str1 = [value substringToIndex:7];
    NSString *str2 = [value substringFromIndex:7];
    
    level = [str2 intValue];
    
    
    if([str1 isEqual: @"OK+Get:"]  && level >= 0)
	{
        
        batterylabel.text = [[NSString alloc] initWithFormat:@"%d", level];
        
    }
    
    
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
    GBoxFinderViewController *controller = [peripheralViewControllerArray objectAtIndex:row];
    
    if (sensor.activePeripheral && sensor.activePeripheral != controller.peripheral) {
        [sensor disconnect:sensor.activePeripheral];
    }
    
    sensor.activePeripheral = controller.peripheral;
    [sensor connect:sensor.activePeripheral];
    [sensor stopScan];
    
    [Scan setTitle:@"Scan" forState:UIControlStateNormal];
    
    NSLog(@"%@%lu",@"Index Row:",(unsigned long)row);
  
    
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
    GBoxFinderViewController *controller = [peripheralViewControllerArray objectAtIndex:row];
    CBPeripheral *peripheral = [controller peripheral];
    cell.textLabel.text = peripheral.name;
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
    GBoxFinderViewController *controller = [[GBoxFinderViewController alloc] init];
    controller.peripheral = peripheral;
    controller.sensor = sensor;
    [peripheralViewControllerArray addObject:controller];
    [btHMSoftTableView reloadData];
    
    
  
}



//recv data
-(void) serialGATTCharValueUpdated:(NSString *)UUID value:(NSData *)data
{
    value = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    tvRecv.text= [tvRecv.text stringByAppendingString:value];
    
    
    // scan
    NSString *separatorString = @":";
    
    NSArray *split = [value componentsSeparatedByString:separatorString];
    
    NSString* namePart = [split lastObject];
    
    
    //NSLog(@"element: %@", namePart);
    
    GBoxButtonStatus = [namePart intValue];
    
    
    
    
    
     if (GBoxButtonStatus == 2)
     {
         
     NSLog(@"GBox Button Status: %d",GBoxButtonStatus );    
     
     //////// Local Alert Settings
     
     AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
     
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Found my iPhone"
     message:@"I have found my iPhone"
     delegate:nil
     cancelButtonTitle:@"OK"
     otherButtonTitles:nil];
     [alert show];
     
     
     NSLog(@"iPhone Found Alert Sent");
     /////////////////////////////////////////////
     
     }
     
    
    
    
    
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
    
    GBoxName.text = self.sensor.activePeripheral.name;
    
    
    [self updateDeviceStatus];
    
   
    
    // Turns On Anti lost mode
    antilost.on = YES;
  
    
    [self antilost:self];
   
    
    //////
    
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
    
    antilost.on = NO;
    
    [aTimer invalidate];
    [gpsTimer invalidate];
    
    //////// Local Notification Settings
    
    UIApplication *app                = [UIApplication sharedApplication];
    Disconnectionnotification = [[UILocalNotification alloc] init];
    NSArray *oldNotifications         = [app scheduledLocalNotifications];
    
    if ([oldNotifications count] > 4)
    {
        [app cancelAllLocalNotifications];
    }
    
    if (Disconnectionnotification == nil)
        return;
    
    //NSDate *notificationDate = [NSDate dateWithTimeIntervalSinceNow:10];
    
    //notification.fireDate  = notificationDate;
    //notification.timeZone  = [NSTimeZone systemTimeZone];
    
    NSString *name = [NSString stringWithFormat:@"%@%@%@",@"Your ",GBoxName.text,@" got Disconnected from your Phone"];
    
    Disconnectionnotification.alertBody = name;
    Disconnectionnotification.soundName = @"gboxnote.mp3";
    
    [app scheduleLocalNotification:Disconnectionnotification];
    
   // NSLog(@"Disconnection Notification Sent");
    
    
    //////// Local Alert Settings

    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Disconnected"
                                                    message:@"Your iPhone got Disconnected from GBox Device"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    
    NSLog(@"Disconnection Alert Sent");
    /////////////////////////////////////////////
    
    
    //////
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    
    NSString *SavedLatitude = latitudevalue;
    [defaults setObject:SavedLatitude forKey:@"SavedLatitude"];
    
    NSString *SavedLongitude  = longitudevalue;
    [defaults setObject:SavedLongitude forKey:@"SavedLongitude"];
    
    NSString *devicename  = GBoxName.text;
    [defaults setObject:devicename forKey:@"devicename"];
    
    //////
    
    
   }









-(void)updateDistanceofGBox:(NSTimer *) theTimer
{

   
    NSLog(@"Position Updated");
    
    NSData *rssidata = [@"AT+RSSI?" dataUsingEncoding:[NSString defaultCStringEncoding]];
    
    
    
    [sensor write:sensor.activePeripheral data:rssidata];

    
    //[self sendNotification];

    
    // scan
    NSString *separatorString = @":";
    
    NSArray *split = [value componentsSeparatedByString:separatorString];
    
    NSString* namePart = [split lastObject];
    
    
    //NSLog(@"element: %@", namePart);
    
    level = [namePart intValue];
    
    NSLog(@"Incoming Value: %d",level );
    
    
    [self sendNotification];
    

   
}


-(void)sendNotification
{

   
    if([devicestatus.text  isEqual: @"Connected"] && level <= - 95)
	{
        //////// Local Notification Settings
        
        UIApplication *app = [UIApplication sharedApplication];
        notification = [[UILocalNotification alloc] init];
        NSArray *oldNotifications = [app scheduledLocalNotifications];
        
        if ([oldNotifications count] > 0) {
            [app cancelAllLocalNotifications];
        }
        
        if (notification == nil)
            return;
        
        //NSDate *notificationDate = [NSDate dateWithTimeIntervalSinceNow:10];
        
        //notification.fireDate  = notificationDate;
        //notification.timeZone  = [NSTimeZone systemTimeZone];
        
        NSString *name = [NSString stringWithFormat:@"%@%@",@"Don't Forget behind your ",GBoxName.text];
        
        notification.alertBody = name;
        notification.soundName = @"gboxnote.mp3";
        
        [app scheduleLocalNotification:notification];
        
        
        
    }
    
    
    else if([devicestatus.text  isEqual: @"Connected"] && level > -95  && level < 0)
    {
    
        NSLog(@"%@",@"Reminder Notification Stopped");
        
       [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
    
    }

        
}






-(void)getCurrentGPSCoordinates:(NSTimer *) theTimer
{
    locationManager = [[CLLocationManager alloc] init];
    //locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    CLLocation *location = [locationManager location];
    // Configure the new event with information from the location
    CLLocationCoordinate2D coordinate = [location coordinate];
    latitudevalue = [NSString stringWithFormat:@"%f", coordinate.latitude];
    longitudevalue = [NSString stringWithFormat:@"%f", coordinate.longitude];
    
    NSLog(@"dLatitude : %@", latitudevalue);
    NSLog(@"dLongitude : %@",longitudevalue);
    
    
    [latitudetextvalue setText:latitudevalue];
    [longitudetextvalue setText:longitudevalue];
    
    /*
     UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 40, 250, 50)];
     UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 80, 200, 50)];
     UILabel *myLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(50, 120, 200, 100)];
     myLabel.textColor = [UIColor blackColor];
     myLabel1.textColor = [UIColor blackColor];
     label.backgroundColor = [UIColor clearColor];
     myLabel.backgroundColor = [UIColor clearColor];
     myLabel1.backgroundColor = [UIColor clearColor];
     yLabel setText:latitude];
     [myLabel1 setText:longitude];
     label.text = @"Current Latitude And Longitude";
     [self.view addSubview:label];
     [self.view addSubview:myLabel];
     [self.view addSubview:myLabel1];
     
     */
    
}




- (IBAction)antilost:(id)sender {
    
    if(antilost.on  && [devicestatus.text isEqual:@"Connected"])
    {
        
            //// Postion Update Timer
        aTimer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                  target:self
                                                selector:@selector(updateDistanceofGBox:)
                                                userInfo:nil
                                                 repeats:YES];
        
        gpsTimer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                  target:self
                                                selector:@selector(getCurrentGPSCoordinates:)
                                                userInfo:nil
                                                 repeats:YES];
        
        NSLog(@"Anti Lost Mode On");
        
        
          
    }
        
    
    else
    {
        
        antilost.on = NO;
        
        NSLog(@"Anti Lost Mode Off");
        
        [aTimer invalidate];
        [gpsTimer invalidate];
        
    
    }
    
    
}




- (IBAction)Back:(id)sender
{
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    
    NSString *SavedLatitude = latitudevalue;
    [defaults setObject:SavedLatitude forKey:@"SavedLatitude"];
    
    NSString *SavedLongitude  = longitudevalue;
    [defaults setObject:SavedLongitude forKey:@"SavedLongitude"];
    
    NSString *devicename  = GBoxName.text;
    [defaults setObject:devicename forKey:@"devicename"];
    
    
    
    
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
    
    antilost.on = NO;
  
    [aTimer invalidate];
    [gpsTimer invalidate];
    
    
    
  
}



-(void) BuzzOn:(NSTimer *) theTimer
{
    NSData *beepon = [@"AT+PIO21" dataUsingEncoding:[NSString defaultCStringEncoding]];
    
    
    
    [sensor write:sensor.activePeripheral data:beepon];
    
    NSString *string= [NSString stringWithUTF8String:[beepon bytes]];
    
    
    NSLog(@"%@",string);
}

-(void) BuzzOff:(NSTimer *) theTimer
{
    NSData *beepoff = [@"AT+PIO20" dataUsingEncoding:[NSString defaultCStringEncoding]];
    
    
    
    [sensor write:sensor.activePeripheral data:beepoff];
    
    NSString *string= [NSString stringWithUTF8String:[beepoff bytes]];
    
    
    NSLog(@"%@",string);

}





- (IBAction)batterylevel:(id)sender {
    
    NSData *beepoff = [@"AT+BATT?" dataUsingEncoding:[NSString defaultCStringEncoding]];
    
    
    
    [sensor write:sensor.activePeripheral data:beepoff];
    
    //NSString *string= [NSString stringWithUTF8String:[beepoff bytes]];
    
    NSLog(@"%@",value);
    
    
    [self updateBatterylabel];
    
}

- (IBAction)mapmode:(id)sender {
    
    if (mapmode.selectedSegmentIndex == 0)
    {
     mapView.mapType = MKMapTypeStandard;
    }
    else if (mapmode.selectedSegmentIndex == 1)
    {
    mapView.mapType = MKMapTypeSatellite;
    }
    else if (mapmode.selectedSegmentIndex == 2)
    {
        mapView.mapType = MKMapTypeHybrid;
    }
    
}



- (IBAction)map:(id)sender
{
    // removes all annotation from the map
   
    
    
    lati = [latitudevalue doubleValue];
    longi = [longitudevalue doubleValue];
  

    
	CLLocationCoordinate2D location;
	location.latitude = lati;
	location.longitude = longi;
    
    
    
	// Add the annotation to our map view
	
    MapViewAnnotation *newAnnotation = [[MapViewAnnotation alloc] initWithTitle:GBoxName.text andCoordinate:location];
	[self.mapView addAnnotation:newAnnotation];
    
    if (mapView.hidden == YES)
    {
        
        mapView.hidden = NO;
        mapmodeview.hidden = NO;
    }
    
    else
    {
    
        mapView.hidden = YES;
        mapmodeview.hidden = YES;
    
    }
    
	
   
}



- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
	MKAnnotationView *annotationView = [views objectAtIndex:0];
	id <MKAnnotation> mp = [annotationView annotation];
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([mp coordinate], 1500, 1500);
	
    
    
    [mv setRegion:region animated:YES];
	[mv selectAnnotation:mp animated:YES];
}


- (IBAction)Buzzer:(id)sender
{
    if (Buzzer.on)
    {
        BuzzOnTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                       target:self
                                                     selector:@selector(BuzzOn:)
                                                     userInfo:nil
                                                      repeats:YES];
        
        
        BuzzOffTimer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                        target:self
                                                      selector:@selector(BuzzOff:)
                                                      userInfo:nil
                                                       repeats:YES];
    }
    
    else
    {
        [BuzzOnTimer invalidate];
        [BuzzOffTimer invalidate];
        
        NSData *beepoff = [@"AT+PIO20" dataUsingEncoding:[NSString defaultCStringEncoding]];
        
        
        
        [sensor write:sensor.activePeripheral data:beepoff];
        
        NSString *string= [NSString stringWithUTF8String:[beepoff bytes]];
        
        
        NSLog(@"%@",string);
        
    }
    
}





@end
