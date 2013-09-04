//
//  FTTKeyboardInputSource.m
//  FortyTwo
//
//  Created by Forrest Ye on 9/4/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import "FTTMKeyboardInputSource.h"

#import "FTTSpeedVector.h"


@interface FTTMKeyboardInputSource ()

@property (nonatomic) BOOL keyboardKeyPressedLeft;
@property (nonatomic) BOOL keyboardKeyPressedRight;
@property (nonatomic) BOOL keyboardKeyPressedDown;
@property (nonatomic) BOOL keyboardKeyPressedUp;

@end


static CGFloat FTTMUserObjectSpeed = 0.5;


@implementation FTTMKeyboardInputSource


- (FTTSpeedVector *)userSpeedVector {
  FTTSpeedVector *userSpeedVector = [[FTTSpeedVector alloc] init];

  if (self.keyboardKeyPressedLeft) {
    userSpeedVector.x -= FTTMUserObjectSpeed;
  }
  if (self.keyboardKeyPressedRight) {
    userSpeedVector.x += FTTMUserObjectSpeed;
  }
  if (self.keyboardKeyPressedDown) {
    userSpeedVector.y += FTTMUserObjectSpeed;
  }
  if (self.keyboardKeyPressedUp) {
    userSpeedVector.y -= FTTMUserObjectSpeed;
  }

  return userSpeedVector;
}


# pragma mark - keyboard event handling


- (void)keyDown:(NSEvent *)theEvent {
  if (theEvent.keyCode == 49) {
    // spacebar hit, deploy bomb
    [self.delegate keyboardInputSourceDidDeployedBomb];
  }

  // Arrow keys are associated with the numeric keypad
  if ([theEvent modifierFlags] & NSNumericPadKeyMask) {
    [self interpretKeyEvents:[NSArray arrayWithObject:theEvent]];
  } else {
    [super keyDown:theEvent];
  }
}

- (void)keyUp:(NSEvent *)theEvent {
  [super keyUp:theEvent];

  switch (theEvent.keyCode) {
    case 123: {
      self.keyboardKeyPressedLeft = NO;
      break;
    }
    case 124: {
      self.keyboardKeyPressedRight = NO;
      break;
    }
    case 125: {
      self.keyboardKeyPressedDown = NO;
      break;
    }
    case 126: {
      self.keyboardKeyPressedUp = NO;
      break;
    }
    default:
      break;
  }
}

- (void)moveLeft:(id)sender {
  self.keyboardKeyPressedLeft = YES;
}

- (void)moveRight:(id)sender {
  self.keyboardKeyPressedRight = YES;
}

- (void)moveDown:(id)sender {
  self.keyboardKeyPressedDown = YES;
}

- (void)moveUp:(id)sender {
  self.keyboardKeyPressedUp = YES;
}


@end
