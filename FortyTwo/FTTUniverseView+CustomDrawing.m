//
//  FTTUniverseView+CustomDrawing.m
//  FortyTwo
//
//  Created by Forrest Ye on 9/6/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import "FTTUniverseView+CustomDrawing.h"

#import "FTTDefines.h"


@implementation FTTUniverseView (CustomDrawing)


- (void)drawRect:(CGRect)rect {
  // draw user object
  [[UIColor whiteColor] setFill];
  [[UIBezierPath bezierPathWithRect:[self rectForObjectPosition:self.dataSource.positionOfUserObject]] fill];

  // draw enemies
  [[UIColor redColor] setFill];
  for (NSString *positionString in self.dataSource.positionsOfEnemyObjects) {
    CGPoint enemyPosition = CGPointFromString(positionString);
    [[UIBezierPath bezierPathWithRect:[self rectForObjectPosition:enemyPosition]] fill];
  }

  if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(currentContext, 2, 2);
    CGContextTranslateCTM(currentContext, -CGRectGetWidth(self.bounds) / 2, 0);
  }

  // draw time
  UIColor *progressBarColor = self.currentProgressBarColor;
  [progressBarColor setStroke];
  CGRect timeBorderRect = CGRectMake(CGRectGetMaxX(self.bounds) - 120, 20, 100, 10);
  [[UIBezierPath bezierPathWithRect:timeBorderRect] stroke];

  [progressBarColor setFill];
  CGRect timePlayedRect = CGRectMake(CGRectGetMaxX(self.bounds) - 120, 20,
                                     MIN(100, 100 * self.bombCooldownTime / FTTBombCooldownTime), 10);
  [[UIBezierPath bezierPathWithRect:timePlayedRect] fill];

  // draw bomb indicator
  if (self.dataSource.bombAvailable) {
    NSUInteger xOffset = CGRectGetMaxX(self.bounds) - 120 - 12;
    NSUInteger yOffset = 20;

    //// Rectangle 2 Drawing
    UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRect: CGRectMake(0 + xOffset, 1.5 + yOffset, 1.5, 7.5)];
    [rectangle2Path fill];

    //// Rectangle 3 Drawing
    UIBezierPath* rectangle3Path = [UIBezierPath bezierPathWithRect: CGRectMake(1 + xOffset, 0 + yOffset, 5.5, 1.5)];
    [rectangle3Path fill];

    //// Rectangle 4 Drawing
    UIBezierPath* rectangle4Path = [UIBezierPath bezierPathWithRect: CGRectMake(6 + xOffset, 1.5 + yOffset, 1.5, 2.5)];
    [rectangle4Path fill];

    //// Rectangle 5 Drawing
    UIBezierPath* rectangle5Path = [UIBezierPath bezierPathWithRect: CGRectMake(6 + xOffset, 5.5 + yOffset, 1.5, 1)];
    [rectangle5Path fill];

    //// Rectangle 6 Drawing
    UIBezierPath* rectangle6Path = [UIBezierPath bezierPathWithRect: CGRectMake(6.5 + xOffset, 8 + yOffset, 1.5, 1)];
    [rectangle6Path fill];

    //// Rectangle 7 Drawing
    UIBezierPath* rectangle7Path = [UIBezierPath bezierPathWithRect: CGRectMake(7 + xOffset, 6.5 + yOffset, 1.5, 1.5)];
    [rectangle7Path fill];

    //// Rectangle 8 Drawing
    UIBezierPath* rectangle8Path = [UIBezierPath bezierPathWithRect: CGRectMake(1 + xOffset, 9 + yOffset, 6.5, 1.5)];
    [rectangle8Path fill];

    //// Rectangle 9 Drawing
    UIBezierPath* rectangle9Path = [UIBezierPath bezierPathWithRect: CGRectMake(1.5 + xOffset, 4 + yOffset, 5, 1.5)];
    [rectangle9Path fill];
  }

  static NSUInteger bombEffectFramesDrawn = 0;

  // bomb
  if (self.bombDeployed) {
    // draw bomb effect
    [[UIColor whiteColor] setFill];
    [[UIBezierPath bezierPathWithRect:rect] fill];

    bombEffectFramesDrawn += 1;

    // only draw 5 frames
    if (bombEffectFramesDrawn > 5) {
      bombEffectFramesDrawn = 0;
      self.bombDeployed = NO;
    }
  }
}


# pragma mark - private


- (UIColor *)currentProgressBarColor {
  // change color every 0.5 seconds
  if (self.dataSource.bombAvailable && (self.bombCooldownTime - (NSUInteger)self.bombCooldownTime) < 0.5) {
    return [UIColor blueColor];
  }

  return [UIColor whiteColor];
}

- (CGRect)rectForObjectPosition:(CGPoint)position {
  CGRect rect = CGRectMake(position.x - FTTObjectWidth() / 2,
                           position.y - FTTObjectWidth() / 2,
                           FTTObjectWidth(),
                           FTTObjectWidth());
  
  return rect;
}


@end
