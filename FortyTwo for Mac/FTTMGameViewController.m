//
//  FTTMGameViewController.m
//  FortyTwo
//
//  Created by Forrest Ye on 8/28/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import "FTTMGameViewController.h"

// views
#import "FTTMUniverseView.h"

// models
#import "FTTUniverse.h"


@interface FTTMGameViewController ()

// views
@property (nonatomic) FTTMUniverseView *universeView;

// models
@property (nonatomic) FTTUniverse *universe;

// game play
@property (nonatomic) FTTFrameManager *frameManager;

@property (nonatomic) BOOL gamePlaying;

@property (nonatomic) NSTimeInterval cumulatedCurrentGamePlayTime;
@property (nonatomic) NSTimeInterval resumedTimestamp;

@end


@implementation FTTMGameViewController


- (id)init {
  self = [super init];

  if (self) {
    [self restartGame];
  }

  return self;
}


# pragma mark - game play


- (void)restartGame {
  self.universeView = [[FTTMUniverseView alloc] initWithFrame:NSMakeRect(0, 0, 100, 100)];
  self.view = self.universeView;

  self.universe = [[FTTUniverse alloc] init];
  self.universeView.dataSource = self.universe;

  self.frameManager = [[FTTFrameManager alloc] initWithFrameRate:42];
  self.frameManager.delegate = self;
  [self.frameManager start];

  self.gamePlaying = YES;
}


- (void)updateTimestampsWithTimeInterval:(NSTimeInterval)timestamp {
  if (self.resumedTimestamp == 0) {
    self.resumedTimestamp = timestamp;
  }
  self.cumulatedCurrentGamePlayTime = timestamp - self.resumedTimestamp;
}


- (void)updateUniverse {
  [self.universeView setNeedsDisplay:YES];
}


- (void)detectCollision {
  if (self.universe.userIsHit) {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
      [self youAreDead];
    }];
  }
}

- (void)youAreDead {
  @synchronized(self) {
    if (self.gamePlaying) {
      [self stopGame];

      NSLog(@"you are dead");
//      if (self.gameCenterEnabled) {
//        [self reportScore];
//      }
//
//      [self showGameOverAlert];
    }
  }
}

- (void)stopGame {
  [self.frameManager pause];

  self.gamePlaying = NO;
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
    self.universe.userObjectVerticalHeading = FTTMUserObjectVerticalHeadingNone;
  } else if (theEvent.keyCode == 123 || theEvent.keyCode == 124) {
    // left or right
    self.universe.userObjectHorizontalHeading = FTTMUserObjectHorizontalHeadingNone;
  }
}

- (void)moveUp:(id)sender {
  self.universe.userObjectVerticalHeading = FTTMUserObjectVerticalHeadingUp;
}

- (void)moveDown:(id)sender {
  self.universe.userObjectVerticalHeading = FTTMUserObjectVerticalHeadingDown;
}

- (void)moveLeft:(id)sender {
  self.universe.userObjectHorizontalHeading = FTTMUserObjectHorizontalHeadingLeft;
}

- (void)moveRight:(id)sender {
  self.universe.userObjectHorizontalHeading = FTTMUserObjectHorizontalHeadingRight;
}


# pragma mark - FTTFrameManagerDelegate


- (void)frameManagerDidUpdateFrame {
  [self updateTimestampsWithTimeInterval:[NSDate timeIntervalSinceReferenceDate]];

  [self.universe tick];

  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    [self updateUniverse];
  }];

  [self detectCollision];
}


@end
