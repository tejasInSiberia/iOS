//
//  ViewController.m
//  TAH
//
//  Created by DHIRAJ JADHAO on 11/05/14.
//  Copyright (c) 2014 DHIRAJJADHAO. All rights reserved.
//

#import "ViewController.h"
#import "TAHble.h"
#import "RefreshControl.h"

@interface ViewController ()
{

    NSString *command, *end, *seperator, *anaPin, *anaValue;
    int PinType,PinNumber, PinValue;
    float indicatorvalueinfloat;
    int indicatorvalueininteger;
}
@end

@implementation ViewController

@synthesize TAHTableView;

@synthesize sensor;
@synthesize peripheralViewControllerArray;
@synthesize TAHUUID;
@synthesize tvRecv;
@synthesize rssi_container;
@synthesize peripheral;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    sensor = [[TAHble alloc] init];
    [sensor setup];
    sensor.delegate = self;
    peripheralViewControllerArray = [[NSMutableArray alloc] init];
    
   
   
    //controlView.hidden = YES;
    Disconnect.hidden = YES;
    scannerView.hidden = NO;
    [hideScanner setImage:[UIImage imageNamed:@"hide"] forState:UIControlStateNormal];
    
    end = @"R";
    seperator = @",";
    
    
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.TAHTableView];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    
    
    
    
    
    rabbitanimationtimer = [NSTimer scheduledTimerWithTimeInterval:4.0
                                                            target:self
                                                          selector:@selector(rabbitanimationstart:)
                                                          userInfo:nil
                                                           repeats:YES];
    rabbitearanimationtimer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                            target:self
                                                          selector:@selector(rabbitearanimationstart:)
                                                          userInfo:nil
                                                           repeats:YES];
    
    
    
    ////// Status Led Blink Animation //////
    
    [self ledanimationstart];

    ////// Setting Circle Progress Indicator ////////
    
    // You can use Appearance Proxy to style the MACircleProgressIndicator
    MACircleProgressIndicator *appearance = [MACircleProgressIndicator appearance];
    
    // The color property sets the actual color of the procress circle (how
    // suprising ;) )
    appearance.color = [UIColor colorWithRed:0.0 / 255.0 green:174.0 / 255.0 blue:239.0 / 255.0 alpha:1.0];
    

    ///////// TAH Status Update Timer //////////
    
    TAHstatusupdatetimer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                              target:self
                                            selector:@selector(UpdateTAHStatus:)
                                            userInfo:nil
                                             repeats:YES];
    
    
 
    
    
    
}


-(void)UpdateTAHStatus:(NSTimer *)theTimer
{
    if(sensor.activePeripheral.state)
    {
        [sensor updateTAHStatus:sensor.activePeripheral UpdateStatus:YES];
    }
   
}




-(void)viewDidDisappear:(BOOL)animated
{
    if (sensor.activePeripheral.state)
    {
     [self setDisconnect];  // Disconnect from TAH Board before transiting to different view.
    }
    
}



- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    
    double delayInSeconds = 5.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [refreshControl endRefreshing];
    });
    
    [self scanTAHDevices];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) scanTAHDevices
{

    if ([sensor activePeripheral]) {
        if (sensor.activePeripheral.state == CBPeripheralStateConnected) {
            [sensor.manager cancelPeripheralConnection:sensor.activePeripheral];
            sensor.activePeripheral = nil;
        }
    }
    
    if ([sensor peripherals]) {
        sensor.peripherals = nil;
        [peripheralViewControllerArray removeAllObjects];
        [TAHTableView reloadData];
    }
    
    sensor.delegate = self;
    printf("now we are searching device...\n");
    
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scanTimer:) userInfo:nil repeats:NO];
    
    [sensor findTAHPeripherals:5];

    
}

/*
 * scanTimer
 * when scanTAHDevices is timeout, this function will be called
 *
 */
-(void) scanTimer:(NSTimer *)timer
{
    
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.peripheralViewControllerArray count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    ViewController *controller = peripheralViewControllerArray[row];
    
    if (sensor.activePeripheral && sensor.activePeripheral != controller.peripheral) {
        [sensor disconnect:sensor.activePeripheral];
    }
    
    sensor.activePeripheral = controller.peripheral;
    [sensor connect:sensor.activePeripheral];
    [sensor stopScan];
    
   
    
    
    Disconnect.hidden = NO;
    scannerView.hidden = YES;
    [hideScanner setImage:[UIImage imageNamed:@"show"] forState:UIControlStateNormal];
    
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
    ViewController *controller = [peripheralViewControllerArray objectAtIndex:row];
    peripheral = [controller peripheral];
    cell.textLabel.text = peripheral.name;
    cell.textLabel.textColor = [UIColor colorWithRed:0.0 / 255.0 green:174.0 / 255.0 blue:239.0 / 255.0 alpha:1.0];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}


