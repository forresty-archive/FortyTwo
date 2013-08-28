//
//  FTTMUniverseView.m
//  FortyTwo
//
//  Created by Forrest Ye on 8/28/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import "FTTMUniverseView.h"

#import "FTTUserObject.h"
#import "FTTEnemyObject.h"


static inline CGFloat FTTObjectWidth() {
  return 5;
}

@implementation FTTMUniverseView

- (id)initWithFrame:(NSRect)frame {
  self = [super initWithFrame:frame];

  if (self) {
//    NSLog(@"frame %@", NSStringFromRect(frame));
    // Initialization code here.
  }

  return self;
}

- (void)drawRect:(NSRect)dirtyRect {
//  NSLog(@"rect %@", NSStringFromRect(dirtyRect));
  [[NSColor blackColor] setFill];
  [[NSBezierPath bezierPathWithRect:dirtyRect] fill];

  // draw user object
  [[NSColor whiteColor] setFill];
  [[NSBezierPath bezierPathWithRect:[self rectForObjectPosition:self.userObject.position]] fill];

  // draw enemies
  [[NSColor redColor] setFill];
  for (FTTEnemyObject *enemy in self.enemies) {
    [[NSBezierPath bezierPathWithRect:[self rectForObjectPosition:enemy.position]] fill];
  }
}


# pragma mark - private


- (CGRect)rectForObjectPosition:(CGPoint)position {
  CGRect rect = CGRectMake(position.x - FTTObjectWidth() / 2, position.y - FTTObjectWidth() / 2,
                           FTTObjectWidth(), FTTObjectWidth());

  return rect;
}


@end
