//
//  HomeViewController.h
//  GBox
//
//  Created by DHIRAJ JADHAO on 09/02/14.
//  Copyright (c) 2014 DHIRAJJADHAO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController
{

    IBOutlet UIButton *Settings;
 
    IBOutlet UIButton *NeverLoose;
    IBOutlet UIButton *Finder;

}
- (IBAction)Settings:(id)sender;

- (IBAction)Finder:(id)sender;
- (IBAction)NeverLoose:(id)sender;

@end
