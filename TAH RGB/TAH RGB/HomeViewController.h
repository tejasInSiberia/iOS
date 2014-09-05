//
//  HomeViewController.h
//  TAH RGB
//
//  Created by Dhiraj on 17/07/14.
//  Copyright (c) 2014 dhirajjadhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAHble.h"



@class CBPeripheral;
@class TAHble;

@interface HomeViewController : UIViewController<BTSmartSensorDelegate>
{



    
    
    IBOutlet UIButton *redcol;
    IBOutlet UIButton *bluwber;
    IBOutlet UIButton *yellow;
    IBOutlet UIButton *greencol;
    IBOutlet UIButton *purple;
    IBOutlet UIButton *orange;
    IBOutlet UIButton *lime;
    IBOutlet UIButton *sky;
    
    IBOutlet UIButton *pink;
    IBOutlet UIButton *maroon;
    IBOutlet UIButton *darkblue;
    IBOutlet UIButton *bluebean;
    
    
    IBOutlet UIButton *rainbow;
    IBOutlet UIButton *off;
    IBOutlet UILabel *ConnectionStatusLabel;
    

}



@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) TAHble *sensor;


- (IBAction)redcol:(id)sender;
- (IBAction)blueber:(id)sender;
- (IBAction)yellow:(id)sender;
- (IBAction)greencol:(id)sender;
- (IBAction)purple:(id)sender;
- (IBAction)orange:(id)sender;
- (IBAction)lime:(id)sender;
- (IBAction)sky:(id)sender;

- (IBAction)off:(id)sender;
- (IBAction)rainbow:(id)sender;

- (IBAction)pink:(id)sender;
- (IBAction)maroon:(id)sender;
- (IBAction)darkblue:(id)sender;
- (IBAction)bluebean:(id)sender;



@end