#pragma mark - TAHSensorDelegate
-(void)sensorReady
{
    //TODO: it seems useless right now.
}

-(void) peripheralFound:(CBPeripheral *)foundedperipheral
{
    ViewController *controller = [[ViewController alloc] init];
    controller.peripheral = foundedperipheral;
    controller.sensor = sensor;
    [peripheralViewControllerArray addObject:controller];
    [TAHTableView reloadData];
}



//recv data
-(void) TAHbleCharValueUpdated:(NSString *)UUID value:(NSData *)data
{
    NSString *value = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    tvRecv.text= [tvRecv.text stringByAppendingString:value];
    
    
    
    NSArray *incomedata = [value componentsSeparatedByString: @":"];
    anaPin = [incomedata firstObject];
    anaValue = [incomedata objectAtIndex:1];
    
    //NSLog(@"Received Data: %@",value);
    //NSLog(@"Received Data: %@", anaValue);
    
    [self updateAnalogIndicator];
    [self updateDigitalSwitch];
    
}





-(void) updateAnalogIndicator
{
    
    indicatorvalueinfloat = [anaValue floatValue];
    indicatorvalueininteger = [anaValue intValue];
    
    
    if ([anaPin  isEqual: @"A0"])
    {
        
        self.a0progress.value = indicatorvalueinfloat/1000;
        a0ProgressLabel.text = [NSString stringWithFormat:@"%d",indicatorvalueininteger];
       
    }
    
    else if ([anaPin  isEqual: @"A1"])
    {
        self.a1progress.value = indicatorvalueinfloat/1000;
        a1ProgressLabel.text = [NSString stringWithFormat:@"%d",indicatorvalueininteger];
    }
    
    else if ([anaPin  isEqual: @"A2"])
    {
        self.a2progress.value = indicatorvalueinfloat/1000;
        a2ProgressLabel.text = [NSString stringWithFormat:@"%d",indicatorvalueininteger];
    }
    
    else if ([anaPin  isEqual: @"A3"])
    {
        self.a3progress.value = indicatorvalueinfloat/1000;
        a3ProgressLabel.text = [NSString stringWithFormat:@"%d",indicatorvalueininteger];
    }
    
    else if ([anaPin  isEqual: @"A4"])
    {
        self.a4progress.value = indicatorvalueinfloat/1000;
        a4ProgressLabel.text = [NSString stringWithFormat:@"%d",indicatorvalueininteger];
    }
    
    else if ([anaPin  isEqual: @"A5"])
    {
        self.a5progress.value = indicatorvalueinfloat/1000;
        a5ProgressLabel.text = [NSString stringWithFormat:@"%d",indicatorvalueininteger];
    }


}


