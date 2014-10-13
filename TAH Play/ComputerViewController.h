//
//  ComputerViewController.h
//  GBox
//
//  Created by DHIRAJ JADHAO on 12/02/14.
//  Copyright (c) 2014 DHIRAJJADHAO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSDPad.h"
#import "JSAnalogueStick.h"
#import "TAHble.h"


@class CBPeripheral;
@class TAHble;

@interface ComputerViewController : UIViewController <JSDPadDelegate, JSAnalogueStickDelegate,BTSmartSensorDelegate>

{
    

    IBOutlet JSDPad *dPadView;
    IBOutlet UILabel *ConnectionStatusLabel;
    IBOutlet UIButton *Settings;
    
}




///////////////////////////



@property (weak, nonatomic) IBOutlet JSDPad *dPad;
@property (strong, nonatomic) IBOutlet UIView *ComputerJoystickSettings;



///////////////////
@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) TAHble *sensor;

//////////////////


@property (weak, nonatomic) IBOutlet UIButton *select;
@property (weak, nonatomic) IBOutlet UIButton *start;



@property (weak, nonatomic) IBOutlet UIButton *A;
@property (weak, nonatomic) IBOutlet UIButton *B;
@property (weak, nonatomic) IBOutlet UIButton *X;
@property (weak, nonatomic) IBOutlet UIButton *Y;

@property (strong, nonatomic) IBOutlet UITextField *buttonAset;
@property (strong, nonatomic) IBOutlet UITextField *buttonBset;
@property (strong, nonatomic) IBOutlet UITextField *buttonXset;
@property (strong, nonatomic) IBOutlet UITextField *buttonYset;





- (IBAction)selectPressed:(id)sender;
- (IBAction)selectReleased:(id)sender;

- (IBAction)startPressed:(id)sender;
- (IBAction)startReleased:(id)sender;

- (IBAction)APressed:(id)sender;
- (IBAction)AReleased:(id)sender;

- (IBAction)BPressed:(id)sender;
- (IBAction)BReleased:(id)sender;

- (IBAction)XPressed:(id)sender;
- (IBAction)XReleased:(id)sender;

- (IBAction)YPressed:(id)sender;
- (IBAction)YReleased:(id)sender;

- (IBAction)Settings:(id)sender;
- (IBAction)dismiss:(id)sender;



@end
