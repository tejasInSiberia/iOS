//
//  SocialViewController.m
//  TAH
//
//  Created by DHIRAJ JADHAO on 21/05/14.
//  Copyright (c) 2014 DHIRAJJADHAO. All rights reserved.
//

#import "SocialViewController.h"

@interface SocialViewController ()

@end

@implementation SocialViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)fbpost:(id)sender {
    
    fbsheet = [[SLComposeViewController alloc] init];
    fbsheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [fbsheet setInitialText:@"Hi Guys, Check Out this cool board TAH"];
   
    
    [self presentViewController:fbsheet animated:YES completion:nil];
}

- (IBAction)tweetpost:(id)sender {
    
    tweetsheet = [[SLComposeViewController alloc] init];
    tweetsheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweetsheet setInitialText:@"Hi Guys, Check Out this cool board TAH"];
    
    
    [self presentViewController:tweetsheet animated:YES completion:nil];
}

- (IBAction)gpluspost:(id)sender {
    
}
@end
