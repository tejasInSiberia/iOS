//
//  ComputerViewController.m
//  GBox
//
//  Created by DHIRAJ JADHAO on 12/02/14.
//  Copyright (c) 2014 DHIRAJJADHAO. All rights reserved.
//


#import <AudioToolbox/AudioToolbox.h>
#import "ComputerViewController.h"
#import "JSDPad.h"

@interface ComputerViewController ()
{
    

    int Buttonpadtag;
    int joyX;
    int joyY;
    int mode; // 0 = Play Station and 1 = Computer Joystick
    
    NSString *dpadValue;
    NSString *command;
    NSString *seperator;
    NSString *end;

    
}




- (NSString *)stringForDirection:(JSDPadDirection)direction;

@end




@implementation ComputerViewController

@synthesize sensor;
@synthesize peripheral;
@synthesize ComputerJoystickSettings;
@synthesize select;
@synthesize start;
@synthesize A;
@synthesize B;
@synthesize X;
@synthesize Y;

@synthesize buttonAset;
@synthesize buttonBset;
@synthesize buttonXset;
@synthesize buttonYset;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self updateall];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.


    sensor.delegate = self;
    ComputerJoystickSettings.hidden = YES;
    
    
    ////// Retrieving Button Values
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    buttonAset.text = [defaults objectForKey:@"SavedASet"];
    buttonBset.text = [defaults objectForKey:@"SavedBSet"];
    buttonXset.text = [defaults objectForKey:@"SavedXSet"];
    buttonYset.text = [defaults objectForKey:@"SavedYSet"];

    
    
    // Set Connection Status Image
    [self UpdateConnectionStatusLabel];

    
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}



-(void)viewWillAppear:(BOOL)animated
{
    // Set Connection Status Image
    [self UpdateConnectionStatusLabel];
}

-(void)viewWillDisappear:(BOOL)animated
{
    //////
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    
    NSString *SavedASet = buttonAset.text;
    [defaults setObject:SavedASet forKey:@"SavedASet"];
    
    NSString *SavedBSet = buttonBset.text;
    [defaults setObject:SavedBSet forKey:@"SavedBSet"];
    
    NSString *SavedXSet = buttonXset.text;
    [defaults setObject:SavedXSet forKey:@"SavedXSet"];
    
    NSString *SavedYSet = buttonYset.text;
    [defaults setObject:SavedYSet forKey:@"SavedYSet"];
    
    
    //////
}


///////////// Update Device Connection Status Image //////////
-(void)UpdateConnectionStatusLabel
{
    
    
    if (sensor.activePeripheral.state)
    {
        
        ConnectionStatusLabel.backgroundColor = [UIColor colorWithRed:128.0/255.0 green:255.0/255.0 blue:0.0/255.0 alpha:1.0];
    }
    else
    {
        
        ConnectionStatusLabel.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:128.0/255.0 blue:0.0/255.0 alpha:1.0];
    }
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
    
}


- (NSString *)stringForDirection:(JSDPadDirection)direction
{
	NSString *string = nil;
    
	
	switch (direction) {
		case JSDPadDirectionNone:
			string = @"+0,+0";
            
			break;
            
        case JSDPadDirectionUp:
			string = @"+0,+1";
			
            
			break;
            
        case JSDPadDirectionDown:
			string = @"+0,-1";
			
            
            break;
            
        case JSDPadDirectionLeft:
			string = @"-1,+0";
			
            
            break;
            
        case JSDPadDirectionRight:
			string = @"+1,+0";
			
            ;
            break;
            
        case JSDPadDirectionUpLeft:
			string = @"-1,+1";
            
            
            break;
            
        case JSDPadDirectionUpRight:
			string = @"+1,+1";
            
            
            break;
            
        case JSDPadDirectionDownLeft:
			string = @"-1,-1";
            
            
            break;
            
        case JSDPadDirectionDownRight:
			string = @"+1,-1";
            
            
            break;
            
        default:
			string = @"+0,+0";
            
            break;
	}
	
	return string;
    
}



- (void)updateall
{
	
    
    joyX = 0;
    joyY = 0;
    mode = 1;
    
    
    // Left Dpad Value
    dpadValue = [NSString stringWithFormat:@"%lu",[self.dPad currentDirection]];
    
    
    ////////////////////////////////////////////

    
    seperator = @",";
    end = @"P";

    
    command = [NSString stringWithFormat:@"%d%@%d%@%d%@%@%@%d%@",mode,seperator,joyX,seperator,joyY,seperator,dpadValue,seperator,Buttonpadtag,end];
    
    
    //////// data string to be sent ///////////
    
    NSLog(@"%@",command);
    
    
    NSData *data = [command dataUsingEncoding:[NSString defaultCStringEncoding]];
    
    
    [sensor write:sensor.activePeripheral data:data];
    
    /////////////////////////////////////////////////////////////
    
  
    
}



#pragma mark - JSDPadDelegate

