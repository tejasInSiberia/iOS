//
//  SonyViewController.h
//  GBox
//
//  Created by DHIRAJ JADHAO on 10/02/14.
//  Copyright (c) 2014 DHIRAJJADHAO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSDPad.h"
#import "JSAnalogueStick.h"
#import "SerialGATT.h"


#define RSSI_THRESHOLD -60
#define WARNING_MESSAGE @"z"

@class CBPeripheral;
@class SerialGATT;

@interface SonyViewController : UIViewController <JSDPadDelegate, JSAnalogueStickDelegate,BTSmartSensorDelegate, UITableViewDelegate, UITableViewDataSource>

{

    IBOutlet UIButton *back;
    IBOutlet UIButton *ble;
    
}

@property (strong, nonatomic) IBOutlet UIImageView *PSstatus;

@property (weak, nonatomic) IBOutlet JSDPad *dPad;
@property (weak, nonatomic) IBOutlet JSAnalogueStick *analogueStick;


@property (weak, nonatomic) IBOutlet JSAnalogueStick *LeftanalogueStick;

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
@property (weak, nonatomic) IBOutlet UIButton *PSHome;
@property (weak, nonatomic) IBOutlet UIButton *L1;
@property (weak, nonatomic) IBOutlet UIButton *L2;
@property (weak, nonatomic) IBOutlet UIButton *R1;
@property (weak, nonatomic) IBOutlet UIButton *R2;
@property (weak, nonatomic) IBOutlet UIButton *triangle;
@property (weak, nonatomic) IBOutlet UIButton *circle;
@property (weak, nonatomic) IBOutlet UIButton *cross;
@property (weak, nonatomic) IBOutlet UIButton *suqare;

@property (strong, nonatomic) IBOutlet UIView *GBoxConnect;



- (IBAction)selectPressed:(id)sender;
- (IBAction)selectReleased:(id)sender;

- (IBAction)startPressed:(id)sender;
- (IBAction)startReleased:(id)sender;

- (IBAction)PSHomePressed:(id)sender;
- (IBAction)PSHomeReleased:(id)sender;

- (IBAction)L1Pressed:(id)sender;
- (IBAction)L1Released:(id)sender;

- (IBAction)L2Pressed:(id)sender;
- (IBAction)L2Released:(id)sender;

- (IBAction)R1Pressed:(id)sender;
- (IBAction)R1Released:(id)sender;

- (IBAction)R2Pressed:(id)sender;
- (IBAction)R2Released:(id)sender;

- (IBAction)trianglePressed:(id)sender;
- (IBAction)triangleReleased:(id)sender;

- (IBAction)circlePressed:(id)sender;
- (IBAction)circleReleased:(id)sender;

- (IBAction)crossPressed:(id)sender;
- (IBAction)crossReleased:(id)sender;

- (IBAction)squarePressed:(id)sender;
- (IBAction)squareReleased:(id)sender;


- (IBAction)back:(id)sender;
- (IBAction)ble:(id)sender;




@end
