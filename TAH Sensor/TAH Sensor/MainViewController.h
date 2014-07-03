//
//  ViewController.h
//  SidebarDemo
//
//  Created by Simon on 28/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAHble.h"

@class CBPeripheral;
@class TAHble;

@interface MainViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate,BTSmartSensorDelegate>
{
    NSArray *arrayOfdescription;
    NSArray *arrayofImages;
    NSArray *arrayofCellIdentifiers;

}

@property (strong, nonatomic) TAHble *sensor;
@property (strong, nonatomic) CBPeripheral *peripheral;

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end