-(void)updateDigitalSwitch
{
    indicatorvalueininteger = [anaValue intValue];
    
    
    if ([anaPin  isEqual: @"D2"]  && indicatorvalueininteger == 1 && D2switch.on == NO)
    {
      
            D2switch.on = YES;
    }
    else if ([anaPin  isEqual: @"D2"]  && indicatorvalueininteger == 0 && D2switch.on == YES)
    {
      
            D2switch.on = NO;
    }
    
    
    
    if ([anaPin  isEqual: @"D3"]  && indicatorvalueininteger == 1 && D3switch.on == NO)
    {
        
            D3switch.on = YES;
        
    }
    else if ([anaPin  isEqual: @"D3"]  && indicatorvalueininteger == 0 && D3switch.on == YES)
    {
      
            D3switch.on = NO;
        
    }
    
    
    if ([anaPin  isEqual: @"D4"]  && indicatorvalueininteger == 1 && D4switch.on == NO)
    {
            D4switch.on = YES;
        
    }
    else if ([anaPin  isEqual: @"D4"]  && indicatorvalueininteger == 0 && D4switch.on == YES)
    {
            D4switch.on = NO;
        
    }
    
    
    if ([anaPin  isEqual: @"D5"]  && indicatorvalueininteger == 1 && D5switch.on == NO)
    {
        
            D5switch.on = YES;
        
    }
    else if ([anaPin  isEqual: @"D5"]  && indicatorvalueininteger == 0  && D5switch.on == YES)
    {
        
            D5switch.on = NO;
        
    }
    
    
    if ([anaPin  isEqual: @"D6"]  && indicatorvalueininteger == 1 && D6switch.on == NO)
    {
            D6switch.on = YES;
        
    }
    else if ([anaPin  isEqual: @"D6"]  && indicatorvalueininteger == 0  &&  D6switch.on == YES)
    {
        
            D6switch.on = NO;
        
    }
    
    
    if ([anaPin  isEqual: @"D7"]  && indicatorvalueininteger == 1  &&  D7switch.on == NO)
    {
        
            D7switch.on = YES;
        
    }
    else if ([anaPin  isEqual: @"D7"]  && indicatorvalueininteger == 0  &&  D7switch.on == YES)
    {
        
            D7switch.on = NO;
        
    }
    
    
    if ([anaPin  isEqual: @"D8"]  && indicatorvalueininteger == 1  &&  D8switch.on == NO)
    {
       
            D8switch.on = YES;
        
    }
    else if ([anaPin  isEqual: @"D8"]  && indicatorvalueininteger == 0  &&  D8switch.on == YES)
    {
            D8switch.on = NO;
        
    }
    
    
    if ([anaPin  isEqual: @"D9"]  && indicatorvalueininteger == 1  &&  D9switch.on == NO)
    {
       
            D9switch.on = YES;
        
    }
    else if ([anaPin  isEqual: @"D9"]  && indicatorvalueininteger == 0  &&  D9switch.on == YES)
    {
      
            D9switch.on = NO;
        
    }
    
    
    if ([anaPin  isEqual: @"D10"]  && indicatorvalueininteger == 1  &&  D10switch.on == NO)
    {
      
            D10switch.on = YES;
        
    }
    else if ([anaPin  isEqual: @"D10"]  && indicatorvalueininteger == 0  && D10switch.on == YES)
    {
        
            D10switch.on = NO;
        
    }
    
    
    if ([anaPin  isEqual: @"D11"]  && indicatorvalueininteger == 1  &&  D11switch.on == NO)
    {
            D11switch.on = YES;
        
    }
    else if ([anaPin  isEqual: @"D11"]  && indicatorvalueininteger == 0  &&  D11switch.on == YES)
    {
       
            D11switch.on = NO;
        
    }
    
    
    if ([anaPin  isEqual: @"D12"]  && indicatorvalueininteger == 1  &&  D12switch.on == NO)
    {
        
            D12switch.on = YES;
        
    }
    else if ([anaPin  isEqual: @"D12"]  && indicatorvalueininteger == 0  &&  D12switch.on == YES)
    {
      
        D12switch.on = NO;
        
    }
    
    
    if ([anaPin  isEqual: @"D13"]  && indicatorvalueininteger == 1  && D13switch.on == NO)
    {
        
            D13switch.on = YES;
            L13sliderled.image = [UIImage imageNamed:@"ledbdot"] ;
            L13sliderled.alpha = 1.0;
        
    }
    
    
    else if ([anaPin  isEqual: @"D13"]  && indicatorvalueininteger == 0 && D13switch.on == YES)
    {
        
            D13switch.on = NO;
            tahL13led.image = [UIImage imageNamed:@"ledoff"] ;
            L13sliderled.alpha = 0.0;
    }
       
        


}



//send data
-(void) sendCommand
{

    //////// Bluetoth Data to be Sent will come below ///////////
    
    NSLog(@"%@",command);  // Shows Commans Value in Xcode O/P WIndow
    
    
    NSData *data = [command dataUsingEncoding:[NSString defaultCStringEncoding]];
    
    
    [sensor write:sensor.activePeripheral data:data];
    

}


-(void)setConnect
{
    CFStringRef s = CFUUIDCreateString(kCFAllocatorDefault, (__bridge CFUUIDRef )sensor.activePeripheral.identifier);
    TAHUUID.text = (__bridge NSString*)s;
    tvRecv.text = @"OK+CONN";
    
    
    [self ledanimationstop];
    
}



-(void)setDisconnect
{
    tvRecv.text= [tvRecv.text stringByAppendingString:@"OK+LOST"];
    [sensor disconnect:sensor.activePeripheral];
    [blestatusled startAnimating];
}



-(void)ledanimationstart
{
    
    NSArray *images=[NSArray arrayWithObjects:[UIImage imageNamed:@"ledoff"],[UIImage imageNamed:@"ledb"],nil];
    
    blestatusled.animationImages  = images;
    blestatusled.animationDuration = 1;
    blestatusled.animationRepeatCount = -1;
    
    [blestatusled startAnimating];

}


