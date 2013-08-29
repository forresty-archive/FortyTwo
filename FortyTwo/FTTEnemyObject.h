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


@interface FTTEnemyObject : FTTObject

@property (nonatomic) CGFloat speedX;
@property (nonatomic) CGFloat speedY;

- (instancetype)initWithTargetUserObject:(FTTUserObject *)userObject;

- (void)resetPosition;

- (void)resetSpeed;

// reset position and speed automatically if at the edge of the world
- (void)move;

- (BOOL)hitTarget;

+ (void)registerUniverseSize:(CGSize)universeSize;
+ (void)registerTimeToUserParam:(NSUInteger)param;

@end
