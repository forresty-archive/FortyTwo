//
//  FTTUniverseView.h
//  FortyTwo
//
//  Created by Forrest Ye on 8/11/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import <UIKit/UIKit.h>


static const NSUInteger FTTBombCooldownTime = 42;


@protocol FTTUniverseViewDataSource <NSObject>

- (CGPoint)positionOfUserObject;
- (NSArray *)positionsOfEnemyObjects;

@end


@interface FTTUniverseView : UIView

@property (nonatomic) id<FTTUniverseViewDataSource> dataSource;

@property (nonatomic) NSTimeInterval bombCooldownTime;
@property (nonatomic, readonly) BOOL bombAvailable;

- (void)deployBomb;

@end
