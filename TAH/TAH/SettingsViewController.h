//
//  SettingsViewController.h
//  TAH
//
//  Created by DHIRAJ JADHAO on 11/05/14.
//  Copyright (c) 2014 DHIRAJJADHAO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAHble.h"


@class TAHble;

@interface SettingsViewController : UIViewController<BTSmartSensorDelegate, UITableViewDelegate, UITableViewDataSource>
{
    

    
    IBOutlet UILabel *ConnectedDeviceName;
    IBOutlet UITextField *requiredName;
    IBOutlet UITextField *requiredPassword;
    IBOutlet UILabel *devicestatus;
    IBOutlet UIButton *ApplySettings;
    IBOutlet UIButton *turnoffpin;
    IBOutlet UIButton *turnonpin;

    
    
}


@property (strong, nonatomic) TAHble *sensor;
@property (nonatomic, retain) NSMutableArray *peripheralViewControllerArray;


-(void) scanTimer:(NSTimer *)timer;

@property (weak, nonatomic) IBOutlet UITableView *TAHTableView;



@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) NSMutableArray *rssi_container;

@property (weak, nonatomic) IBOutlet UILabel *TAHUUID;
@property (weak, nonatomic) IBOutlet UITextView *tvRecv;



- (IBAction)turnoffpin:(id)sender;

- (IBAction)ApplySettings:(id)sender;
- (IBAction)turnonpin:(id)sender;


@end
