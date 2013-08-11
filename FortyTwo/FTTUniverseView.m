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


static inline CGFloat FTTObjectWidth() {
  if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
    return 8;
  }

  return 5;
}


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
  UIBezierPath *userObjectView = [UIBezierPath bezierPathWithRect:[self rectForObjectPosition:self.userObject.position]];
  [userObjectView fill];

  // draw enemies
  [[UIColor redColor] setFill];
  for (FTTEnemyObject *enemy in self.enemies) {
    UIBezierPath *enemyObjectPath = [UIBezierPath bezierPathWithRect:[self rectForObjectPosition:enemy.position]];
    [enemyObjectPath fill];
  }
}


# pragma mark - private


- (CGRect)rectForObjectPosition:(CGPoint)position {
  CGRect rect = CGRectMake(position.x - FTTObjectWidth() / 2, position.y - FTTObjectWidth() / 2, FTTObjectWidth(), FTTObjectWidth());

  return rect;
}


@end
