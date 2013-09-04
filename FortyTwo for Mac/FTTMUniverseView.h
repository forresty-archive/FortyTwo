//
//  FTTMUniverseView.h
//  FortyTwo
//
//  Created by Forrest Ye on 8/28/13.
//  Copyright (c) 2013 Forrest Ye. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "FTTUniverseViewDataSource.h"


@class FTTUserObject;


@interface FTTMUniverseView : NSView

@property (nonatomic) id<FTTUniverseViewDataSource> dataSource;

//@property (nonatomic) NSTimeInterval timeElapsed;

//- (void)deployBomb;

@end