-(void)rabbitanimationstart:(NSTimer *)theTimer
{
    
    NSArray *eyes=[NSArray arrayWithObjects:[UIImage imageNamed:@"tah close"],[UIImage imageNamed:@"tah"],nil];
    
    rabbit.animationImages  = eyes;
    rabbit.animationDuration = 0.2;
    rabbit.animationRepeatCount = 2;
    
    [rabbit startAnimating];

    
}


-(void)rabbitearanimationstart:(NSTimer *)theTimer
{

    NSArray *ear=[NSArray arrayWithObjects:[UIImage imageNamed:@"tah ear"],[UIImage imageNamed:@"tah"],nil];
    rabbit.animationImages  = ear;
    rabbit.animationDuration = 0.2;
    rabbit.animationRepeatCount = 2;
    
    [rabbit startAnimating];
    
}


-(void)ledanimationstop
{
    [blestatusled stopAnimating];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)Disconnect:(id)sender {
    
    if(sensor.activePeripheral.state)
    {
    
        [self setDisconnect];
    
    }
    //controlView.hidden = YES;
    Disconnect.hidden = YES;
    scannerView.hidden = NO;
    [hideScanner setImage:[UIImage imageNamed:@"hide"] forState:UIControlStateNormal];
}



- (IBAction)D2switch:(id)sender {
    
    if (D2switch.on)
    {
        [sensor TAHPin2digitalWrite:sensor.activePeripheral HIGH:YES];
    }
    
    else
    {
        [sensor TAHPin2digitalWrite:sensor.activePeripheral HIGH:NO];
    }
    
    
}


- (IBAction)D3switch:(id)sender {
    
    if (D3switch.on)
    {
         [sensor TAHPin3digitalWrite:sensor.activePeripheral HIGH:YES];
    }
    
    else
    {
        [sensor TAHPin3digitalWrite:sensor.activePeripheral HIGH:NO];
    }
    
    
}


- (IBAction)D4switch:(id)sender {
    
    if (D4switch.on)
    {
       [sensor TAHPin4digitalWrite:sensor.activePeripheral HIGH:YES];
    }
    
    else
    {
       [sensor TAHPin4digitalWrite:sensor.activePeripheral HIGH:NO];
        
    }
    
    
}



- (IBAction)D5switch:(id)sender {
    
    if (D5switch.on)
    {
       [sensor TAHPin5digitalWrite:sensor.activePeripheral HIGH:YES];
    }
    
    else
    {
       [sensor TAHPin5digitalWrite:sensor.activePeripheral HIGH:NO];
        
    }
    
    
}



- (IBAction)D6switch:(id)sender {
    
    if (D6switch.on)
    {
       [sensor TAHPin6digitalWrite:sensor.activePeripheral HIGH:YES];
    }
    
    else
    {
       [sensor TAHPin6digitalWrite:sensor.activePeripheral HIGH:NO];
        
    }
    
    
}



- (IBAction)D7switch:(id)sender {
    
    if (D7switch.on)
    {
       [sensor TAHPin7digitalWrite:sensor.activePeripheral HIGH:YES];
    }
    
    else
    {
       [sensor TAHPin7digitalWrite:sensor.activePeripheral HIGH:NO];
    }
    
    
}



- (IBAction)D8switch:(id)sender {
    
    if (D8switch.on)
    {
       [sensor TAHPin8digitalWrite:sensor.activePeripheral HIGH:YES];
    }
    
    else
    {
       [sensor TAHPin8digitalWrite:sensor.activePeripheral HIGH:NO];
        
    }
    
    
}



- (IBAction)D9switch:(id)sender {
    
    if (D9switch.on)
    {
       [sensor TAHPin9digitalWrite:sensor.activePeripheral HIGH:YES];
    }
    
    else
    {
       [sensor TAHPin9digitalWrite:sensor.activePeripheral HIGH:NO];
        
    }
    
    
}



- (IBAction)D10switch:(id)sender {
    
    if (D10switch.on)
    {
       [sensor TAHPin10digitalWrite:sensor.activePeripheral HIGH:YES];
    }
    
    else
    {
       [sensor TAHPin10digitalWrite:sensor.activePeripheral HIGH:NO];
        
    }
    
    
}



- (IBAction)D11switch:(id)sender {
    
    if (D11switch.on)
    {
       [sensor TAHPin11digitalWrite:sensor.activePeripheral HIGH:YES];
    }
    
    else
    {
       [sensor TAHPin11digitalWrite:sensor.activePeripheral HIGH:NO];
    }
    
    
}



