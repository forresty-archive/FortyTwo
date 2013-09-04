//
//  FTTMUniverseView.m
//  FortyTwo
//
//  Created by Forrest Ye on 8/28/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import "FTTMUniverseView.h"


@interface FTTMUniverseView ()

@property (nonatomic) BOOL bombDeployed;

@end


static inline CGFloat FTTObjectWidth() {
  return 5;
}

static NSUInteger FTTBombCooldownTime = 42;


@implementation FTTMUniverseView

//- (void)deployBomb {
//  self.bombDeployed = YES;
//}


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

  // draw time
  NSColor *progressBarColor = [NSColor whiteColor];
  [progressBarColor setStroke];
  CGRect timeBorderRect = CGRectMake(CGRectGetMaxX(self.bounds) - 120, CGRectGetMaxY(self.bounds) - 20, 100, 10);
  [[NSBezierPath bezierPathWithRect:timeBorderRect] stroke];

  [progressBarColor setFill];
  CGRect timePlayedRect = CGRectMake(CGRectGetMaxX(self.bounds) - 120, CGRectGetMaxY(self.bounds) - 20,
                                     MIN(100, [self.dataSource percentCompleteOfBombRecharge]), 10);
  [[NSBezierPath bezierPathWithRect:timePlayedRect] fill];

  // bomb
  if (self.bombDeployed) {
    // TODO
  }
}


# pragma mark - private


- (CGRect)rectForObjectPosition:(CGPoint)position {
  CGRect rect = CGRectMake(position.x - FTTObjectWidth() / 2, position.y - FTTObjectWidth() / 2,
                           FTTObjectWidth(), FTTObjectWidth());

  return rect;
}


@end
