//
//  ComputerJSDPad.m
//  Controller
//
//  Created by James Addyman on 28/03/2013.
//  Copyright (c) 2013 James Addyman. All rights reserved.
//

#import "ComputerJSDPad.h"
#import <AVFoundation/AVFoundation.h>

@interface ComputerJSDPad () {
	
	ComputerJSDPadDirection _currentDirection;
	
	UIImageView *_dPadImageView;
	
}

@end

@implementation ComputerJSDPad

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
	
	_currentDirection = ComputerJSDPadDirectionNone;
}

- (void)dealloc
{
	self.delegate = nil;
}

- (ComputerJSDPadDirection)currentDirection
{
	return _currentDirection;
}

- (ComputerJSDPadDirection)directionForPoint:(CGPoint)point
{
	CGFloat x = point.x;
	CGFloat y = point.y;
	
	if (((x < 0) || (x > [self bounds].size.width)) ||
		((y < 0) || (y > [self bounds].size.height)))
	{
		return ComputerJSDPadDirectionNone;
	}
	
	NSUInteger column = x / ([self bounds].size.width / 3);
	NSUInteger row = y / ([self bounds].size.height / 3);

	ComputerJSDPadDirection direction = (row * 3) + column + 1;
	
	return direction;
}

- (UIImage *)imageForDirection:(ComputerJSDPadDirection)direction
{
	UIImage *image = nil;
	
	switch (direction) {
		case ComputerJSDPadDirectionNone:
			image = [UIImage imageNamed:@"XdPad"];
			break;
		case ComputerJSDPadDirectionUp:
			image = [UIImage imageNamed:@"XUp"];
			break;
		case ComputerJSDPadDirectionDown:
			image = [UIImage imageNamed:@"XDown"];
			break;
		case ComputerJSDPadDirectionLeft:
			image = [UIImage imageNamed:@"XLeft"];
			break;
		case ComputerJSDPadDirectionRight:
			image = [UIImage imageNamed:@"XRight"];
			break;
		case ComputerJSDPadDirectionUpLeft:
			image = [UIImage imageNamed:@"XdPad"];
			break;
		case ComputerJSDPadDirectionUpRight:
			image = [UIImage imageNamed:@"XdPad"];
			break;
		case ComputerJSDPadDirectionDownLeft:
			image = [UIImage imageNamed:@"XdPad"];
			break;
		case ComputerJSDPadDirectionDownRight:
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
	
	ComputerJSDPadDirection direction = [self directionForPoint:point];
	
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
	
	ComputerJSDPadDirection direction = [self directionForPoint:point];
	
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
	_currentDirection = ComputerJSDPadDirectionNone;
	[_dPadImageView setImage:[self imageForDirection:_currentDirection]];
	
	if ([self.delegate respondsToSelector:@selector(dPadDidReleaseDirection:)])
	{
		[self.delegate dPadDidReleaseDirection:self];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	_currentDirection = ComputerJSDPadDirectionNone;
	[_dPadImageView setImage:[self imageForDirection:_currentDirection]];
	
	if ([self.delegate respondsToSelector:@selector(dPadDidReleaseDirection:)])
	{
		[self.delegate dPadDidReleaseDirection:self];
	}
}

@end
