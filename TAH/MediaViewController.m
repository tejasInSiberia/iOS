//
//  MediaViewController.m
//  TAH
//
//  Created by DHIRAJ JADHAO on 19/05/14.
//  Copyright (c) 2014 DHIRAJJADHAO. All rights reserved.
//

#import "MediaViewController.h"

@interface MediaViewController ()
{

    NSString *youtube;
    

}
@end

@implementation MediaViewController

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
    
    youtube = @"http://m.youtube.com/user/dhieajjadhao";
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:youtube]]];



    [webView addSubview:activityind];
    timer = [NSTimer scheduledTimerWithTimeInterval:(1.0/2.0)
                                             target:self
                                           selector:@selector(loading)
                                           userInfo:nil
                                            repeats:YES];
    




}



-(void)loading {
    if (!webView.loading)
        [activityind stopAnimating];
    else
        [activityind startAnimating];
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

@end
