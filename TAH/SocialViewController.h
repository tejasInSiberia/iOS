//
//  SocialViewController.h
//  TAH
//
//  Created by DHIRAJ JADHAO on 21/05/14.
//  Copyright (c) 2014 DHIRAJJADHAO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface SocialViewController : UIViewController

{
SLComposeViewController *fbsheet,*tweetsheet,*gplussheet;
}
- (IBAction)fbpost:(id)sender;
- (IBAction)tweetpost:(id)sender;
- (IBAction)gpluspost:(id)sender;

@end
