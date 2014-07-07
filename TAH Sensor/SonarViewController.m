//
//  SonarViewController.m
//  SidebarDemo
//
//  Created by Dhiraj on 22/06/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "SonarViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface SonarViewController ()
{
    int connectedsensorpin;
    NSArray *ReceivedData;
    NSString *durationString;
    
}
@end

@implementation SonarViewController

@synthesize peripheral;
@synthesize sensor;

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
    //self.navigationController.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
    

    
    // Sets TAH class delegate
    self.sensor.delegate = self;

    
    
    
}



-(void)viewDidDisappear:(BOOL)animated
{
    [appdelegate.SonarSensorUpdatetimer invalidate];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}


-(void)SonarSensorUpdate:(NSTimer *)timer
{
    connectedsensorpin = (sensorpinsegment.selectedSegmentIndex + 2.0); // Defines Sensor Connected Pin
    
    if(sensor.activePeripheral.state)
    {
        [sensor getTAHSonarSensorUpdate:sensor.activePeripheral SensorPin:connectedsensorpin];
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



// Called when TAH is connected
-(void)setConnect
{
    CFStringRef s = CFUUIDCreateString(kCFAllocatorDefault, (__bridge CFUUIDRef )sensor.activePeripheral.identifier);
    NSLog(@"%@",(__bridge NSString*)s);
    
}


// Called when TAH is Disconnected
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




// Receined Data

-(void) TAHbleCharValueUpdated:(NSString *)UUID value:(NSData *)data
{

    NSString *value = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];

    
    
    ReceivedData = [value componentsSeparatedByString: @":"];
    durationString = [ReceivedData objectAtIndex: 1];


    [self durationtodistanceunit];  // update distance
 
    
}


//////////// Received Data conversion to Actual Distance //////////////

-(void)durationtodistanceunit
{
    float rawdistance = [durationString floatValue];
    
    if (sensorunitscalesegment.selectedSegmentIndex == 0)
    {
        distancelabel.text = [NSString stringWithFormat:@"%.0f",rawdistance/29/2];
        distanceunitlabel.text = @"cms";
        
        NSLog(@"Distance in Cms: %.0f",rawdistance/29/2);

    }
    
    
    else if (sensorunitscalesegment.selectedSegmentIndex == 1)
    {
        distancelabel.text = [NSString stringWithFormat:@"%.1f",rawdistance/74/2];
        distanceunitlabel.text = @"inches";
        
        NSLog(@"Distance in Inches: %.1f",rawdistance/74/2);
    }
    
    
    else if (sensorunitscalesegment.selectedSegmentIndex == 2)
    {
        distancelabel.text = [NSString stringWithFormat:@"%.1f",rawdistance/883/2];
        distanceunitlabel.text = @"feets";
        
        NSLog(@"Distance in Feets: %.1f",rawdistance/883/2);
    }
    
    
    else if (sensorunitscalesegment.selectedSegmentIndex == 3)
    {
        distancelabel.text = [NSString stringWithFormat:@"%.1f",rawdistance/2900/2];
        distanceunitlabel.text = @"meters";
        
        NSLog(@"Distance in Meters: %.1f",rawdistance/2900/2);
    }
    


}


//////////////////////////////////////////////////////////////////////



- (IBAction)settings:(id)sender {
    
    if (settingsview.hidden == YES)
    {
        settingsview.hidden = NO;
    }
    
    else
    {
        settingsview.hidden = YES;
    }
}

- (IBAction)sensoractivate:(id)sender {
    
    
    if (appdelegate.SonarSensorUpdatetimer.isValid)
    {
        [appdelegate.SonarSensorUpdatetimer invalidate];
    }
    
    
    else
    {
    
    ///////// Sonar Sensor Update Timer //////////
    
    appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    appdelegate.SonarSensorUpdatetimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                                          target:self
                                                                        selector:@selector(SonarSensorUpdate:)
                                                                        userInfo:nil
                                                                         repeats:YES];
        
    }
    
    
}

@end
