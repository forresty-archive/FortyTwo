//
//  FTTMUniverseView.m
//  FortyTwo
//
//  Created by Forrest Ye on 8/28/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import "FTTMUniverseView.h"


static inline CGFloat FTTObjectWidth() {
  return 5;
}

@implementation FTTMUniverseView


- (void)drawRect:(NSRect)dirtyRect {
//  NSLog(@"rect %@", NSStringFromRect(dirtyRect));
  [[NSColor blackColor] setFill];
  [[NSBezierPath bezierPathWithRect:dirtyRect] fill];

  // draw user object
  [[NSColor whiteColor] setFill];
  [[NSBezierPath bezierPathWithRect:[self rectForObjectPosition:self.dataSource.positionOfUserObject]] fill];

  // draw enemies
  [[NSColor redColor] setFill];
  for (NSString *positionString in self.dataSource.positionsOfEnemyObjects) {
    CGPoint enemyPosition = NSPointFromString(positionString);
    [[NSBezierPath bezierPathWithRect:[self rectForObjectPosition:enemyPosition]] fill];
  }
}


# pragma mark - private


- (CGRect)rectForObjectPosition:(CGPoint)position {
  CGRect rect = CGRectMake(position.x - FTTObjectWidth() / 2, position.y - FTTObjectWidth() / 2,
                           FTTObjectWidth(), FTTObjectWidth());

  return rect;
}


@end
