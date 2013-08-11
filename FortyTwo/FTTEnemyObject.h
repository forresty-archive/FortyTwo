//
//  FTTEnemy.h
//  FortyTwo
//
//  Created by Forrest Ye on 8/11/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FTTObject.h"


@class FTTUserObject;

static inline CGFloat FTTObjectWidth() {
  if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
    return 8;
  }

  return 5;
}


@interface FTTEnemyObject : FTTObject

@property (nonatomic) CGFloat speedX;
@property (nonatomic) CGFloat speedY;

- (void)resetPosition;

- (void)resetSpeedWithUserObject:(FTTUserObject *)userObject;

// reset position and speed automatically if at the edge of the world
- (void)moveTowardsUserObject:(FTTUserObject *)userObject;

- (BOOL)hitUserObject:(FTTUserObject *)userObject;


@end
