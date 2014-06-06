//
//  SettingsViewController.h
//  TAH
//
//  Created by DHIRAJ JADHAO on 11/05/14.
//  Copyright (c) 2014 DHIRAJJADHAO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SerialGATT.h"
#define RSSI_THRESHOLD -60
#define WARNING_MESSAGE @"z"

@class SerialGATT;

@interface SettingsViewController : UIViewController<BTSmartSensorDelegate, UITableViewDelegate, UITableViewDataSource>
{
    

    
    IBOutlet UILabel *ConnectedDeviceName;
    IBOutlet UITextField *requiredName;
    IBOutlet UITextField *requiredPassword;
    IBOutlet UIButton *changeName;
    IBOutlet UILabel *devicestatus;
    IBOutlet UIButton *changePassword;
    IBOutlet UIButton *turnoffpin;

    
    
}


@property (strong, nonatomic) SerialGATT *sensor;
@property (nonatomic, retain) NSMutableArray *peripheralViewControllerArray;


-(void) scanTimer:(NSTimer *)timer;

@property (weak, nonatomic) IBOutlet UITableView *TAHTableView;



@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) NSMutableArray *rssi_container;

@property (weak, nonatomic) IBOutlet UILabel *HMSoftUUID;
@property (weak, nonatomic) IBOutlet UITextView *tvRecv;


- (IBAction)changeName:(id)sender;
- (IBAction)changePassword:(id)sender;

- (IBAction)turnoffpin:(id)sender;



@end
