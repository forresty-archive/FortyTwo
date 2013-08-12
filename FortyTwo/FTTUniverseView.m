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

// bomd effect drawing
@property (nonatomic) NSUInteger bombEffectFramesDrawn;

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
  CGRect timePlayedRect = CGRectMake(CGRectGetMaxX(self.bounds) - 100, 20,
                                     MIN(80, 80 * self.bombCooldownTime / FTTBombCooldownTime), 8);
  [[UIBezierPath bezierPathWithRect:timePlayedRect] fill];

  // draw bomb indicator
  if (progressBarColor == [UIColor blueColor]) {
    UIBezierPath *bombPath = [UIBezierPath bezierPath];
    NSUInteger xOffset = CGRectGetMaxX(self.bounds) - 100 - 6;
    NSUInteger yOffset = 20 + 1;

    [bombPath moveToPoint:CGPointMake(xOffset, yOffset)];
    [bombPath addLineToPoint:CGPointMake(xOffset, yOffset + 6)];
    [bombPath addLineToPoint:CGPointMake(xOffset + 2, yOffset + 6)];
    [bombPath addLineToPoint:CGPointMake(xOffset + 3, yOffset + 5)];
    [bombPath addLineToPoint:CGPointMake(xOffset + 3, yOffset + 4)];
    [bombPath addLineToPoint:CGPointMake(xOffset + 2, yOffset + 3)];
    [bombPath addLineToPoint:CGPointMake(xOffset + 0, yOffset + 3)];
    [bombPath addLineToPoint:CGPointMake(xOffset + 2, yOffset + 3)];
    [bombPath addLineToPoint:CGPointMake(xOffset + 3, yOffset + 2)];
    [bombPath addLineToPoint:CGPointMake(xOffset + 3, yOffset + 1)];
    [bombPath addLineToPoint:CGPointMake(xOffset + 2, yOffset)];
    [bombPath closePath];

    [bombPath stroke];
  }

  // bomb
  if (self.bombDeployed) {
    // draw bomb effect
    [[UIColor whiteColor] setFill];
    [[UIBezierPath bezierPathWithRect:rect] fill];

    self.bombEffectFramesDrawn += 1;

    // only draw 5 frames
    if (self.bombEffectFramesDrawn > 5) {
      self.bombEffectFramesDrawn = 0;
      self.bombDeployed = NO;
    }
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
