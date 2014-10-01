//
//  ComputerViewController.m
//  GBox
//
//  Created by DHIRAJ JADHAO on 12/02/14.
//  Copyright (c) 2014 DHIRAJJADHAO. All rights reserved.
//

#import "ComputerViewController.h"
#import "ComputerJSDPad.h"


@interface ComputerViewController ()
{
    
    
    int Hometag;
    int Lefttag;
    int Righttag;
    int Buttonpadtag;
    
    
    
}




- (NSString *)stringForDirection:(ComputerJSDPadDirection)direction;

@end




@implementation ComputerViewController

@synthesize btHMSoftTableView;
@synthesize Scan;
@synthesize sensor;
@synthesize peripheralViewControllerArray;
@synthesize HMSoftUUID;
@synthesize tvRecv;
@synthesize rssi_container;

@synthesize ComputerJoystickSettings;
@synthesize GBoxConnect;
@synthesize select;
@synthesize start;
@synthesize Computerguidebut;
@synthesize LB;
@synthesize LT;
@synthesize RB;
@synthesize RT;
@synthesize A;
@synthesize B;
@synthesize X;
@synthesize Y;

@synthesize buttonAset;
@synthesize buttonBset;
@synthesize buttonXset;
@synthesize buttonYset;
@synthesize buttonLBset;
@synthesize buttonLTset;
@synthesize buttonRBset;
@synthesize buttonRTset;


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
    
    GBoxConnect.hidden = YES;
    ComputerJoystickSettings.hidden = YES;
    
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    sensor = [[SerialGATT alloc] init];
    [sensor setup];
    sensor.delegate = self;
    
    peripheralViewControllerArray = [[NSMutableArray alloc] init];
    
    
    ////// Retrieving Button Values
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    buttonAset.text = [defaults objectForKey:@"SavedASet"];
    buttonBset.text = [defaults objectForKey:@"SavedBSet"];
    buttonXset.text = [defaults objectForKey:@"SavedXSet"];
    buttonYset.text = [defaults objectForKey:@"SavedYSet"];
    
    buttonLBset.text = [defaults objectForKey:@"SavedLBSet"];
    buttonLTset.text = [defaults objectForKey:@"SavedLTSet"];
    buttonRBset.text = [defaults objectForKey:@"SavedRBSet"];
    buttonRTset.text = [defaults objectForKey:@"SavedRTSet"];
    
    
}



