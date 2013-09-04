//
//  FTTKeyboardInputSource.m
//  FortyTwo
//
//  Created by Forrest Ye on 9/4/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import "FTTKeyboardInputSource.h"

#import "FTTSpeedVector.h"



typedef NS_ENUM(NSUInteger, FTTMUserObjectVerticalHeading) {
  FTTMUserObjectVerticalHeadingNone,
  FTTMUserObjectVerticalHeadingUp,
  FTTMUserObjectVerticalHeadingDown,
};

typedef NS_ENUM(NSUInteger, FTTMUserObjectHorizontalHeading) {
  FTTMUserObjectHorizontalHeadingNone,
  FTTMUserObjectHorizontalHeadingLeft,
  FTTMUserObjectHorizontalHeadingRight,
};



@interface FTTKeyboardInputSource ()

// user control
@property (nonatomic) FTTMUserObjectVerticalHeading userObjectVerticalHeading;
@property (nonatomic) FTTMUserObjectHorizontalHeading userObjectHorizontalHeading;

@end


static CGFloat FTTMUserObjectSpeed = 0.5;


@implementation FTTKeyboardInputSource


- (FTTSpeedVector *)userSpeedVector {
  FTTSpeedVector *userSpeedVector = [[FTTSpeedVector alloc] init];

  switch (self.userObjectVerticalHeading) {
    case FTTMUserObjectVerticalHeadingUp: {
      userSpeedVector.y = -FTTMUserObjectSpeed;
      break;
    }
    case FTTMUserObjectVerticalHeadingDown: {
      userSpeedVector.y = FTTMUserObjectSpeed;
      break;
    }
    default: {
      userSpeedVector.y = 0;
      break;
    }
  }

  switch (self.userObjectHorizontalHeading) {
    case FTTMUserObjectHorizontalHeadingLeft: {
      userSpeedVector.x = -FTTMUserObjectSpeed;
      break;
    }
    case FTTMUserObjectHorizontalHeadingRight: {
      userSpeedVector.x = FTTMUserObjectSpeed;
      break;
    }
    default: {
      userSpeedVector.x = 0;
      break;
    }
  }

  return userSpeedVector;
}

# pragma mark - keyboard event handling


- (void)keyDown:(NSEvent *)theEvent {
  // Arrow keys are associated with the numeric keypad
  if ([theEvent modifierFlags] & NSNumericPadKeyMask) {
    [self interpretKeyEvents:[NSArray arrayWithObject:theEvent]];
  } else {
    [super keyDown:theEvent];
  }
}

- (void)keyUp:(NSEvent *)theEvent {
  [super keyUp:theEvent];
  if (theEvent.keyCode == 126 || theEvent.keyCode == 125) {
    // up or down
    self.userObjectVerticalHeading = FTTMUserObjectVerticalHeadingNone;
  } else if (theEvent.keyCode == 123 || theEvent.keyCode == 124) {
    // left or right
    self.userObjectHorizontalHeading = FTTMUserObjectHorizontalHeadingNone;
  }
}

- (void)moveUp:(id)sender {
  self.userObjectVerticalHeading = FTTMUserObjectVerticalHeadingUp;
}

- (void)moveDown:(id)sender {
  self.userObjectVerticalHeading = FTTMUserObjectVerticalHeadingDown;
}

- (void)moveLeft:(id)sender {
  self.userObjectHorizontalHeading = FTTMUserObjectHorizontalHeadingLeft;
}

- (void)moveRight:(id)sender {
  self.userObjectHorizontalHeading = FTTMUserObjectHorizontalHeadingRight;
}

@end
