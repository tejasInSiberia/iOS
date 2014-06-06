//
//  ContactViewController.h
//  TAH
//
//  Created by DHIRAJ JADHAO on 19/05/14.
//  Copyright (c) 2014 DHIRAJJADHAO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ContactViewController : UIViewController<MFMailComposeViewControllerDelegate>
{

    IBOutlet UIButton *mail;

}
- (IBAction)mail:(id)sender;

@end