- (void)viewDidUnload
{
    [self setBtHMSoftTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSString *)stringForDirection:(ComputerJSDPadDirection)direction
{
	NSString *string = nil;
    
	
	switch (direction) {
		case ComputerJSDPadDirectionNone:
			string = @"+0,+0";
            
			break;
            
        case ComputerJSDPadDirectionUp:
			string = @"+0,+1";
			
            
			break;
            
        case ComputerJSDPadDirectionDown:
			string = @"+0,-1";
			
            
            break;
            
        case ComputerJSDPadDirectionLeft:
			string = @"-1,+0";
			
            
            break;
            
        case ComputerJSDPadDirectionRight:
			string = @"+1,+0";
			
            ;
            break;
            
        case ComputerJSDPadDirectionUpLeft:
			string = @"-1,+1";
            
            
            break;
            
        case ComputerJSDPadDirectionUpRight:
			string = @"+1,+1";
            
            
            break;
            
        case ComputerJSDPadDirectionDownLeft:
			string = @"-1,-1";
            
            
            break;
            
        case ComputerJSDPadDirectionDownRight:
			string = @"+1,-1";
            
            
            break;
            
        default:
			string = @"+0,+0";
            
            break;
	}
	
	return string;
    
}



/*
 
 - (void)updateDirectionLabel
 {
 [self.directionlabel setText:[NSString stringWithFormat:@"Direction: %@", [self stringForDirection:[self.dPad currentDirection]]]];
 }
 
 
 - (void)updateAnalogueLabel
 {
 [self.analogueLabel setText:[NSString stringWithFormat:@"Analogue: %.2f , %.2f", self.analogueStick.xValue, self.analogueStick.yValue]];
 }
 */





- (void)updateall
{
	
    
    
    /*
     [self.directionlabel setText:[NSString stringWithFormat:@"Direction: %@", [self stringForDirection:[self.dPad currentDirection]]]];
     
     
     [self.analogueLabel setText:[NSString stringWithFormat:@"Analogue: %.2f , %.2f", self.analogueStick.xValue, self.analogueStick.yValue]];
     */
    
    ////////////////////////////////////////////
    
    
    // Left Side of Sony PS Controller
    
    // Left Dpad Value
    NSString *dpadValue = [NSString stringWithFormat:@"%u",[self.dPad currentDirection]];
    
    // Left Joystick X axis Value
    NSString *LeftanaXvalue = [NSString stringWithFormat:@"%.2f", self.LeftanalogueStick.xValue];
    
    // Left Joystick Y axis Value
    NSString *LeftanaYvalue = [NSString stringWithFormat:@"%.2f", self.LeftanalogueStick.yValue];
    
    
    ////////////////////////////////////////////
    
    
    
    
    // Right Side of Sony PS Controller
    
    // Right Joystick X axis Value
    NSString *anaXvalue = [NSString stringWithFormat:@"%.2f", self.analogueStick.xValue];
    
    // Right Joystick Y axis Value
    NSString *anaYvalue = [NSString stringWithFormat:@"%.2f", self.analogueStick.yValue];
    ////////////////////////////////////////////
    
    
    NSString *command = @" ";
    NSString *comma=@",";
    NSString *end=@"C";
    
    //Right Joystick
    float anaX = [anaXvalue floatValue];
    float anaY = [anaYvalue floatValue];
    
    // Left joystick
    float LeftanaX = [LeftanaXvalue floatValue];
    float LeftanaY = [LeftanaYvalue floatValue];
    
    int  addX = (anaX* 9);
    int  addY = (anaY* 9);
    
    int LeftaddX = (LeftanaX* 9);
    int LeftaddY = (LeftanaY* 9);
    
    
    
    /* Command Format:
     Left dPad,
     LeftJoy X,
     LeftJoy Y,
     RightJoy X,
     RightJoy Y,
     Select,Start,
     LB Button,
     LT Button,
     RB Button,
     RT Button,
     A,
     B,
     X,
     Y,
     Computerguidebut Button.
     
     */
    
    
    // command = [NSString stringWithFormat:@"%@%@%d%@%d%@%d%@%d%@%d%@%d%@%d%@%d%@%d%@%d%@%d%@%d%@%d%@%d%@%d%@%@",dpadValue,comma,LeftaddX,comma,LeftaddY,comma,addX,comma,addY,comma,selecttag,comma,starttag,comma,Computerguidebuttag,comma,LBtag,comma,LTtag,comma,RBtag,comma,RTtag,comma,Atag,comma,Btag,comma,Xtag,comma,Ytag,comma,end];
    
    //command = [NSString stringWithFormat:@"%@%@%d%@%d%@%d%@%d%@%d%d%d%d%@",dpadValue,comma,LeftaddX,comma,LeftaddY,comma,addX,comma,addY,comma,Hometag,Lefttag,Righttag,Buttonpadtag,end];
    
    command = [NSString stringWithFormat:@"%@%@%d%@%d%@%d%@%d%@%d%@%d%@%d%d%@",dpadValue,comma,LeftaddX,comma,LeftaddY,comma,addX,comma,addY,comma,Buttonpadtag,comma,Lefttag,comma,Righttag,Hometag,end];
    
    
    //////// Bluetoth Data to be Sent will come below ///////////
    
    NSLog(@"%@",command);  // Shows Commans Value in Xcode O/P WIndow
    
    
    NSData *data = [command dataUsingEncoding:[NSString defaultCStringEncoding]];
    
    
    [sensor write:sensor.activePeripheral data:data];
    
    /////////////////////////////////////////////////////////////
    
    
    
}



#pragma mark - ComputerJSDPadDelegate

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



- (void)dPad:(ComputerJSDPad *)dPad didPressDirection:(ComputerJSDPadDirection)direction
{
	NSLog(@"Changing direction to: %@", [self stringForDirection:direction]);
	[self updateall];
}

- (void)dPadDidReleaseDirection:(ComputerJSDPad *)dPad
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


- (void)analogueStickDidChangeValue:(ComputerJSAnalogueStick *)analogueStick
{
	[self updateall];
}


- (IBAction)selectPressed:(id)sender
{
    Hometag = 7;
    [self updateall];
}

- (IBAction)selectReleased:(id)sender
{
    Hometag = 0;
    [self updateall];
}


- (IBAction)startPressed:(id)sender
{
    Hometag = 8;
    [self updateall];
}
- (IBAction)startReleased:(id)sender
{
    Hometag = 0;
    [self updateall];
}



- (IBAction)ComputerguidebutPressed:(id)sender
{
    Hometag = 1;
    [self updateall];
}
- (IBAction)ComputerguidebutReleased:(id)sender
{
    Hometag = 0;
    [self updateall];
}


- (IBAction)LBPressed:(id)sender
{
    Lefttag = [buttonLBset.text characterAtIndex:0];
    [self updateall];
}
- (IBAction)LBReleased:(id)sender
{
    Lefttag = 0;
    [self updateall];
}


- (IBAction)LTPressed:(id)sender
{
    Lefttag = [buttonLTset.text characterAtIndex:0];;
    [self updateall];
}
- (IBAction)LTReleased:(id)sender
{
    Lefttag = 0;
    [self updateall];
}


- (IBAction)RBPressed:(id)sender
{
    Righttag = [buttonRBset.text characterAtIndex:0];;
    [self updateall];
}
- (IBAction)RBReleased:(id)sender
{
    Righttag = 0;
    [self updateall];
}


- (IBAction)RTPressed:(id)sender
{
    Righttag = [buttonRTset.text characterAtIndex:0];;
    [self updateall];
}
- (IBAction)RTReleased:(id)sender
{
    Righttag = 0;
    [self updateall];
}

- (IBAction)APressed:(id)sender
{
    Buttonpadtag = [buttonAset.text characterAtIndex:0];
    [self updateall];
}
- (IBAction)AReleased:(id)sender
{
    Buttonpadtag = 0;
    [self updateall];
}

- (IBAction)BPressed:(id)sender
{
    Buttonpadtag = [buttonBset.text characterAtIndex:0];;
    [self updateall];
}
- (IBAction)BReleased:(id)sender
{
    Buttonpadtag = 0;
    [self updateall];
}

- (IBAction)XPressed:(id)sender
{
    Buttonpadtag = [buttonXset.text characterAtIndex:0];
    [self updateall];
}
- (IBAction)XReleased:(id)sender
{
    Buttonpadtag = 0;
    [self updateall];
}

- (IBAction)YPressed:(id)sender
{
    Buttonpadtag = [buttonYset.text characterAtIndex:0];;
    [self updateall];
}
- (IBAction)YReleased:(id)sender
{
    Buttonpadtag = 0;
    [self updateall];
}

- (IBAction)back:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
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
    
    NSString *SavedLBSet = buttonLBset.text;
    [defaults setObject:SavedLBSet forKey:@"SavedLBSet"];
    
    NSString *SavedRBSet = buttonRBset.text;
    [defaults setObject:SavedRBSet forKey:@"SavedRBSet"];
    
    NSString *SavedLTSet = buttonLTset.text;
    [defaults setObject:SavedLTSet forKey:@"SavedLTSet"];
    
    NSString *SavedRTSet = buttonRTset.text;
    [defaults setObject:SavedRTSet forKey:@"SavedRTSet"];
    
    
    
    
    //////
    
    
}

