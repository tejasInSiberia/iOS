//
//  GBoxFinderViewController.h
//  GBox
//
//  Created by DHIRAJ JADHAO on 15/02/14.
//  Copyright (c) 2014 DHIRAJJADHAO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SerialGATT.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#define RSSI_THRESHOLD -60
#define WARNING_MESSAGE @"z"

@class CBPeripheral;
@class SerialGATT;


@interface GBoxFinderViewController : UIViewController<BTSmartSensorDelegate, UITableViewDelegate, UITableViewDataSource>


{
    IBOutlet UIButton *Back;
    

    IBOutlet UIButton *batterylevel;
    IBOutlet UITextField *batterylabel;
    IBOutlet UITextField *devicestatus;
    IBOutlet UISwitch *antilost;

    
    IBOutlet UISegmentedControl *mapmode;
    IBOutlet UIView *mapmodeview;
    
    IBOutlet UISwitch *Buzzer;
    IBOutlet UIButton *map;
    
    NSTimer *aTimer, *gpsTimer, *reconnectTimer,*BuzzOnTimer, *BuzzOffTimer, *iPhoneLostModeTimer;
    
    CLLocationManager *locationManager;
    
    UILocalNotification *notification, *Disconnectionnotification, *Connectionnotification;
    IBOutlet MKMapView *mapView;
    
    IBOutlet UITextField *latitudetextvalue;
    IBOutlet UITextField *longitudetextvalue;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;


@property (nonatomic, retain) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UITableView *btHMSoftTableView;
@property (weak, nonatomic) IBOutlet UIButton *Scan;
@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) NSMutableArray *rssi_container; // used for contain the indexers of the lower rssi value
@property (weak, nonatomic) IBOutlet UILabel *HMSoftUUID;

@property (strong, nonatomic) IBOutlet UITextView *tvRecv;

@property (strong, nonatomic) IBOutlet UITextField *GBoxName;

- (IBAction)antilost:(id)sender;

- (IBAction)Back:(id)sender;
- (IBAction)scanHMSoftDevices:(id)sender;


- (IBAction)batterylevel:(id)sender;
- (IBAction)mapmode:(id)sender;

- (IBAction)map:(id)sender;

@property (strong, nonatomic) SerialGATT *sensor;
@property (nonatomic, retain) NSMutableArray *peripheralViewControllerArray;

-(void) scanTimer:(NSTimer *)timer;
- (IBAction)Buzzer:(id)sender;






@end

