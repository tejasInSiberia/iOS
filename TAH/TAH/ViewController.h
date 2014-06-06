//
//  ViewController.h
//  TAH
//
//  Created by DHIRAJ JADHAO on 11/05/14.
//  Copyright (c) 2014 DHIRAJJADHAO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SerialGATT.h"
#import "MACircleProgressIndicator.h"

#define RSSI_THRESHOLD -60
#define WARNING_MESSAGE @"z"

@class SerialGATT;

@interface ViewController : UIViewController<BTSmartSensorDelegate, UITableViewDelegate, UITableViewDataSource>
{

    NSTimer *TAHstatusupdatetimer;
    
    IBOutlet UIPageControl *pageControl;
    IBOutlet UIView *switchView;
    IBOutlet UIView *sliderView;
    IBOutlet UIButton *Disconnect;
    
    IBOutlet UIButton *hideScanner;
    
    IBOutlet UIView *scannerView;
    
    
    IBOutlet UISwitch *D2switch;
    IBOutlet UISwitch *D3switch;
    IBOutlet UISwitch *D4switch;
    IBOutlet UISwitch *D5switch;
    IBOutlet UISwitch *D6switch;
    IBOutlet UISwitch *D7switch;
    IBOutlet UISwitch *D8switch;
    IBOutlet UISwitch *D9switch;
    IBOutlet UISwitch *D10switch;
    IBOutlet UISwitch *D11switch;
    IBOutlet UISwitch *D12switch;
    IBOutlet UISwitch *D13switch;
    
    IBOutlet UISlider *D3Slider;
    IBOutlet UISlider *D5Slider;
    IBOutlet UISlider *D6Slider;
    IBOutlet UISlider *D9Slider;
    IBOutlet UISlider *D10Slider;
    IBOutlet UISlider *D11Slider;
    IBOutlet UISlider *D13Slider;
   
    IBOutlet UIImageView *blestatusled;
    IBOutlet UIImageView *tahpowerled;
    IBOutlet UIImageView *tahL13led;
    IBOutlet UIImageView *L13sliderled;
    
    
    IBOutlet UILabel *a0ProgressLabel;
    IBOutlet UILabel *a1ProgressLabel;
    IBOutlet UILabel *a2ProgressLabel;
    IBOutlet UILabel *a3ProgressLabel;
    IBOutlet UILabel *a4ProgressLabel;
    IBOutlet UILabel *a5ProgressLabel;
    
    IBOutlet UISwipeGestureRecognizer *swipeLeft;
    IBOutlet UISwipeGestureRecognizer *swipeRight;
    
    
    
}


@property (strong, nonatomic) SerialGATT *sensor;
@property (nonatomic, retain) NSMutableArray *peripheralViewControllerArray;


-(void) scanTimer:(NSTimer *)timer;

@property (weak, nonatomic) IBOutlet UITableView *TAHTableView;



@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) NSMutableArray *rssi_container;

@property (weak, nonatomic) IBOutlet UILabel *HMSoftUUID;
@property (weak, nonatomic) IBOutlet UITextView *tvRecv;


@property (strong, nonatomic) IBOutlet MACircleProgressIndicator *a0progress;
@property (strong, nonatomic) IBOutlet MACircleProgressIndicator *a1progress;
@property (strong, nonatomic) IBOutlet MACircleProgressIndicator *a2progress;
@property (strong, nonatomic) IBOutlet MACircleProgressIndicator *a3progress;
@property (strong, nonatomic) IBOutlet MACircleProgressIndicator *a4progress;
@property (strong, nonatomic) IBOutlet MACircleProgressIndicator *a5progress;





- (IBAction)Disconnect:(id)sender;


- (IBAction)D2switch:(id)sender;
- (IBAction)D3switch:(id)sender;
- (IBAction)D4switch:(id)sender;
- (IBAction)D5switch:(id)sender;
- (IBAction)D6switch:(id)sender;
- (IBAction)D7switch:(id)sender;
- (IBAction)D8switch:(id)sender;
- (IBAction)D9switch:(id)sender;
- (IBAction)D10switch:(id)sender;
- (IBAction)D11switch:(id)sender;
- (IBAction)D12switch:(id)sender;
- (IBAction)D13switch:(id)sender;

- (IBAction)D3Slider:(id)sender;
- (IBAction)D5Slider:(id)sender;
- (IBAction)D6Slider:(id)sender;
- (IBAction)D9Slider:(id)sender;
- (IBAction)D10Slider:(id)sender;
- (IBAction)D11Slider:(id)sender;
- (IBAction)D13Slider:(id)sender;

- (IBAction)hideScanner:(id)sender;

- (IBAction)swipeLeft:(id)sender;
- (IBAction)swipeRight:(id)sender;

- (IBAction)stopTAHUpdate:(id)sender;

@end