- (IBAction)ble:(id)sender
{
    if (GBoxConnect.hidden == YES)
    {
        GBoxConnect.hidden = NO;
        NSLog(@"Visible");
    }
    else
    {
        GBoxConnect.hidden = YES;
        NSLog(@"Hidden");
    }
    
}





-(void) scanTimer:(NSTimer *)timer
{
    [Scan setTitle:@"Scan" forState:UIControlStateNormal];
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.peripheralViewControllerArray count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    ComputerViewController *controller = [peripheralViewControllerArray objectAtIndex:row];
    
    if (sensor.activePeripheral && sensor.activePeripheral != controller.peripheral) {
        [sensor disconnect:sensor.activePeripheral];
    }
    
    sensor.activePeripheral = controller.peripheral;
    [sensor connect:sensor.activePeripheral];
    [sensor stopScan];
    
    [Scan setTitle:@"Scan" forState:UIControlStateNormal];
    
    GBoxConnect.hidden = YES;
    NSLog(@"Hidden");
    
    //[self.navigationController pushViewController:controller animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"peripheral";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    // Configure the cell
    NSUInteger row = [indexPath row];
    ComputerViewController *controller = [peripheralViewControllerArray objectAtIndex:row];
    CBPeripheral *peripheral = [controller peripheral];
    cell.textLabel.text = peripheral.name;
    //cell.detailTextLabel.text = [NSString stringWithFormat:<#(NSString *), ...#>
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
}


