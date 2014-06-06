// 
// Copyright 2013-2014 Yummy Melon Software LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
//  Author: Charles Y. Choi <charles.choi@yummymelon.com>
//

#import "DEAPeripheralsViewController.h"
#import "DEASensorTag.h"
#import "DEASensorTagViewController.h"
#import "DEAPeripheralTableViewCell.h"
#import "DEAStyleSheet.h"
#import "DEATheme.h"
#import "SerialGATT.h"
#import "HomeViewController.h"

@interface DEAPeripheralsViewController ()

{

    NSString *value;

}



@end

@implementation DEAPeripheralsViewController

@synthesize editButton;
@synthesize scanButton;

@synthesize peripheralsTableView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"GBox Never Loose";
    
    /*
     First time DEACentralManager singleton is instantiated.
     All s/Users/dhirajjadhao/Desktop/YmsCoreBluetooth/Deanna/Controllers/DEAPeripheralsViewController.hubsequent references will use [DEACentralManager sharedService].
     */
    
    DEACentralManager *centralManager = [DEACentralManager initSharedServiceWithDelegate:self];
    

    [self.navigationController setToolbarHidden:NO];


[self.peripheralsTableView reloadData];
    
    [centralManager addObserver:self
                  forKeyPath:@"isScanning"
                     options:NSKeyValueObservingOptionNew
                     context:NULL];
    
    
        
    [DEATheme customizeTableView:self.peripheralsTableView forType:DEAPeripheralTableViewStyle];
   }

