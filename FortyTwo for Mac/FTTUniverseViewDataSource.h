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
- (BOOL)bombAvailable;

// TODO: this seems not elegant
@property (nonatomic) BOOL bombDeployed;
@property (nonatomic) CGFloat percentCompleteOfBombRecharge;

@end
