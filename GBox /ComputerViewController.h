//
//  ComputerViewController.h
//  GBox
//
//  Created by DHIRAJ JADHAO on 12/02/14.
//  Copyright (c) 2014 DHIRAJJADHAO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComputerJSDPad.h"
#import "ComputerJSAnalogueStick.h"
#import "SerialGATT.h"


#define RSSI_THRESHOLD -60
#define WARNING_MESSAGE @"z"

@class CBPeripheral;
@class SerialGATT;

@interface ComputerViewController : UIViewController <ComputerJSDPadDelegate, ComputerJSAnalogueStickDelegate,BTSmartSensorDelegate, UITableViewDelegate, UITableViewDataSource>

{
    
    IBOutlet UIButton *back;
    IBOutlet UIButton *ble;
    

    
    IBOutlet UIButton *Settings;
    IBOutlet UIBarButtonItem *Done;
    
}


@property (weak, nonatomic) IBOutlet ComputerJSDPad *dPad;
@property (weak, nonatomic) IBOutlet ComputerJSAnalogueStick *analogueStick;


@property (weak, nonatomic) IBOutlet ComputerJSAnalogueStick *LeftanalogueStick;

///////////////////
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
//////////////////


@property (weak, nonatomic) IBOutlet UIButton *select;
@property (weak, nonatomic) IBOutlet UIButton *start;
@property (weak, nonatomic) IBOutlet UIButton *Computerguidebut;
@property (weak, nonatomic) IBOutlet UIButton *LB;
@property (weak, nonatomic) IBOutlet UIButton *LT;
@property (weak, nonatomic) IBOutlet UIButton *RB;
@property (weak, nonatomic) IBOutlet UIButton *RT;
@property (weak, nonatomic) IBOutlet UIButton *Y;
@property (weak, nonatomic) IBOutlet UIButton *B;
@property (weak, nonatomic) IBOutlet UIButton *A;
@property (weak, nonatomic) IBOutlet UIButton *X;

@property (strong, nonatomic) IBOutlet UITextField *buttonAset;
@property (strong, nonatomic) IBOutlet UITextField *buttonBset;
@property (strong, nonatomic) IBOutlet UITextField *buttonXset;
@property (strong, nonatomic) IBOutlet UITextField *buttonYset;

@property (strong, nonatomic) IBOutlet UITextField *buttonLBset;
@property (strong, nonatomic) IBOutlet UITextField *buttonLTset;
@property (strong, nonatomic) IBOutlet UITextField *buttonRBset;
@property (strong, nonatomic) IBOutlet UITextField *buttonRTset;



@property (strong, nonatomic) IBOutlet UIView *GBoxConnect;
@property (strong, nonatomic) IBOutlet UIView *ComputerJoystickSettings;



- (IBAction)selectPressed:(id)sender;
- (IBAction)selectReleased:(id)sender;

- (IBAction)startPressed:(id)sender;
- (IBAction)startReleased:(id)sender;

- (IBAction)ComputerguidebutPressed:(id)sender;
- (IBAction)ComputerguidebutReleased:(id)sender;

- (IBAction)LBPressed:(id)sender;
- (IBAction)LBReleased:(id)sender;

- (IBAction)LTPressed:(id)sender;
- (IBAction)LTReleased:(id)sender;

- (IBAction)RBPressed:(id)sender;
- (IBAction)RBReleased:(id)sender;

- (IBAction)RTPressed:(id)sender;
- (IBAction)RTReleased:(id)sender;

- (IBAction)APressed:(id)sender;
- (IBAction)AReleased:(id)sender;

- (IBAction)BPressed:(id)sender;
- (IBAction)BReleased:(id)sender;

- (IBAction)XPressed:(id)sender;
- (IBAction)XReleased:(id)sender;

- (IBAction)YPressed:(id)sender;
- (IBAction)YReleased:(id)sender;


- (IBAction)back:(id)sender;
- (IBAction)ble:(id)sender;


- (IBAction)Settings:(id)sender;
- (IBAction)Done:(id)sender;



@end