#pragma mark - HMSoftSensorDelegate
-(void)sensorReady
{
    //TODO: it seems useless right now.
}

-(void) peripheralFound:(CBPeripheral *)peripheral
{
    ComputerViewController *controller = [[ComputerViewController alloc] init];
    controller.peripheral = peripheral;
    controller.sensor = sensor;
    [peripheralViewControllerArray addObject:controller];
    [btHMSoftTableView reloadData];
}



//recv data
-(void) serialGATTCharValueUpdated:(NSString *)UUID value:(NSData *)data
{
    NSString *value = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    tvRecv.text= [tvRecv.text stringByAppendingString:value];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
    
}


-(void)setConnect
{
    CFStringRef s = CFUUIDCreateString(kCFAllocatorDefault, (__bridge CFUUIDRef )sensor.activePeripheral.identifier);
    HMSoftUUID.text = (__bridge NSString*)s;
    tvRecv.text = @"OK+CONN";
    
    
    UIImage * btnImage1 = [UIImage imageNamed:@"Xglow.png"];
    [Computerguidebut setImage:btnImage1 forState:UIControlStateNormal];
    
}

-(void)setDisconnect
{
    tvRecv.text= [tvRecv.text stringByAppendingString:@"OK+LOST"];
    UIImage * btnImage1 = [UIImage imageNamed:@"XGuide button.png"];
    [Computerguidebut setImage:btnImage1 forState:UIControlStateNormal];
}



- (IBAction)scanHMSoftDevices:(id)sender
{
    UIImage * btnImage1 = [UIImage imageNamed:@"XGuide button.png"];
    [Computerguidebut setImage:btnImage1 forState:UIControlStateNormal];
    
    
    if ([sensor activePeripheral]) {
        if (sensor.activePeripheral.state == CBPeripheralStateConnected)
        {
            [sensor.manager cancelPeripheralConnection:sensor.activePeripheral];
            sensor.activePeripheral = nil;
        }
    }
    
    if ([sensor peripherals]) {
        sensor.peripherals = nil;
        [peripheralViewControllerArray removeAllObjects];
        [btHMSoftTableView reloadData];
    }
    
    sensor.delegate = self;
    printf("now we are searching device...\n");
    [Scan setTitle:@"Scanning" forState:UIControlStateNormal];
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scanTimer:) userInfo:nil repeats:NO];
    
    [sensor findHMSoftPeripherals:5];
}


- (IBAction)Settings:(id)sender {
    
    ComputerJoystickSettings.hidden = NO;
    
}

- (IBAction)Done:(id)sender {
    
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
    
    NSString *SavedLBSet = buttonLBset.text;
    [defaults setObject:SavedLBSet forKey:@"SavedLBSet"];
    
    NSString *SavedRBSet = buttonRBset.text;
    [defaults setObject:SavedRBSet forKey:@"SavedRBSet"];
    
    NSString *SavedLTSet = buttonLTset.text;
    [defaults setObject:SavedLTSet forKey:@"SavedLTSet"];
    
    NSString *SavedRTSet = buttonRTset.text;
    [defaults setObject:SavedRTSet forKey:@"SavedRTSet"];
    
    

    
    //////

}




@end
