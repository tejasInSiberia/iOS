//
//  iTunesViewController.m
//  TAH Motion Control
//
//  Created by Dhiraj on 24/08/14.
//  Copyright (c) 2014 dhirajjadhao. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "iTunesViewController.h"


@interface iTunesViewController ()
{
    NSString *command;
}
@end

@implementation iTunesViewController

@synthesize sensor;
@synthesize peripheral;
@synthesize sensslider;
@synthesize sensvalue;

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
    // Do any additional setup after loading the view.
    
    
    // Settings Up Sensor Delegate
    self.sensor.delegate = self;
    
    
    // Set Connection Status Image
    [self UpdateConnectionStatusLabel];
    
    // Starts gyro updates
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = .1;
    self.motionManager.gyroUpdateInterval = .1;
    
    [self updateall];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    // Starts gyro updates
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.gyroUpdateInterval = .1;
    
    [self updateall];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



-(void)viewWillAppear:(BOOL)animated
{
    // Set Connection Status Image
    [self UpdateConnectionStatusLabel];
}


-(void)viewDidDisappear:(BOOL)animated
{
    
    [self.motionManager stopGyroUpdates];
    
    NSLog(@"Motion Sensor Stopped");
}


///////////// Update Device Connection Status Image //////////
-(void)UpdateConnectionStatusLabel
{
    
    
    if (sensor.activePeripheral.state)
    {
        
        ConnectionStatusLabel.backgroundColor = [UIColor colorWithRed:128.0/255.0 green:255.0/255.0 blue:0.0/255.0 alpha:1.0];
    }
    else
    {
        
        ConnectionStatusLabel.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:128.0/255.0 blue:0.0/255.0 alpha:1.0];
    }
}




//recv data
-(void) TAHbleCharValueUpdated:(NSString *)UUID value:(NSData *)data
{
    NSString *value = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    
    NSLog(@"%@",value);
}



-(void)setConnect
{
    CFStringRef s = CFUUIDCreateString(kCFAllocatorDefault, (__bridge CFUUIDRef )sensor.activePeripheral.identifier);
    NSLog(@"%@",(__bridge NSString*)s);
    
}

-(void)setDisconnect
{
    [sensor disconnect:sensor.activePeripheral];
    
    NSLog(@"TAH Device Disconnected");
    
    
    //////// Local Alert Settings
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    /////////////////////////////////////////////
    
    // Set Connection Status Image
    [self UpdateConnectionStatusLabel];
}


-(void) updateall
{
    
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                             withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                                 [self MotionPad:accelerometerData.acceleration];
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


-(void)outputRotationData:(CMRotationRate)rotation
{
    
    //sensvalue.text = [NSString stringWithFormat:@"%.2f",sensslider.value];
   
    /*
    NSLog(@"X Rotation: %.2f", rotation.x);
    NSLog(@"Y Rotation: %.2f", rotation.y);
    NSLog(@"Z Rotation: %.2f", rotation.z);
   */
    
    
    if (rotation.x >=  sensslider.value) {
        
        
        
        NSLog(@"Right to Left");
        
        NSString *RtoL = @"65M";
        
        command = [NSString stringWithFormat:@"%@",RtoL];
        [self sendCommand];
    }
    
    
    
    
    
    
    else if (rotation.x <= -sensslider.value)
    {
        
        
        NSLog(@"Left to Right");
        
        NSString *LtoR = @"56M";
        
        command = [NSString stringWithFormat:@"%@",LtoR];
        
        [self sendCommand];
        
    }
    
    
    
    
    
    
    if (rotation.z >= sensslider.value) {
        
        
        
        NSLog(@"Up to Down");
        
        
        NSString *UtoD = @"34M";
        
        command = [NSString stringWithFormat:@"%@",UtoD];
        
        [self sendCommand];
        
    }
    
    
    
    else if (rotation.z <= -sensslider.value)
    {
        
        
        
        NSLog(@"Down to Up");
        
        NSString *DtoU = @"43M";
        
        command = [NSString stringWithFormat:@"%@",DtoU];
        
        [self sendCommand];
    }
    
    
}



- (void)MotionPad:(CMAcceleration)acceleration
{
    NSLog(@"X acceleration:%.2f",acceleration.x);
    //NSLog(@"Y acceleration:%.2f",acceleration.y);
    //NSLog(@"Z acceleration:%.2f",acceleration.z);
    
 if (volume.touchInside  && acceleration.x > 0.6)
    {
        
        NSString *volumeup = @"96M";
        
        command = [NSString stringWithFormat:@"%@",volumeup];
        
        [self sendCommand];
    }
    
    
    else if (volume.touchInside  && acceleration.x < -0.6)
    {
        
        NSString *volumedown = @"97M";
        
        command = [NSString stringWithFormat:@"%@",volumedown];
        
        [self sendCommand];
    }
    
    else if(volume.touchInside)
    {
        
        
        
        NSString *volumeuntouched = @"0M";
        
        command = [NSString stringWithFormat:@"%@",volumeuntouched];

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







- (IBAction)play:(id)sender {
    
   NSString *string = @"30M";
    
    NSData *data = [string dataUsingEncoding:[NSString defaultCStringEncoding]];
    
    [sensor write:sensor.activePeripheral data:data];
}

- (IBAction)next:(id)sender {
   
    NSString *string = @"10M";
    
    NSData *data = [string dataUsingEncoding:[NSString defaultCStringEncoding]];
    
    [sensor write:sensor.activePeripheral data:data];
}

- (IBAction)previous:(id)sender {
    
    NSString *string = @"20M";
    
    NSData *data = [string dataUsingEncoding:[NSString defaultCStringEncoding]];
    
    [sensor write:sensor.activePeripheral data:data];
}

- (IBAction)volup:(id)sender {
    
    NSString *string = @"96M";
    
    NSData *data = [string dataUsingEncoding:[NSString defaultCStringEncoding]];
    
    [sensor write:sensor.activePeripheral data:data];
}

- (IBAction)voldown:(id)sender {
    
    NSString *string = @"97M";
    
    NSData *data = [string dataUsingEncoding:[NSString defaultCStringEncoding]];
    
    [sensor write:sensor.activePeripheral data:data];
}
@end
