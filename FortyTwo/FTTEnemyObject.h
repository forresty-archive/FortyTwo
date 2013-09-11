//
//  FTTEnemy.h
//  FortyTwo
//
//  Created by Forrest Ye on 8/11/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FTTObject.h"


@class FTTEnemyObject, FTTUserObject;


@protocol FTTEnemyObjectDelegate <NSObject>

- (void)enemyObject:(FTTEnemyObject *)enemyObject didMissTarget:(FTTUserObject *)userObject;

@end


@interface FTTEnemyObject : FTTObject

@property (nonatomic) CGFloat speedX;
@property (nonatomic) CGFloat speedY;
@property (nonatomic, weak) id<FTTEnemyObjectDelegate> delegate;

- (instancetype)initWithTargetUserObject:(FTTUserObject *)userObject;

- (void)resetSpeed;

// reset position and speed automatically if at the edge of the world
- (void)move;

- (BOOL)hitTarget;

+ (void)registerUniverseSize:(CGSize)universeSize;
+ (void)registerTimeToUserParam:(NSUInteger)param;

@end
