//
//  MouseViewController.h
//  TAH Motion Control
//
//  Created by Dhiraj on 10/07/14.
//  Copyright (c) 2014 dhirajjadhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAHble.h"


@class CBPeripheral;
@class TAHble;


@interface MouseViewController : UIViewController<BTSmartSensorDelegate>
{

    IBOutlet UITapGestureRecognizer *doubletap;
}

@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) TAHble *sensor;

- (IBAction)doubletap:(id)sender;

@end
