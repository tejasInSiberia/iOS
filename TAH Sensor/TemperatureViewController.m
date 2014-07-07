//
//  TemperatureViewController.m
//  SidebarDemo
//
//  Created by Dhiraj on 22/06/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "TemperatureViewController.h"

@interface TemperatureViewController ()

@end

@implementation TemperatureViewController

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
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                             target:self
                                           selector:@selector(updateTimer)
                                           userInfo:nil 
                                            repeats:YES];
    
    self.sensor.delegate = self;


}


-(void)updateTimer
{
    
    NSString *hour,*state;
    
    NSDateFormatter *hourformatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *stateformatter = [[NSDateFormatter alloc] init];
    
    [hourformatter setDateFormat:@"hh"]; // Gets Hours from current time
     hour = [hourformatter stringFromDate:[NSDate date]];
    int time = [hour intValue];
    
    [stateformatter setDateFormat:@"a"];
    state = [stateformatter stringFromDate:[NSDate date]];
    
    
    
    if( time >= 5  &&  time <= 11  &&  [state isEqual:@"am"]) // set day image
    {

        [tempbg setImage:[UIImage imageNamed:@"day.png"]];
        [daynightstate setImage:[UIImage imageNamed:@"dayicon.png"]];
        
        temperaturelabel.textColor = [UIColor colorWithRed:114.0/255.0 green:189.0/255.0 blue:208.0/255.0 alpha:1.0];
        temperatureunitlabel.textColor = [UIColor colorWithRed:114.0/255.0 green:189.0/255.0 blue:208.0/255.0 alpha:1.0];
        humiditylabel.textColor = [UIColor colorWithRed:114.0/255.0 green:189.0/255.0 blue:208.0/255.0 alpha:1.0];
        humidityunitlabel.textColor = [UIColor colorWithRed:114.0/255.0 green:189.0/255.0 blue:208.0/255.0 alpha:1.0];
        
        
    }
    
    else if( time >= 1  &&  time <= 6   &&   [state isEqual:@"pm"]) // set day image
    {
        
        [tempbg setImage:[UIImage imageNamed:@"day.png"]];
        [daynightstate setImage:[UIImage imageNamed:@"dayicon.png"]];
        
        temperaturelabel.textColor = [UIColor colorWithRed:114.0/255.0 green:189.0/255.0 blue:208.0/255.0 alpha:1.0];
        temperatureunitlabel.textColor = [UIColor colorWithRed:114.0/255.0 green:189.0/255.0 blue:208.0/255.0 alpha:1.0];
        humiditylabel.textColor = [UIColor colorWithRed:114.0/255.0 green:189.0/255.0 blue:208.0/255.0 alpha:1.0];
        humidityunitlabel.textColor = [UIColor colorWithRed:114.0/255.0 green:189.0/255.0 blue:208.0/255.0 alpha:1.0];
        
      
        
    }
    
    else if (( time = 12   &&   [state isEqual:@"pm"]))
    {
        [tempbg setImage:[UIImage imageNamed:@"day.png"]];
        [daynightstate setImage:[UIImage imageNamed:@"dayicon.png"]];
        
        temperaturelabel.textColor = [UIColor colorWithRed:114.0/255.0 green:189.0/255.0 blue:208.0/255.0 alpha:1.0];
        temperatureunitlabel.textColor = [UIColor colorWithRed:114.0/255.0 green:189.0/255.0 blue:208.0/255.0 alpha:1.0];
        humiditylabel.textColor = [UIColor colorWithRed:114.0/255.0 green:189.0/255.0 blue:208.0/255.0 alpha:1.0];
        humidityunitlabel.textColor = [UIColor colorWithRed:114.0/255.0 green:189.0/255.0 blue:208.0/255.0 alpha:1.0];
        
        
    }

    
    else if(time >= 7  &&  time <= 11   &&   [state isEqual:@"pm"]) // set night image
    {
        [tempbg setImage:[UIImage imageNamed:@"night.png"]];
        [daynightstate setImage:[UIImage imageNamed:@"nighticon.png"]];
        
        temperaturelabel.textColor = [UIColor colorWithRed:127.0/255.0 green:130.0/255.0 blue:128.0/255.0 alpha:1.0];
        temperatureunitlabel.textColor = [UIColor colorWithRed:127.0/255.0 green:130.0/255.0 blue:128.0/255.0 alpha:1.0];
        humiditylabel.textColor = [UIColor colorWithRed:127.0/255.0 green:130.0/255.0 blue:128.0/255.0 alpha:1.0];
        humidityunitlabel.textColor = [UIColor colorWithRed:127.0/255.0 green:130.0/255.0 blue:128.0/255.0 alpha:1.0];
        
        
        
    }
    
    else if(time >= 1  &&  time <= 4   &&   [state isEqual:@"am"]) // set night image
    {
        [tempbg setImage:[UIImage imageNamed:@"night.png"]];
        [daynightstate setImage:[UIImage imageNamed:@"nighticon.png"]];
        
        temperaturelabel.textColor = [UIColor colorWithRed:127.0/255.0 green:130.0/255.0 blue:128.0/255.0 alpha:1.0];
        temperatureunitlabel.textColor = [UIColor colorWithRed:127.0/255.0 green:130.0/255.0 blue:128.0/255.0 alpha:1.0];
        humiditylabel.textColor = [UIColor colorWithRed:127.0/255.0 green:130.0/255.0 blue:128.0/255.0 alpha:1.0];
        humidityunitlabel.textColor = [UIColor colorWithRed:127.0/255.0 green:130.0/255.0 blue:128.0/255.0 alpha:1.0];
       
       
        
    }
    
    
    else if((time = 12   &&   [state isEqual:@"am"])) // set night image
    {
        [tempbg setImage:[UIImage imageNamed:@"night.png"]];
        [daynightstate setImage:[UIImage imageNamed:@"nighticon.png"]];
        
        temperaturelabel.textColor = [UIColor colorWithRed:127.0/255.0 green:130.0/255.0 blue:128.0/255.0 alpha:1.0];
        temperatureunitlabel.textColor = [UIColor colorWithRed:127.0/255.0 green:130.0/255.0 blue:128.0/255.0 alpha:1.0];
        humiditylabel.textColor = [UIColor colorWithRed:127.0/255.0 green:130.0/255.0 blue:128.0/255.0 alpha:1.0];
        humidityunitlabel.textColor = [UIColor colorWithRed:127.0/255.0 green:130.0/255.0 blue:128.0/255.0 alpha:1.0];
        
        
        
    }

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


-(void) TAHbleCharValueUpdated:(NSString *)UUID value:(NSData *)data
{
    
    NSString *value = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    
    
    NSLog(@"%@",value);
    
}



- (IBAction)command:(id)sender {
    
    [sensor updateTAHStatus:sensor.activePeripheral UpdateStatus:YES];
}




@end
