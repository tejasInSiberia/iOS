//
//  HomeViewController.m
//  TAH RGB
//
//  Created by Dhiraj on 17/07/14.
//  Copyright (c) 2014 dhirajjadhao. All rights reserved.
//

#import "HomeViewController.h"
#import "TAHble.h"
#import <AudioToolbox/AudioToolbox.h>

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize sensor;
@synthesize peripheral;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Settings Up Sensor Delegate
    self.sensor.delegate = self;
    
    // Set Connection Status Image
    [self UpdateConnectionStatusLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    // Set Connection Status Image
    [self UpdateConnectionStatusLabel];
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



- (IBAction)redcol:(id)sender
{
      NSString *command;
      command = @"255,0,0,1R";
      NSData *feed = [command dataUsingEncoding:[NSString defaultCStringEncoding]];
     [sensor write:sensor.activePeripheral data:feed];
    
}

- (IBAction)blueber:(id)sender
{
    NSString *command;
    command = @"0,0,255,1R";
    NSData *feed = [command dataUsingEncoding:[NSString defaultCStringEncoding]];
    [sensor write:sensor.activePeripheral data:feed];
}


- (IBAction)yellow:(id)sender
{
    NSString *command;
    command = @"255,255,0,1R";
    NSData *feed = [command dataUsingEncoding:[NSString defaultCStringEncoding]];
    [sensor write:sensor.activePeripheral data:feed];
}


- (IBAction)greencol:(id)sender
{
    NSString *command;
    command = @"0,255,0,1R";
    NSData *feed = [command dataUsingEncoding:[NSString defaultCStringEncoding]];
    [sensor write:sensor.activePeripheral data:feed];
}


- (IBAction)purple:(id)sender
{
    NSString *command;
    command = @"64,0,128,1R";
    NSData *feed = [command dataUsingEncoding:[NSString defaultCStringEncoding]];
    [sensor write:sensor.activePeripheral data:feed];
}


- (IBAction)orange:(id)sender
{
    NSString *command;
    command = @"255,154,0,1R";
    NSData *feed = [command dataUsingEncoding:[NSString defaultCStringEncoding]];
    [sensor write:sensor.activePeripheral data:feed];
}


- (IBAction)lime:(id)sender
{
    NSString *command;
    command = @"128,255,0,1R";
    NSData *feed = [command dataUsingEncoding:[NSString defaultCStringEncoding]];
    [sensor write:sensor.activePeripheral data:feed];
}


- (IBAction)sky:(id)sender
{
    NSString *command;
    command = @"102,204,255,1R";
    NSData *feed = [command dataUsingEncoding:[NSString defaultCStringEncoding]];
    [sensor write:sensor.activePeripheral data:feed];
}

- (IBAction)off:(id)sender
{
    
    NSString *command;
    command = @"0,0,0,1R";
    NSData *feed = [command dataUsingEncoding:[NSString defaultCStringEncoding]];
    [sensor write:sensor.activePeripheral data:feed];
}

- (IBAction)rainbow:(id)sender {
    
    NSString *command;
    command = @"255,255,255,2R";
    NSData *feed = [command dataUsingEncoding:[NSString defaultCStringEncoding]];
    [sensor write:sensor.activePeripheral data:feed];
}


- (IBAction)pink:(id)sender
{
    NSString *command;
    command = @"255,0,125,1R";
    NSData *feed = [command dataUsingEncoding:[NSString defaultCStringEncoding]];
    [sensor write:sensor.activePeripheral data:feed];
}
- (IBAction)maroon:(id)sender
{
    NSString *command;
    command = @"131,0,62,1R";
    NSData *feed = [command dataUsingEncoding:[NSString defaultCStringEncoding]];
    [sensor write:sensor.activePeripheral data:feed];
}
- (IBAction)darkblue:(id)sender
{
    NSString *command;
    command = @"0,128,127,1R";
    NSData *feed = [command dataUsingEncoding:[NSString defaultCStringEncoding]];
    [sensor write:sensor.activePeripheral data:feed];
}
- (IBAction)bluebean:(id)sender
{
    NSString *command;
    command = @"255,255,255,1R";
    NSData *feed = [command dataUsingEncoding:[NSString defaultCStringEncoding]];
    [sensor write:sensor.activePeripheral data:feed];
}

@end
