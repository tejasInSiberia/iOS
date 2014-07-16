//
//  HomeViewController.m
//  TAH Motion Control
//
//  Created by Dhiraj on 10/07/14.
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
    
    self.sensor.delegate = self;
    
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = .1;
    self.motionManager.gyroUpdateInterval = .1;

    
}


-(void)viewDidDisappear:(BOOL)animated
{
    [self.motionManager stopGyroUpdates];
    
    NSLog(@"Motion Sensor Stopped");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    //////// Local Alert Settings
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Disconnected"
                                                    message:@"Your iPhone got disconnected from TAH"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    
    NSLog(@"Disconnection Alert Sent");
    /////////////////////////////////////////////
    
}





- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"mouse"])
    {
        HomeViewController *vc = [segue destinationViewController];
        //vc.dataThatINeedFromTheFirstViewController = self.theDataINeedToPass;
        vc.sensor = self.sensor;

    }
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

- (IBAction)upswipe:(id)sender
{
    [sensor TAHKeyboardDownArrowKey:sensor.activePeripheral Pressed:YES];
    NSLog(@"DOWN");
    
    [self.motionManager stopGyroUpdates];
}


- (IBAction)downswipe:(id)sender
{
    [sensor TAHKeyboardUpArrowKey:sensor.activePeripheral Pressed:YES];
    NSLog(@"UP");
    
    [self.motionManager stopGyroUpdates];

}

- (IBAction)rightswipe:(id)sender
{
    [sensor TAHKeyboardLeftArrowKey:sensor.activePeripheral Pressed:YES];
    NSLog(@"LEFT");
    
    [self.motionManager stopGyroUpdates];
}

- (IBAction)leftswipe:(id)sender
{
    [sensor TAHKeyboardRightArrowKey:sensor.activePeripheral Pressed:YES];
    NSLog(@"RIGHT");
    
    [self.motionManager stopGyroUpdates];

}

- (IBAction)doubletap:(id)sender {
    
    [self performSegueWithIdentifier: @"mouse" sender: self];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
                                    withHandler:^(CMGyroData *gyroData, NSError *error) {
                                        [self outputRotationData:gyroData.rotationRate];
                                    }];
    
    NSLog(@"Motion Sensor Started");
}




-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

    [self.motionManager stopGyroUpdates];
    
    NSLog(@"Motion Sensor Stopped");
}



-(void)outputRotationData:(CMRotationRate)rotation
{
    
    
    
    //NSLog(@"X Rotation: %.2f", rotation.x);
    //NSLog(@"Y Rotation: %.2f", rotation.y);
    //NSLog(@"Z Rotation: %.2f", rotation.z);
    
    if (rotation.x >= 4.00)
    {
        [sensor TAHTrackPad:sensor.activePeripheral SwipeUp:YES];
        NSLog(@"Right to Left");
    }
    
    
    
    
    
    
    else if (rotation.x <= -4.00)
    {
        [sensor TAHTrackPad:sensor.activePeripheral SwipeDown:YES];
        NSLog(@"Left to Right");
    }

    
    
    
    else if (rotation.z >= 4.00)
    {
        [sensor TAHTrackPad:sensor.activePeripheral SwipeRight:YES];
        NSLog(@"Up to Down");
    }
    
    
    
    
    
    else if (rotation.z <= -4.00)
      
    {
        [sensor TAHTrackPad:sensor.activePeripheral SwipeLeft:YES];
        NSLog(@"Down to Up");
    }

    
    return;
}







@end