- (void)viewWillAppear:(BOOL)animated {
    DEACentralManager *centralManager = [DEACentralManager sharedService];
    centralManager.delegate = self;
    
    for (DEAPeripheralTableViewCell *cell in [self.peripheralsTableView visibleCells]) {
        cell.yperipheral.delegate = self;
    }
    [self.peripheralsTableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    DEACentralManager *centralManager = [DEACentralManager sharedService];
    
    if (object == centralManager) {
        if ([keyPath isEqualToString:@"isScanning"]) {
            if (centralManager.isScanning) {
                self.scanButton.title = @"Stop Scanning";
               
                
            } else {
                self.scanButton.title = @"Start Scanning";
                
            }
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)scanButton:(id)sender {
    
    
    
    DEACentralManager *centralManager = [DEACentralManager sharedService];
    
    if (centralManager.isScanning == NO) {
        [centralManager startScan];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
    else {
        [centralManager stopScan];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        for (DEAPeripheralTableViewCell *cell in [self.peripheralsTableView visibleCells]) {
            if (cell.yperipheral.cbPeripheral.state == CBPeripheralStateDisconnected) {
                cell.rssiLabel.text = @"—";
                cell.peripheralStatusLabel.text = @"Not In Range";
                [cell.peripheralStatusLabel setTextColor:[[DEATheme sharedTheme] bodyTextColor]];
            }
        }
        
    }
    
}

- (IBAction)editButtonAction:(id)sender {
    
    
    
    [self.peripheralsTableView setEditing:(!self.peripheralsTableView.editing) animated:YES];
    
    if (self.peripheralsTableView.editing)
    {
        [editButton setTitle:@"Done" forState:UIControlStateNormal];
    }
    
    else
    {
        [editButton setTitle:@"Edit" forState:UIControlStateNormal];
    }
  
    
}



#pragma mark - CBCentralManagerDelegate Methods


- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            break;
        case CBCentralManagerStatePoweredOff:
            break;
            
        case CBCentralManagerStateUnsupported: {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Dang."
                                                            message:@"Unfortunately this device can not talk to Bluetooth Smart (Low Energy) Devices"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
            
            [alert show];
            break;
        }
        case CBCentralManagerStateResetting: {
            [self.peripheralsTableView reloadData];
            
            break;
        }
        case CBCentralManagerStateUnauthorized:
            break;
            
        case CBCentralManagerStateUnknown:
            break;
            
        default:
            break;
    }
    
    
    
}


- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    DEACentralManager *centralManager = [DEACentralManager sharedService];
    YMSCBPeripheral *yp = [centralManager findPeripheral:peripheral];
    yp.delegate = self;
    
    [yp readRSSI];
    
    for (DEAPeripheralTableViewCell *cell in [self.peripheralsTableView visibleCells]) {
        if (cell.yperipheral == yp) {
            [cell updateDisplay];
            break;
        }
    }
}



- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    for (DEAPeripheralTableViewCell *cell in [self.peripheralsTableView visibleCells]) {
        [cell updateDisplay];
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    DEACentralManager *centralManager = [DEACentralManager sharedService];
    
    YMSCBPeripheral *yp = [centralManager findPeripheral:peripheral];
    if (yp.isRenderedInViewCell == NO) {
        [self.peripheralsTableView reloadData];
        yp.isRenderedInViewCell = YES;
    }
    
    if (centralManager.isScanning) {
        for (DEAPeripheralTableViewCell *cell in [self.peripheralsTableView visibleCells]) {
            if (cell.yperipheral.cbPeripheral == peripheral) {
                if (peripheral.state == CBPeripheralStateDisconnected) {
                    cell.rssiLabel.text = [NSString stringWithFormat:@"%ld", (long)[RSSI integerValue]];
                    float progval = [RSSI longValue]*(-1);
                    
                    if (progval >= 20  && progval <= 60)
                    {
                        cell.distanceProgress.progress = 1.0;
                        [cell.distanceSlider setValue:1.0];
                    }
                    
                    else if (progval > 60 && progval < 94)
                    {
                       cell.distanceProgress.progress = 0.5;
                        [cell.distanceSlider setValue:0.5];
                    
                    }
                    
                    else if (progval >= 94)
                    {
                       cell.distanceProgress.progress = 0.0;
                        [cell.distanceSlider setValue:0.0];
                    }
                    
                    
                    
                    cell.peripheralStatusLabel.text = @"ADVERTISING";
                    [cell.peripheralStatusLabel setTextColor:[[DEATheme sharedTheme] advertisingColor]];
                } else {
                    continue;
                }
            }
        }
    }
}


- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals {
    DEACentralManager *centralManager = [DEACentralManager sharedService];
    
    for (CBPeripheral *peripheral in peripherals) {
        YMSCBPeripheral *yp = [centralManager findPeripheral:peripheral];
        if (yp) {
            yp.delegate = self;
        }
    }
    
    [self.peripheralsTableView reloadData];

}


- (void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals {
    DEACentralManager *centralManager = [DEACentralManager sharedService];
    
    for (CBPeripheral *peripheral in peripherals) {
        YMSCBPeripheral *yp = [centralManager findPeripheral:peripheral];
        if (yp) {
            yp.delegate = self;
        }
    }
    
    [self.peripheralsTableView reloadData];
}

#pragma mark - CBPeripheralDelegate Methods

- (void)performUpdateRSSI:(NSArray *)args {
    CBPeripheral *peripheral = args[0];
    
    [peripheral readRSSI];

}


- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error {

    if (error) {
        NSLog(@"ERROR: readRSSI failed, retrying. %@", error.description);
        
        if (peripheral.state == CBPeripheralStateConnected) {
            NSArray *args = @[peripheral];
            [self performSelector:@selector(performUpdateRSSI:) withObject:args afterDelay:2.0];
        }

        return;
    }
    
    for (DEAPeripheralTableViewCell *cell in [self.peripheralsTableView visibleCells]) {
        if (cell.yperipheral) {
            if (cell.yperipheral.isConnected) {
                if (cell.yperipheral.cbPeripheral == peripheral) {
                    cell.rssiLabel.text = [NSString stringWithFormat:@"%@", peripheral.RSSI];
                    
                    float progval = [peripheral.RSSI longValue]*(-1);
                    
                    if (progval >= 20  && progval <= 50)
                    {
                        cell.distanceProgress.progress = 0.9;
                    }
                    
                    else if (progval > 50 && progval < 70)
                    {
                        cell.distanceProgress.progress = 0.55;
                        
                    }
                    
                    else if (progval >= 70)
                    {
                        cell.distanceProgress.progress = 0.25;
                        
                    }
                    

                                        
                    break;
                }
            }
        }
    }
    
    DEACentralManager *centralManager = [DEACentralManager sharedService];
    YMSCBPeripheral *yp = [centralManager findPeripheral:peripheral];
    
    NSArray *args = @[peripheral];
    [self performSelector:@selector(performUpdateRSSI:) withObject:args afterDelay:yp.rssiPingPeriod];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat result;
    result = 169.0;
    return result;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SensorTagCellIdentifier = @"SensorTagCell";
    //static NSString *UnknownPeripheralCellIdentifier = @"UnknownPeripheralCell";

    DEACentralManager *centralManager = [DEACentralManager sharedService];
    YMSCBPeripheral *yp = [centralManager peripheralAtIndex:indexPath.row];
    
    UITableViewCell *cell = nil;
    
    DEAPeripheralTableViewCell *pcell = (DEAPeripheralTableViewCell *)[tableView dequeueReusableCellWithIdentifier:SensorTagCellIdentifier];
    
    if (pcell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"DEAPeripheralTableViewCell" owner:self options:nil];
        pcell = self.tvCell;
        self.tvCell = nil;
    }
    
    yp.isRenderedInViewCell = YES;
    
    [pcell configureWithPeripheral:yp];
    
    cell = pcell;
    return cell;
    
   
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell isKindOfClass:[DEAPeripheralTableViewCell class]]) {
        [DEATheme customizePeripheralTableViewCell:(DEAPeripheralTableViewCell *)cell];
    }

    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    

    switch (editingStyle) {
        case UITableViewCellEditingStyleDelete: {
            DEACentralManager *centralManager = [DEACentralManager sharedService];
            YMSCBPeripheral *yp = [centralManager peripheralAtIndex:indexPath.row];
            if ([yp isKindOfClass:[DEASensorTag class]]) {
                if (yp.cbPeripheral.state == CBPeripheralStateConnected) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:@"Disconnect the peripheral before deleting."
                                                                   delegate:nil cancelButtonTitle:@"Dismiss"
                                                          otherButtonTitles:nil];
                    
                    [alert show];
                    
                    break;
                }
            }
            [centralManager removePeripheral:yp];
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
            
        case UITableViewCellEditingStyleInsert:
        case UITableViewCellEditingStyleNone:
            break;
            
        default:
            break;
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    DEACentralManager *centralManager = [DEACentralManager sharedService];
    NSInteger result;
    result = centralManager.count;
    return result;
    
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
 
    
    NSLog(@"Everything is fine");
 
    DEACentralManager *centralManager = [DEACentralManager sharedService];
    
    DEASensorTag *sensorTag = (DEASensorTag *)[centralManager.ymsPeripherals objectAtIndex:indexPath.row];
    
    DEASensorTagViewController *stvc = [[DEASensorTagViewController alloc] initWithNibName:@"DEASensorTagViewController" bundle:nil];
    stvc.sensorTag = sensorTag;
    
    
    [self.navigationController pushViewController:stvc animated:YES];
}


- (void)viewDidUnload {
    //[self setTvCell:nil];
    [super viewDidUnload];
}


- (IBAction)Back:(id)sender {
    
    //[self dismissViewControllerAnimated:YES completion:NULL];
    
    HomeViewController *second = [[HomeViewController alloc] initWithNibName:nil bundle:nil];
    second.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    //second.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:second animated:YES completion:NULL];

    
}

@end
