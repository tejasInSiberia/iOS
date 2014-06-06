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
    IBOutlet UIButton *Sony;
    IBOutlet UIButton *Computer;
    IBOutlet UIButton *Xbox;
    IBOutlet UIButton *Finder;

}
- (IBAction)Settings:(id)sender;
- (IBAction)Sony:(id)sender;
- (IBAction)Computer:(id)sender;
- (IBAction)Xbox:(id)sender;
- (IBAction)Finder:(id)sender;

@end
