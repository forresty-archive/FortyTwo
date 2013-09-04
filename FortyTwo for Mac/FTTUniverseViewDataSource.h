//
//  FTTMUniverseViewDataSource.h
//  FortyTwo
//
//  Created by Forrest Ye on 9/4/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol FTTUniverseViewDataSource <NSObject>

- (CGPoint)positionOfUserObject;
- (NSArray *)positionsOfEnemyObjects;

@end
