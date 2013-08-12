//
//  FTTUniverseView.m
//  FortyTwo
//
//  Created by Forrest Ye on 8/11/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import "FTTUniverseView.h"

#import "FTTUserObject.h"
#import "FTTEnemyObject.h"


@interface FTTUniverseView ()

@property (nonatomic) UIColor *currentProgressBarColor;
@property (nonatomic) BOOL bombDeployed;

@end


@implementation FTTUniverseView


- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];

  if (self) {
    self.backgroundColor = [UIColor blackColor];
  }

  return self;
}


- (void)drawRect:(CGRect)rect {
  // draw user object
  [[UIColor whiteColor] setFill];
  [[UIBezierPath bezierPathWithRect:[self rectForObjectPosition:self.userObject.position]] fill];

  // draw enemies
  [[UIColor redColor] setFill];
  for (FTTEnemyObject *enemy in self.enemies) {
    [[UIBezierPath bezierPathWithRect:[self rectForObjectPosition:enemy.position]] fill];
  }

  // draw time
  UIColor *progressBarColor = self.currentProgressBarColor;
  [progressBarColor setStroke];
  CGRect timeBorderRect = CGRectMake(CGRectGetMaxX(self.bounds) - 100, 20, 80, 8);
  [[UIBezierPath bezierPathWithRect:timeBorderRect] stroke];

  [progressBarColor setFill];
  CGRect timePlayedRect = CGRectMake(CGRectGetMaxX(self.bounds) - 100, 20, MIN(80, 80 * self.bombCooldownTime / FTTBombCooldownTime), 8);
  [[UIBezierPath bezierPathWithRect:timePlayedRect] fill];

  // bomb
  if (self.bombDeployed) {
    // draw bomb effect

    self.bombDeployed = NO;
  }
}


- (BOOL)bombAvailable {
  return self.bombCooldownTime >= FTTBombCooldownTime;
}


- (UIColor *)currentProgressBarColor {
  // change color every 0.5 seconds
  if (self.bombAvailable && (self.bombCooldownTime - (NSUInteger)self.bombCooldownTime) < 0.5) {
    return [UIColor blueColor];
  }

  return [UIColor whiteColor];
}


- (void)deployBomb {
  self.bombDeployed = YES;
}


# pragma mark - private


- (CGRect)rectForObjectPosition:(CGPoint)position {
  CGRect rect = CGRectMake(position.x - FTTObjectWidth() / 2, position.y - FTTObjectWidth() / 2,
                           FTTObjectWidth(), FTTObjectWidth());

  return rect;
}


@end
