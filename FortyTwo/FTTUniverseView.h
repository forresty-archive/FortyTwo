//
//  FTTUniverseView.h
//  FortyTwo
//
//  Created by Forrest Ye on 8/11/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FTTUniverseViewDataSource.h"

static const NSUInteger FTTBombCooldownTime = 42;


@interface FTTUniverseView : UIView

@property (nonatomic) id<FTTUniverseViewDataSource> dataSource;

//@property (nonatomic) NSTimeInterval bombCooldownTime;

// temp
//@property (nonatomic) BOOL bombDeployed;

//- (void)deployBomb;

@end
