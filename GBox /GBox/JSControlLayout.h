//
//  JSControlLayout.h
//  Controller
//
//  Created by James Addyman on 04/04/2013.
//  Copyright (c) 2013 James Addyman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSDPad.h"


@interface JSControlLayout : UIView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) UIDeviceOrientation orientation;

@property (nonatomic, assign) id <JSDPadDelegate> delegate;

- (id)initWithLayout:(NSString *)layoutFile delegate:(id <JSDPadDelegate>)delegate;

@end
