//
//  MouseViewController.m
//  TAH Motion Control
//
//  Created by Dhiraj on 10/07/14.
//  Copyright (c) 2014 dhirajjadhao. All rights reserved.
//

#import "MouseViewController.h"
#import "HomeViewController.h"
#import "TAHble.h"
#import <AudioToolbox/AudioToolbox.h>

@interface MouseViewController ()

@end

@implementation MouseViewController

@synthesize sensor;
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
    
     AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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




-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    // Get the specific point that was touched
    CGPoint point = [touch locationInView:self.view];
    NSLog(@"X: %.0f Y: %.0f", point.x,point.y);

    
    [sensor TAHMosueMove:sensor.activePeripheral X:point.x Y:point.y Scroll:0.00];
    
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

    [sensor TAHMosueMove:sensor.activePeripheral X:160.00 Y:160.00 Scroll:0.00];
    
    NSLog(@"Touch Ended");
}


- (IBAction)doubletap:(id)sender {
 
  [self.navigationController popViewControllerAnimated:YES];
    
    
}
@end
