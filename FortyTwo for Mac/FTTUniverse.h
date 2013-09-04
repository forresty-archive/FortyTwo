//
//  FTTUniverse.h
//  FortyTwo
//
//  Created by Forrest Ye on 9/4/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import <Foundation/Foundation.h>


@class FTTSpeedVector, FTTUserObject;


@interface FTTUniverse : NSObject

@property (nonatomic, readonly) FTTUserObject *userObject;
@property (nonatomic, readonly) NSMutableArray *enemies;

- (instancetype)initWithWidth:(NSUInteger)width height:(NSUInteger)height;

- (void)tick;

- (BOOL)userIsHit;

- (void)resetEnemies;

- (void)updateUserWithSpeedVector:(FTTSpeedVector *)speedVector;

@end
