//
//  HomeViewController.m
//  GBox
//
//  Created by DHIRAJ JADHAO on 09/02/14.
//  Copyright (c) 2014 DHIRAJJADHAO. All rights reserved.
//

#import "HomeViewController.h"
#import "SettingsViewController.h"
#import "SonyViewController.h"
#import "ComputerViewController.h"
#import "XboxViewController.h"
#import "GBoxFinderViewController.h"

@interface HomeViewController ()



@end

@implementation HomeViewController

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
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Settings:(id)sender {
    
    
    SettingsViewController *second = [[SettingsViewController alloc] initWithNibName:nil bundle:nil];
    second.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    //second.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:second animated:YES completion:NULL];
}

- (IBAction)Sony:(id)sender {
    
    SonyViewController *second = [[SonyViewController alloc] initWithNibName:nil bundle:nil];
    second.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    //second.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:second animated:YES completion:NULL];
    
}

- (IBAction)Computer:(id)sender {
    
    ComputerViewController *second = [[ComputerViewController alloc] initWithNibName:nil bundle:nil];
    second.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    //second.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:second animated:YES completion:NULL];
}

- (IBAction)Xbox:(id)sender {
    
    XboxViewController *second = [[XboxViewController alloc] initWithNibName:nil bundle:nil];
    second.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    //second.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:second animated:YES completion:NULL];

    
}

- (IBAction)Finder:(id)sender {
    
    GBoxFinderViewController *second = [[GBoxFinderViewController alloc] initWithNibName:nil bundle:nil];
    second.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    //second.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [self presentViewController:second animated:YES completion:NULL];
}
@end
