//
//  FTTMUniverseViewDataSource.h
//  FortyTwo
//
//  Created by Forrest Ye on 9/4/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol FTTUniverseViewDataSource <NSObject>

// position of objects
- (CGPoint)positionOfUserObject;
- (NSArray *)positionsOfEnemyObjects;

// bomb
- (CGFloat)percentCompleteOfBombRecharge;
- (BOOL)bombAvailable;
- (BOOL)bombDeployed;

@end