/*- (void)dPad:(JSDPad *)dPad didPressDirection:(JSDPadDirection)direction
 {
 NSLog(@"Changing direction to: %@", [self stringForDirection:direction]);
 [self updateDirectionLabel];
 }
 
 - (void)dPadDidReleaseDirection:(JSDPad *)dPad
 {
 NSLog(@"Releasing DPad");
 [self updateDirectionLabel];
 }
 */



- (void)dPad:(JSDPad *)dPad didPressDirection:(JSDPadDirection)direction
{
	NSLog(@"Changing direction to: %@", [self stringForDirection:direction]);
	[self updateall];
}

- (void)dPadDidReleaseDirection:(JSDPad *)dPad
{
	NSLog(@"Releasing DPad");
	[self updateall];
}




#pragma mark - ComputerJSButtonDelegate


#pragma mark - ComputerJSAnalogueStickDelegate

/*- (void)analogueStickDidChangeValue:(JSAnalogueStick *)analogueStick
 {
 [self updateAnalogueLabel];
 }
 */





- (IBAction)selectPressed:(id)sender
{
    Buttonpadtag = 5;
    [self updateall];
}

- (IBAction)selectReleased:(id)sender
{
    Buttonpadtag = 0;
    [self updateall];
}


- (IBAction)startPressed:(id)sender
{
    Buttonpadtag = 6;
    [self updateall];
}
- (IBAction)startReleased:(id)sender
{
    Buttonpadtag = 0;
    [self updateall];
}



- (IBAction)ComputerguidebutPressed:(id)sender
{
    Buttonpadtag = 1;
    [self updateall];
}
- (IBAction)ComputerguidebutReleased:(id)sender
{
    Buttonpadtag = 0;
    [self updateall];
}


- (IBAction)APressed:(id)sender
{
    if (buttonAset.text.length >= 1)
    {
        Buttonpadtag = [buttonAset.text characterAtIndex:0];
        [self updateall];
    }
    else
    {
        [self setButtonValueAlert];
    }

}
- (IBAction)AReleased:(id)sender
{
    Buttonpadtag = 0;
    [self updateall];
}

- (IBAction)BPressed:(id)sender
{
    if (buttonBset.text.length >= 1)
    {
        Buttonpadtag = [buttonBset.text characterAtIndex:0];
        [self updateall];
    }
    else
    {
        [self setButtonValueAlert];
    }
}
- (IBAction)BReleased:(id)sender
{
    Buttonpadtag = 0;
    [self updateall];
}

- (IBAction)XPressed:(id)sender
{
    if (buttonXset.text.length >= 1)
    {
        Buttonpadtag = [buttonXset.text characterAtIndex:0];
        [self updateall];
    }
    else
    {
        [self setButtonValueAlert];
    }
}
- (IBAction)XReleased:(id)sender
{
    Buttonpadtag = 0;
    [self updateall];
}

- (IBAction)YPressed:(id)sender
{
    if (buttonYset.text.length >= 1)
    {
        Buttonpadtag = [buttonYset.text characterAtIndex:0];
        [self updateall];
    }
    else
    {
        [self setButtonValueAlert];
    }
}
- (IBAction)YReleased:(id)sender
{
    Buttonpadtag = 0;
    [self updateall];
}


//recv data
-(void) TAHbleCharValueUpdated:(NSString *)UUID value:(NSData *)data
{
    NSString *value = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    
    NSLog(@"%@",value);
}




-(void)setConnect
{
    CFStringRef s = CFUUIDCreateString(kCFAllocatorDefault, (__bridge CFUUIDRef )sensor.activePeripheral.identifier);
    NSLog(@"%@",(__bridge NSString*)s);
    
}

-(void)setDisconnect
{
    
    [sensor disconnect:sensor.activePeripheral];
    
    NSLog(@"TAH Device Disconnected");
    
    
    //////// Local Alert Settings
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    /////////////////////////////////////////////
    
    // Set Connection Status Image
    [self UpdateConnectionStatusLabel];
    
    
}




- (IBAction)Settings:(id)sender {
    
 ComputerJoystickSettings.hidden = NO;
    
}

- (IBAction)dismiss:(id)sender {
    
 
    ComputerJoystickSettings.hidden = YES;
    
    //////
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    
    NSString *SavedASet = buttonAset.text;
    [defaults setObject:SavedASet forKey:@"SavedASet"];
    
    NSString *SavedBSet = buttonBset.text;
    [defaults setObject:SavedBSet forKey:@"SavedBSet"];
    
    NSString *SavedXSet = buttonXset.text;
    [defaults setObject:SavedXSet forKey:@"SavedXSet"];
    
    NSString *SavedYSet = buttonYset.text;
    [defaults setObject:SavedYSet forKey:@"SavedYSet"];

    
     //////

}


-(void)setButtonValueAlert
{
    //////// Local Alert Settings
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Set Button Value"
                                                    message:@"Assign button value before using"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];

    /////////////////////////////////////////////
}

@end
