//
//  HomeViewController.h
//  TAH Motion Control
//
//  Created by Dhiraj on 10/07/14.
//  Copyright (c) 2014 dhirajjadhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAHble.h"
#import <CoreMotion/CoreMotion.h>

@class CBPeripheral;
@class TAHble;

@interface HomeViewController : UIViewController<BTSmartSensorDelegate>
{
    
    IBOutlet UISwipeGestureRecognizer *upswipe;
    IBOutlet UISwipeGestureRecognizer *downswipe;
    IBOutlet UISwipeGestureRecognizer *rightswipe;
    IBOutlet UISwipeGestureRecognizer *leftswipe;
    IBOutlet UITapGestureRecognizer *doubletap;
}

@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) TAHble *sensor;

@property (strong, nonatomic) CMMotionManager *motionManager;


- (IBAction)upswipe:(id)sender;
- (IBAction)downswipe:(id)sender;
- (IBAction)rightswipe:(id)sender;
- (IBAction)leftswipe:(id)sender;

- (IBAction)doubletap:(id)sender;


@end
