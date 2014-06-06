//
//  XboxJSDPad.h
//  Controller
//
//  Created by James Addyman on 28/03/2013.
//  Copyright (c) 2013 James Addyman. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, XboxJSDPadDirection)
{
	XboxJSDPadDirectionUpLeft = 1,
	XboxJSDPadDirectionUp,
	XboxJSDPadDirectionUpRight,
	XboxJSDPadDirectionLeft,
	XboxJSDPadDirectionNone,
	XboxJSDPadDirectionRight,
	XboxJSDPadDirectionDownLeft,
	XboxJSDPadDirectionDown,
	XboxJSDPadDirectionDownRight
};

@class XboxJSDPad;

@protocol XboxJSDPadDelegate <NSObject>

- (void)dPad:(XboxJSDPad *)dPad didPressDirection:(XboxJSDPadDirection)direction;
- (void)dPadDidReleaseDirection:(XboxJSDPad *)dPad;

@end

@interface XboxJSDPad : UIView

@property (nonatomic, weak) IBOutlet id <XboxJSDPadDelegate> delegate;

- (XboxJSDPadDirection)currentDirection;

@end
