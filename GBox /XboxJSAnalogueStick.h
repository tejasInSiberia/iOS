//
//  XboxJSAnalogueStick.h
//  Controller
//
//  Created by James Addyman on 29/03/2013.
//  Copyright (c) 2013 James Addyman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  XboxJSAnalogueStick;

@protocol XboxJSAnalogueStickDelegate <NSObject>

@optional
- (void)analogueStickDidChangeValue:(XboxJSAnalogueStick *)analogueStick;

@end

@interface XboxJSAnalogueStick : UIView

@property (nonatomic, readonly) CGFloat xValue;
@property (nonatomic, readonly) CGFloat yValue;
@property (nonatomic, assign) BOOL invertedYAxis;

@property (nonatomic, assign) IBOutlet id <XboxJSAnalogueStickDelegate> delegate;

@property (nonatomic, readonly) UIImageView *backgroundImageView;
@property (nonatomic, readonly) UIImageView *handleImageView;

@end
