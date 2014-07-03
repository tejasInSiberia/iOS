//
//  TemperatureViewController.h
//  SidebarDemo
//
//  Created by Dhiraj on 22/06/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TemperatureViewController : UIViewController
{
   
    NSTimer *timer;  // timer for updating Real time
    
    IBOutlet UIImageView *tempbg;
    IBOutlet UIImageView *daynightstate;
    IBOutlet UILabel *temperaturelabel;
    IBOutlet UILabel *humiditylabel;
    IBOutlet UILabel *temperatureunitlabel;
    IBOutlet UILabel *humidityunitlabel;
    
}
-(void)updateTimer;
@end
