//
//  ViewController.m
//  SidebarDemo
//
//  Created by Simon on 28/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "MainViewController.h"
#import "SWRevealViewController.h"
#import "CustomCell.h"
#import "SonarViewController.h"
#import "TemperatureViewController.h"
#import "TouchViewController.h"
#import "LightViewController.h"
#import "WindViewController.h"
#import "RainViewController.h"
#import "MotionViewController.h"
#import "SoilMoistureViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize sidebarButton;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
   /////////////////// Navigation Bar Customisation ////////////
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    ////////////////////////////////////////////////////////////////////////
    
    
    /////////////// Setting Collection View Delegate and Datasource /////////////
    
    [[self myCollectionView]setDelegate:self];
    [[self myCollectionView]setDataSource:self];
    ////////////////////////////////////////////////////////////////////////////
    
    
    /////////////// Setting array of Images and Identifiers for Collection View Cells /////////////
    arrayofImages = [[NSArray alloc]initWithObjects:@"sonar.png",@"temp.png",@"touch.png",@"light.png",@"rain.png",@"wind.png",@"motion.png",@"soil.png", nil];
    arrayofCellIdentifiers = [[NSArray alloc]initWithObjects:@"Cell1",@"Cell2",@"Cell3",@"Cell4",@"Cell5",@"Cell6",@"Cell7",@"Cell8", nil];
    
    ////////////////////////////////////////////////////////////////////////////


    /////////////// Side Menu Settings /////////////
    
    // Change button color
    sidebarButton.tintColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    sidebarButton.target = self.revealViewController;
    sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
   //////////////////////////////////////////////////

}


///////////// Collection View Setup /////////////////

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return 8;

}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    //CustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell1" forIndexPath:indexPath];
    
    CustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[arrayofCellIdentifiers objectAtIndex:indexPath.row] forIndexPath:indexPath];
    
   [[cell myImage]setImage:[UIImage imageNamed:[arrayofImages objectAtIndex:indexPath.row]]];

    
   
    return cell;
}

//////////////////////////////////////////////////



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//////////////////////// Preparing Segue for Navigation //////////////////////////

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   
    
    if ([[segue identifier] isEqualToString:@"Cell1"])
    {
      SonarViewController *detailViewController = [segue destinationViewController];
        
        detailViewController.title = @"Sonar Sensor";

        
        
    }
    
    else if ([[segue identifier] isEqualToString:@"Cell2"])
    {
        TemperatureViewController *detailViewController = [segue destinationViewController];
        
        detailViewController.title = @"Temperature";
    }
    
    
    else if ([[segue identifier] isEqualToString:@"Cell3"])
    {
        TouchViewController *detailViewController = [segue destinationViewController];
        
        detailViewController.title = @"Touch Sensor";
    }
    
    
    else if ([[segue identifier] isEqualToString:@"Cell4"])
    {
        LightViewController *detailViewController = [segue destinationViewController];
        
        detailViewController.title = @"Light Level";
    }
    
    
    else if ([[segue identifier] isEqualToString:@"Cell5"])
    {
        RainViewController *detailViewController = [segue destinationViewController];
        
        detailViewController.title = @"Rain Sensor";
    }
    
    
    else if ([[segue identifier] isEqualToString:@"Cell6"])
    {
        WindViewController *detailViewController = [segue destinationViewController];
        
        detailViewController.title = @"Wind Sensor";
    }
    
    
    else if ([[segue identifier] isEqualToString:@"Cell7"])
    {
        MotionViewController *detailViewController = [segue destinationViewController];
        
        detailViewController.title = @"Motion Sensor";
    }
    
    
    else if ([[segue identifier] isEqualToString:@"Cell8"])
    {
        SoilMoistureViewController *detailViewController = [segue destinationViewController];
        
        detailViewController.title = @"Soil Moisture";
    }
}

//////////////////////////////////////////////////////////////////////////////////

@end
