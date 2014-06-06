//
//  ComputerJSDPad.h
//  Controller
//
//  Created by James Addyman on 28/03/2013.
//  Copyright (c) 2013 James Addyman. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ComputerJSDPadDirection)
{
	ComputerJSDPadDirectionUpLeft = 1,
	ComputerJSDPadDirectionUp,
	ComputerJSDPadDirectionUpRight,
	ComputerJSDPadDirectionLeft,
	ComputerJSDPadDirectionNone,
	ComputerJSDPadDirectionRight,
	ComputerJSDPadDirectionDownLeft,
	ComputerJSDPadDirectionDown,
	ComputerJSDPadDirectionDownRight
};

@class ComputerJSDPad;

@protocol ComputerJSDPadDelegate <NSObject>

- (void)dPad:(ComputerJSDPad *)dPad didPressDirection:(ComputerJSDPadDirection)direction;
- (void)dPadDidReleaseDirection:(ComputerJSDPad *)dPad;

@end

@interface ComputerJSDPad : UIView

@property (nonatomic, weak) IBOutlet id <ComputerJSDPadDelegate> delegate;

- (ComputerJSDPadDirection)currentDirection;

@end
