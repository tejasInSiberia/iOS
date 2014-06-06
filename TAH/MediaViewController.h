//
//  MediaViewController.h
//  TAH
//
//  Created by DHIRAJ JADHAO on 19/05/14.
//  Copyright (c) 2014 DHIRAJJADHAO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MediaViewController : UIViewController
{

    IBOutlet UIWebView *webView;
    IBOutlet UIActivityIndicatorView *activityind;
    NSTimer *timer;
    
}


@end
