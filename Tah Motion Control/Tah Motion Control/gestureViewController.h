//
//  ViewController.h
//  Tah Motion Control
//
//  Created by DHIRAJ JADHAO on 21/04/14.
//  Copyright (c) 2014 DHIRAJJADHAO. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "SerialGATT.h"

@interface gestureViewController : UIViewController<BTSmartSensorDelegate, UITableViewDelegate, UITableViewDataSource>
{
    
    IBOutlet UIButton *done;
    
    IBOutlet UIView *scanner;
    IBOutlet UISwipeGestureRecognizer *left;
  
    IBOutlet UISwipeGestureRecognizer *right;
    IBOutlet UISwipeGestureRecognizer *up;
    IBOutlet UISwipeGestureRecognizer *down;
    
}

@property (strong, nonatomic) CMMotionManager *motionManager;

@property (weak, nonatomic) IBOutlet UITableView *btHMSoftTableView;
@property (weak, nonatomic) IBOutlet UIButton *Scan;
@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) NSMutableArray *rssi_container; // used for contain the indexers of the lower rssi value
@property (weak, nonatomic) IBOutlet UILabel *HMSoftUUID;

@property (strong, nonatomic) IBOutlet UITextView *tvRecv;



- (IBAction)scanHMSoftDevices:(id)sender;


@property (strong, nonatomic) SerialGATT *sensor;
@property (nonatomic, retain) NSMutableArray *peripheralViewControllerArray;

-(void) scanTimer:(NSTimer *)timer;


- (IBAction)done:(id)sender;

- (IBAction)left:(id)sender;
- (IBAction)right:(id)sender;
- (IBAction)up:(id)sender;
- (IBAction)down:(id)sender;


@end
