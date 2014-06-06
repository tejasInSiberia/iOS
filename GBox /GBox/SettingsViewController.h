//
//  SettingsViewController.h
//  GBox
//
//  Created by DHIRAJ JADHAO on 09/02/14.
//  Copyright (c) 2014 DHIRAJJADHAO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SerialGATT.h"


#define RSSI_THRESHOLD -60
#define WARNING_MESSAGE @"z"

@class CBPeripheral;
@class SerialGATT;


@interface SettingsViewController : UIViewController<BTSmartSensorDelegate, UITableViewDelegate, UITableViewDataSource>


{
    IBOutlet UIButton *Back;
 
    IBOutlet UIButton *Set;
    IBOutlet UITextField *devicestatus;
    IBOutlet UIButton *ChangePassword;
   
}


@property (weak, nonatomic) IBOutlet UITableView *btHMSoftTableView;
@property (weak, nonatomic) IBOutlet UIButton *Scan;
@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) NSMutableArray *rssi_container; // used for contain the indexers of the lower rssi value
@property (weak, nonatomic) IBOutlet UILabel *HMSoftUUID;

@property (strong, nonatomic) IBOutlet UITextView *tvRecv;

@property (strong, nonatomic) IBOutlet UITextField *GBoxName;
@property (strong, nonatomic) IBOutlet UITextField *ConnectedDevice;
@property (strong, nonatomic) IBOutlet UITextField *GBoxPassword;


- (IBAction)Back:(id)sender;
- (IBAction)scanHMSoftDevices:(id)sender;
- (IBAction)Set:(id)sender;
- (IBAction)ChangePassword:(id)sender;





@property (strong, nonatomic) SerialGATT *sensor;
@property (nonatomic, retain) NSMutableArray *peripheralViewControllerArray;

-(void) scanTimer:(NSTimer *)timer;

@end