- (IBAction)D12switch:(id)sender {
    
    if (D12switch.on)
    {
       [sensor TAHPin12digitalWrite:sensor.activePeripheral HIGH:YES];
    }
    
    else
    {
       [sensor TAHPin12digitalWrite:sensor.activePeripheral HIGH:NO];
    }
    
    
}



- (IBAction)D13switch:(id)sender {
    
    if (D13switch.on)
    {
       [sensor TAHPin13digitalWrite:sensor.activePeripheral HIGH:YES];
        
        D13Slider.value = 1.0;
        
        L13sliderled.image = [UIImage imageNamed:@"ledbdot"] ;
        L13sliderled.alpha = 1.0;
    }
    
    else
    {
        
       [sensor TAHPin13digitalWrite:sensor.activePeripheral HIGH:NO];
        
        D13Slider.value = 0.0;
        
        tahL13led.image = [UIImage imageNamed:@"ledoff"] ;
        L13sliderled.alpha = 0.0;
        
    }
    
    
}




- (IBAction)D3Slider:(id)sender
{
    
    NSString *Value = [NSString stringWithFormat:@"%f",D3Slider.value*255];
    int value = [Value intValue];

    [sensor TAHPin3analogWrite:sensor.activePeripheral Value:value];
}





- (IBAction)D5Slider:(id)sender
{
    
    NSString *Value = [NSString stringWithFormat:@"%f",D5Slider.value*255];
    int value = [Value intValue];
    
    [sensor TAHPin5analogWrite:sensor.activePeripheral Value:value];
}


- (IBAction)D6Slider:(id)sender
{
    
    NSString *Value = [NSString stringWithFormat:@"%f",D6Slider.value*255];
    int value = [Value intValue];
    
    
    [sensor TAHPin6analogWrite:sensor.activePeripheral Value:value];
    
    
}



- (IBAction)D9Slider:(id)sender
{
    
    NSString *Value = [NSString stringWithFormat:@"%f",D9Slider.value*255];
    int value = [Value intValue];

        [sensor TAHPin9analogWrite:sensor.activePeripheral Value:value];
    
    
}



- (IBAction)D10Slider:(id)sender
{
    
    NSString *Value = [NSString stringWithFormat:@"%f",D10Slider.value*255];
    int value = [Value intValue];
    
    [sensor TAHPin10analogWrite:sensor.activePeripheral Value:value];
    
    
}



- (IBAction)D11Slider:(id)sender
{
    
    NSString *Value = [NSString stringWithFormat:@"%f",D11Slider.value*255];
    int value = [Value intValue];
    
    [sensor TAHPin11analogWrite:sensor.activePeripheral Value:value];
    
}



- (IBAction)D13Slider:(id)sender
{
    
    NSString *Value = [NSString stringWithFormat:@"%f",D13Slider.value*255];
    int value = [Value intValue];
    
    [sensor TAHPin13analogWrite:sensor.activePeripheral Value:value];
    
    L13sliderled.alpha = D13Slider.value;
    
    
}





- (IBAction)hideScanner:(id)sender
{
    if(scannerView.hidden == NO)
    {
        scannerView.hidden = YES;
    [hideScanner setImage:[UIImage imageNamed:@"show"] forState:UIControlStateNormal];
    }
    
    else
    {
        scannerView.hidden = NO;
        [hideScanner setImage:[UIImage imageNamed:@"hide"] forState:UIControlStateNormal];
    }
        
    
}

- (IBAction)swipeLeft:(id)sender {
    
    switchView.hidden =YES;
    sliderView.hidden = NO;
    [pageControl setCurrentPage:1];
   
    
}

- (IBAction)swipeRight:(id)sender {
    
    
    
    switchView.hidden =NO;
    sliderView.hidden = YES;
    [pageControl setCurrentPage:0];


}

- (IBAction)stopTAHUpdate:(id)sender{
    
    if (D2switch || D3switch || D4switch || D5switch || D6switch || D7switch || D8switch || D9switch || D10switch || D11switch || D12switch || D13switch || D3Slider || D5Slider || D6Slider || D10Slider || D11Slider || D13Slider)
    {
        [TAHstatusupdatetimer invalidate];
    }
    
    
        TAHstatusupdatetimer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                                target:self
                                                              selector:@selector(UpdateTAHStatus:)
                                                              userInfo:nil
                                                               repeats:YES];
    
    
    
}

@end
