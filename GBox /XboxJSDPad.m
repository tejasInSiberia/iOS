//
//  XboxJSDPad.m
//  Controller
//
//  Created by James Addyman on 28/03/2013.
//  Copyright (c) 2013 James Addyman. All rights reserved.
//

#import "XboxJSDPad.h"
#import "AudioToolbox/AudioToolbox.h"
#import <AVFoundation/AVFoundation.h>

@interface XboxJSDPad () {
	
	XboxJSDPadDirection _currentDirection;
	
	UIImageView *_dPadImageView;
	
}

@end

@implementation XboxJSDPad

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
		[self commonInit];
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super initWithCoder:decoder]))
	{
		[self commonInit];
	}
	
	return self;
}

- (void)commonInit
{
	_dPadImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"XdPad"]];
	[_dPadImageView setFrame:CGRectMake(0, 0, [self bounds].size.width, [self bounds].size.height)];
	[self addSubview:_dPadImageView];
	
	_currentDirection = XboxJSDPadDirectionNone;
}

- (void)dealloc
{
	self.delegate = nil;
}

- (XboxJSDPadDirection)currentDirection
{
	return _currentDirection;
}

- (XboxJSDPadDirection)directionForPoint:(CGPoint)point
{
	CGFloat x = point.x;
	CGFloat y = point.y;
	
	if (((x < 0) || (x > [self bounds].size.width)) ||
		((y < 0) || (y > [self bounds].size.height)))
	{
		return XboxJSDPadDirectionNone;
	}
	
	NSUInteger column = x / ([self bounds].size.width / 3);
	NSUInteger row = y / ([self bounds].size.height / 3);

	XboxJSDPadDirection direction = (row * 3) + column + 1;
	
	return direction;
}

- (UIImage *)imageForDirection:(XboxJSDPadDirection)direction
{
	UIImage *image = nil;
	
	switch (direction) {
		case XboxJSDPadDirectionNone:
			image = [UIImage imageNamed:@"XdPad"];
			break;
		case XboxJSDPadDirectionUp:
			image = [UIImage imageNamed:@"XUp"];
			break;
		case XboxJSDPadDirectionDown:
			image = [UIImage imageNamed:@"XDown"];
			break;
		case XboxJSDPadDirectionLeft:
			image = [UIImage imageNamed:@"XLeft"];
			break;
		case XboxJSDPadDirectionRight:
			image = [UIImage imageNamed:@"XRight"];
			break;
		case XboxJSDPadDirectionUpLeft:
			image = [UIImage imageNamed:@"XdPad"];
			break;
		case XboxJSDPadDirectionUpRight:
			image = [UIImage imageNamed:@"XdPad"];
			break;
		case XboxJSDPadDirectionDownLeft:
			image = [UIImage imageNamed:@"XdPad"];
			break;
		case XboxJSDPadDirectionDownRight:
			image = [UIImage imageNamed:@"XdPad"];
			break;
		default:
			image = [UIImage imageNamed:@"XdPad"];
			break;
	}
	
	return image;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:self];
	
	XboxJSDPadDirection direction = [self directionForPoint:point];
	
	if (direction != _currentDirection)
	{
		_currentDirection = direction;
		
		[_dPadImageView setImage:[self imageForDirection:_currentDirection]];
		
		if ([self.delegate respondsToSelector:@selector(dPad:didPressDirection:)])
		{
			[self.delegate dPad:self didPressDirection:_currentDirection];
            

            
            
		}
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint point = [touch locationInView:self];
	
	XboxJSDPadDirection direction = [self directionForPoint:point];
	
	if (direction != _currentDirection)
	{
		_currentDirection = direction;
		[_dPadImageView setImage:[self imageForDirection:_currentDirection]];
		
		if ([self.delegate respondsToSelector:@selector(dPad:didPressDirection:)])
		{
			[self.delegate dPad:self didPressDirection:_currentDirection];
		}
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	_currentDirection = XboxJSDPadDirectionNone;
	[_dPadImageView setImage:[self imageForDirection:_currentDirection]];
	
	if ([self.delegate respondsToSelector:@selector(dPadDidReleaseDirection:)])
	{
		[self.delegate dPadDidReleaseDirection:self];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	_currentDirection = XboxJSDPadDirectionNone;
	[_dPadImageView setImage:[self imageForDirection:_currentDirection]];
	
	if ([self.delegate respondsToSelector:@selector(dPadDidReleaseDirection:)])
	{
		[self.delegate dPadDidReleaseDirection:self];
	}
}

@end
