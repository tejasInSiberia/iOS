//
//  SonyViewController.m
//  GBox
//
//  Created by DHIRAJ JADHAO on 10/02/14.
//  Copyright (c) 2014 DHIRAJJADHAO. All rights reserved.
//

#import "SonyViewController.h"
#import "JSDPad.h"


@interface SonyViewController ()
{

    int selecttag;
    int starttag;
    int PSHometag;
    int L1tag;
    int L2tag;
    int R1tag;
    int R2tag;
    int triangletag;
    int circletag;
    int crosstag;
    int squaretag;
    
    

}




- (NSString *)stringForDirection:(JSDPadDirection)direction;

@end




@implementation SonyViewController

@synthesize btHMSoftTableView;
@synthesize Scan;
@synthesize sensor;
@synthesize peripheralViewControllerArray;
@synthesize HMSoftUUID;
@synthesize tvRecv;
@synthesize rssi_container;
@synthesize PSstatus;


@synthesize GBoxConnect;
@synthesize select;
@synthesize start;
@synthesize PSHome;
@synthesize L1;
@synthesize L2;
@synthesize R1;
@synthesize R2;
@synthesize triangle;
@synthesize circle;
@synthesize cross;
@synthesize suqare;


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
    
    GBoxConnect.hidden = YES;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    GBoxConnect.hidden = YES;
    selecttag = 0;
    
   if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    sensor = [[SerialGATT alloc] init];
    [sensor setup];
    sensor.delegate = self;
    
    peripheralViewControllerArray = [[NSMutableArray alloc] init];
    
}



- (void)viewDidUnload
{
    [self setBtHMSoftTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSString *end=@"S";
    
    //Right Joystick
    float anaX = [anaXvalue floatValue];
    float anaY = [anaYvalue floatValue];
    
    // Left joystick
    float LeftanaX = [LeftanaXvalue floatValue];
    float LeftanaY = [LeftanaYvalue floatValue];
    
    int  addX = (anaX* 255);
    int  addY = (anaY* 255);
    
    int LeftaddX = (LeftanaX* 255);
    int LeftaddY = (LeftanaY* 255);
    
    
   
    /* Command Format:
    Left dPad,
    LeftJoy X, 
    LeftJoy Y,
     RightJoy X,
     RightJoy Y,
     Select,Start,
     L1 Button, 
     L2 Button,
     R1 Button, 
     R2 Button,
     Triangle,
     Circle,
     Cross,
     Square, 
     PSHome Button.
     
    */
    
    
    command = [NSString stringWithFormat:@"%@%@%d%@%d%@%d%@%d%@%d%@%d%@%d%@%d%@%d%@%d%@%d%@%d%@%d%@%d%@%d%@%@",dpadValue,comma,LeftaddX,comma,LeftaddY,comma,addX,comma,addY,comma,selecttag,comma,starttag,comma,PSHometag,comma,L1tag,comma,L2tag,comma,R1tag,comma,R2tag,comma,triangletag,comma,circletag,comma,crosstag,comma,squaretag,comma,end];
    


    
    //////// Bluetoth Data to be Sent will come below ///////////
    
    NSLog(@"%@",command);  // Shows Commans Value in Xcode O/P WIndow
    
    
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




#pragma mark - JSButtonDelegate


#pragma mark - JSAnalogueStickDelegate

/*- (void)analogueStickDidChangeValue:(JSAnalogueStick *)analogueStick
 {
 [self updateAnalogueLabel];
 }
 */


- (void)analogueStickDidChangeValue:(JSAnalogueStick *)analogueStick
{
	[self updateall];
}


- (IBAction)selectPressed:(id)sender
{
    selecttag = 1;
    [self updateall];
}

- (IBAction)selectReleased:(id)sender
{
    selecttag = 0;
    [self updateall];
}


- (IBAction)startPressed:(id)sender
{
    starttag = 1;
    [self updateall];
}
- (IBAction)startReleased:(id)sender
{
    starttag = 0;
    [self updateall];
}



- (IBAction)PSHomePressed:(id)sender
{
    PSHometag = 1;
    [self updateall];
}
- (IBAction)PSHomeReleased:(id)sender
{
    PSHometag = 0;
    [self updateall];
}


- (IBAction)L1Pressed:(id)sender
{
    L1tag = 1;
    [self updateall];
}
- (IBAction)L1Released:(id)sender
{
    L1tag = 0;
    [self updateall];
}


- (IBAction)L2Pressed:(id)sender
{
    L2tag = 1;
    [self updateall];
}
- (IBAction)L2Released:(id)sender
{
    L2tag = 0;
    [self updateall];
}


- (IBAction)R1Pressed:(id)sender
{
    R1tag = 1;
    [self updateall];
}
- (IBAction)R1Released:(id)sender
{
    R1tag = 0;
    [self updateall];
}


- (IBAction)R2Pressed:(id)sender
{
    R2tag = 1;
    [self updateall];
}
- (IBAction)R2Released:(id)sender
{
    R2tag = 0;
    [self updateall];
}

- (IBAction)trianglePressed:(id)sender
{
    triangletag = 1;
    [self updateall];
}
- (IBAction)triangleReleased:(id)sender
{
    triangletag = 0;
    [self updateall];
}

- (IBAction)circlePressed:(id)sender
{
    circletag = 1;
    [self updateall];
}
- (IBAction)circleReleased:(id)sender
{
    circletag = 0;
    [self updateall];
}

- (IBAction)crossPressed:(id)sender
{
    crosstag = 1;
    [self updateall];
}
- (IBAction)crossReleased:(id)sender
{
    crosstag = 0;
    [self updateall];
}

- (IBAction)squarePressed:(id)sender
{
    squaretag = 1;
    [self updateall];
}
- (IBAction)squareReleased:(id)sender
{
    squaretag = 0;
    [self updateall];
}

- (IBAction)back:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
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
    SonyViewController *controller = [peripheralViewControllerArray objectAtIndex:row];
    
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
    SonyViewController *controller = [peripheralViewControllerArray objectAtIndex:row];
    CBPeripheral *peripheral = [controller peripheral];
    cell.textLabel.text = peripheral.name;
    //cell.detailTextLabel.text = [NSString stringWithFormat:<#(NSString *), ...#>
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
    
    GBoxConnect.hidden = YES;
    NSLog(@"Hidden");
}


#pragma mark - HMSoftSensorDelegate
-(void)sensorReady
{
    //TODO: it seems useless right now.
}

-(void) peripheralFound:(CBPeripheral *)peripheral
{
    SonyViewController *controller = [[SonyViewController alloc] init];
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
    

    UIImage * status = [UIImage imageNamed:@"PSblue.png"];
    PSstatus.image = status;
    
}

-(void)setDisconnect
{
    tvRecv.text= [tvRecv.text stringByAppendingString:@"OK+LOST"];
    
    UIImage * status = [UIImage imageNamed:@"PSblack.png"];
    PSstatus.image = status;
}



- (IBAction)scanHMSoftDevices:(id)sender
{
    
    UIImage * status = [UIImage imageNamed:@"PSblack.png"];
    PSstatus.image = status;
    
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



@end
